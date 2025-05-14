import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/routes/sales/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
  return Card(
    elevation: 3,
    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    color: AppColors.cardBackGroundColor,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              product.imageURL,
              width: 90,
              height: 90,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  Icon(Icons.broken_image, size: 48),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  width: 90,
                  height: 90,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          SizedBox(width: 16),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                // Price Info
                Row(
                  children: [
                    Icon(FontAwesomeIcons.dollarSign, size: 14),
                    SizedBox(width: 4),
                    Text(
                      product.price.toInt().toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      product.oldPrice.toInt().toString(),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),

                // Discount %
                Row(
                  children: [
                    Icon(FontAwesomeIcons.percentage, size: 14),
                    SizedBox(width: 4),
                    Text(
                      product.percent.toInt().toString(),
                      style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Trending Down Arrows + Button
          Column(
            children: [
              Row(
               children: List.generate(
                  (() {
                    final percent = product.percent;
                    if (percent <= 0) return 0;
                    if (percent <= 10) return 1;
                    if (percent <= 50) return 2;
                    return 3;
                  })(),
                  (_) => Icon(
                    Icons.trending_down,
                    color: AppColors.normalIconColor,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(height: 12),
              
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TheProduct(product: product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackgroundColor,
                  foregroundColor: AppColors.buttonTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                child: Text("View"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
  }

class TheProduct extends StatelessWidget {
  final Product product;

  const TheProduct({super.key, required this.product});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: AppColors.appBarBackgroundColor,
      centerTitle: true,
      title: const Text('🔥🔥🔥', style: TextStyle(fontSize: 32)),
    ),
    backgroundColor: AppColors.bodyBackgroundColor, // 🔹 Sayfa arka planı burada
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16), // 🔹 Padding burada
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300, width: 1), // Kenar çizgisi
        ),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    product.imageURL,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Title
              Text(
                product.productName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 8),

              /// Prices
              Row(
                children: [
                  Text(
                    "\$${product.oldPrice.toInt()}",
                    style: const TextStyle(
                      fontSize: 16,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "\$${product.price.toInt()}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-${product.percent.toInt()}%",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// BUY BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => launchUniversalURL(product.saleURL),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("BUY NOW", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 20),

              /// Specifications
              if (product.property.isNotEmpty) ...[
                const Text(
                  "Specifications",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...product.property.map(
                  (prop) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 18, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            prop,
                            style: const TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
}


 




Future<void> launchUniversalURL(String url) async {
  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    // iOS'ta Safari, Android'de varsayılan tarayıcı
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    );
  } else {
    throw 'Could not launch $url';
  }
}