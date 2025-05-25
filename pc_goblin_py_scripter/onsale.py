import json
import time
import random
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium_stealth import stealth
from bs4 import BeautifulSoup

# JSON objeleri oluşturuluyor
product_list = []

# Selenium için tarayıcı seçeneklerini belirle
options = Options()
options.add_argument("start-maximized")
options.add_argument("disable-blink-features=AutomationControlled")
options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36")

# WebDriver başlatılıyor
driver = webdriver.Chrome(options=options)

# Stealth ayarları
stealth(driver,
        languages=["en-US", "en"],
        vendor="Google Inc.",
        platform="Win32",
        webgl_vendor="Intel Inc.",
        renderer="Intel Iris OpenGL Engine",
        fix_hairline=True,
)

# URL'yi aç
driver.get("https://www.newegg.com/Shell-Shocker/EventSaleStore/ID-10381?Order=7")
time.sleep(random.randint(8, 8))  # Gerçekçi bekleme

# Sayfanın HTML içeriğini al
html = driver.page_source
soup = BeautifulSoup(html, "html.parser")

# Ürün kutularını bul
product_boxes = soup.find_all("div", class_="goods-container")[:23]

for box in product_boxes:
    try:
        link_tag = box.find("a", class_="goods-title")
        url = link_tag["href"] if link_tag else None
        title = link_tag.text.strip() if link_tag else "Başlık yok"

        old_price_tag = box.find("div", class_="goods-price-was")
        new_price_tag = box.find("div", class_="goods-price-current")
        old_price = old_price_tag.text.strip().replace('$', '') if old_price_tag else None
        new_price = new_price_tag.find("strong").text.strip() + new_price_tag.find("sup").text.strip() if new_price_tag else None

        if not url or not new_price or not old_price:
            continue

        # Discount hesapla
        discount_ratio = None
        try:
            old_price_value = float(old_price.replace(',', ''))
            new_price_value = float(new_price.replace(',', ''))
            discount_ratio = int(round((old_price_value - new_price_value) / old_price_value * 100))
        except ValueError:
            continue

        img_tag = box.find("img", class_="checkedimg2")
        image_url = img_tag.get("src") if img_tag else None

        # Ürün detay sayfasına git
        driver.get(url)
        time.sleep(random.randint(4, 6))

        detail_html = driver.page_source
        detail_soup = BeautifulSoup(detail_html, "html.parser")
        bullets = detail_soup.select("div.product-bullets li")
        feature_list = [li.get_text(strip=True) for li in bullets]

        # JSON objesi
        product = {
            "title": title,
            "oldprice": old_price_value,
            "price": new_price_value,
            "discountratio": discount_ratio,
            "imagelink": image_url,
            "url": url,
            "features": feature_list
        }

        product_list.append(product)

    except Exception as e:
        print(f"Hata oluştu: {e}")
        continue

driver.quit()

# JSON çıktısını al (opsiyonel)
print(json.dumps(product_list, indent=4))

# Firestore kısmı
import firebase_admin
from firebase_admin import credentials, firestore
"""
cred = credentials.Certificate("/Users/kerem/Desktop/frbot/pcgoblin_onsale_bot/fir-testing-3494f-09a99fee9aad.json")
firebase_admin.initialize_app(cred)

db = firestore.client()

# Silinecek koleksiyon adı
collection_name = "onsale"

# Koleksiyondaki tüm dökümanları sil
docs = db.collection(collection_name).stream()

for doc in docs:
    print(f"Siliniyor: {doc.id}")
    doc.reference.delete()


for product in product_list:
    db.collection("onsale").add(product)  # add() otomatik ID ile doküman ekler

print("Veriler başarıyla Firestore’a yüklendi!")"""
