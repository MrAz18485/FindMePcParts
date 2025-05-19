
import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/routes/sales/product.dart';
import 'package:findmepcparts/routes/sales/product_card.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/util/text_styles.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Product>> fetchProducts() async {
  final firestore = FirebaseFirestore.instance;
  final querySnapshot = await firestore.collection('onsale').get();
  
  List<Product> products = [];
  
  for (var doc in querySnapshot.docs) {
    // Firestore'dan gelen veriyi Product'a dönüştür
    var productData = doc.data();
    products.add(Product.fromMap(productData));
  }
  
  return products;
}
Future<List<Product>> products =  fetchProducts();

class OnSale extends StatelessWidget {
  const OnSale({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.appBarBackgroundColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'On Fire',
              style: appBarTitleTextStyle,
            ),
            SizedBox(width: 8),
            Text('🔥', style: TextStyle(fontSize: 40))
          ],
        ),
      ),
      body: Container(
        color: AppColors.bodyBackgroundColor,
        child: FutureBuilder<List<Product>>(
          future: fetchProducts(), // Veriyi çekmek için Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Veriler yükleniyorsa bir yükleniyor spinner'ı göster
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Hata varsa hata mesajı göster
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Veriler yoksa bir mesaj göster
              return Center(child: Text('No products available.'));
            } else {
              // Veriler geldiyse, listeyi göster
              List<Product> products = snapshot.data!;
              return ListView(
                children: products.map((product) => ProductCard(product: product)).toList(),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}