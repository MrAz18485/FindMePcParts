import time
import random
import json
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium_stealth import stealth
from bs4 import BeautifulSoup
import firebase_admin
from firebase_admin import credentials, firestore

# Chrome options
options = Options()
# options.add_argument("--headless")  # Uncomment for headless
options.add_argument("start-maximized")
options.add_argument("disable-blink-features=AutomationControlled")
options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36")

# Initialize Chrome driver
driver = webdriver.Chrome(options=options)

# Apply stealth settings
stealth(driver,
        languages=["en-US", "en"],
        vendor="Google Inc.",
        platform="Win32",
        webgl_vendor="Intel Inc.",
        renderer="Intel Iris OpenGL Engine",
        fix_hairline=True,
)

base_url = "https://pcpartpicker.com"
main_url = f"{base_url}/products/internal-hard-drive/"
driver.get(main_url)

# Wait for page to load
time.sleep(random.uniform(10, 11))

# Get all product basic info first
soup = BeautifulSoup(driver.page_source, "html.parser")
ssd_rows = soup.find_all("tr", class_="tr__product")[:]  # First 38 SSDs

products = []
for row in ssd_rows:
    a_tag = row.find("a", href=True)
    if not a_tag:
        continue
    
    name_tag = a_tag.find("p")
    name = name_tag.get_text(strip=True) if name_tag else "N/A"
        # Image URL
    image_tag = a_tag.find("img")
    image = image_tag['src'] if image_tag else "N/A"
    if image.startswith("//"):
        image = "https:" + image
    elif image.startswith("/"):
        image = base_url + image

    detail_url = base_url + a_tag['href']
    
    products.append({
        "name": name,
        "image": image ,
        "url": detail_url
    })

# Now process each detail page
results = []

for product in products:
    if(len(results) >= 40):
        break;
    try:
        driver.get(product["url"])
        time.sleep(random.uniform(1, 2))
        
        detail_soup = BeautifulSoup(driver.page_source, "html.parser")

        # Extract specifications with simplified keys
        specs = {}
        spec_mapping = {
            "manufacturer": "Manufacturer",
            "part_number": "Part #",
            "capacity": "Capacity",
            "price_per_gb": "Price / GB",
            "type": "Type",
            "cache": "Cache",
            "form_factor": "Form Factor",
            "interface": "Interface",
            "nvme": "NVME"
        }

        for key, label in spec_mapping.items():
            try:
                if key == "part_number":
                    # Special handling for part numbers which might be a list
                    part_numbers = []
                    part_number_elements = detail_soup.find("h3", string=lambda t: label in str(t)).find_next_sibling("div").find_all("li")
                    for li in part_number_elements:
                        part_numbers.append(li.get_text(strip=True))
                    specs[key] = part_numbers
                else:
                    spec_element = detail_soup.find("h3", string=lambda t: label in str(t)).find_next_sibling("div").find("p")
                    spec_value = spec_element.get_text(strip=True)
                    specs[key] = spec_value
            except:
                specs[key] = "N/A"

        # Extract price information
       # Extract price information
        price = "N/A"
        buy_url = "N/A"
        try:
            price_rows = detail_soup.select("tbody tr:not(.tr--noBorder)")
            if price_rows:
                prices_data = []
                for row in price_rows:
                    try:
                        # Get base price
                        base_price_td = row.select_one("td.td__base")
                        if not base_price_td:
                            continue
                        price_text = base_price_td.get_text(strip=True)
                        
                        # Get final price link
                        final_price_a = row.select_one("td.td__finalPrice a")
                        if not final_price_a:
                            continue
                        price_url = final_price_a['href']
                        
                        # Get shipping cost
                        shipping_td = row.select_one("td.td__shipping")
                        shipping_cost = 0
                        if shipping_td:
                            shipping_text = shipping_td.get_text(strip=True)
                            if "FREE" in shipping_text:
                                shipping_cost = 0
                            else:
                                # Extract numeric value from shipping text
                                shipping_numbers = ''.join([c for c in shipping_text if c.isdigit() or c == '.'])
                                if shipping_numbers:
                                    shipping_cost = float(shipping_numbers)
                        
                        # Calculate total price
                        try:
                            price_value = float(price_text.replace('$', '').replace(',', ''))
                            total_price = price_value + shipping_cost
                            prices_data.append((total_price, price_text, price_url))
                        except ValueError:
                            continue
                        
                    except Exception as e:
                        print(f"Price row parsing error for {product['name']}: {str(e)}")
                        continue
                
                if prices_data:
                    min_price = min(prices_data, key=lambda x: x[0])
                    price = min_price[1]
                    buy_url = min_price[2]
        except Exception as e:
            print(f"Price extraction error for {product['name']}: {str(e)}")

        # Fiyat yoksa ekleme
        if price == "N/A":
            print(f"Skipped (no price): {product['name']}")
            continue
        
        # Prepare final product data
        product_data = {
            "name": product["name"],
            "image": product["image"],
            **specs,
            "price": price,
            "buy_url": buy_url
        }
        
        results.append(product_data)
        print(f"Processed: {product['name']} - Price: {price}")

    except Exception as e:
        print(f"Error processing {product['name']}: {str(e)}")
        results.append({
            "name": product["name"],
            "image": product["image"],
            **{k: "N/A" for k in spec_mapping.keys()},
            "price": "N/A",
            "buy_url": "N/A"
        })

driver.quit()

# Save to JSON file
with open("ssd_data.json", "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2, ensure_ascii=False)

print("\nScraping complete. Results:")
print(f"Total products processed: {len(results)}")
print(f"Saved to storages.json")


# Firebase operations
cred = credentials.Certificate("/Users/kerem/Desktop/frbot/pcgoblin_onsale_bot/fir-testing-3494f-09a99fee9aad.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# Clear existing collection
collection_name = "storages"
docs = db.collection(collection_name).stream()
for doc in docs:
    print(f"Deleting: {doc.id}")
    doc.reference.delete()

# Upload new data
for storage in results:
    db.collection("storages").add(storage)

print("Data successfully uploaded to Firestore!")
