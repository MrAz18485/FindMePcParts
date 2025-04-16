import 'package:flutter/material.dart';
import 'package:findmepcparts/product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
    
      margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
      color: Colors.white, // Arka planı beyaz yapıyoruz
      shape: RoundedRectangleBorder(side: BorderSide(
        color: Colors.black),
        borderRadius: BorderRadius.circular(12), // Kartın kenarlarını yuvarlatıyoruz
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.productName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Soldaki Column: Ürün resmi ve bilgilerini tutacak
                Image.asset(
                  product.imageURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover, // Görselin uyumlu şekilde görünmesi için
                ),

                // Ürün bilgileri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.percent),
                        SizedBox(width: 1.5),
                        Text(
                          product.percent.toInt().toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Icon(FontAwesomeIcons.dollarSign),
                        SizedBox(width: 1.5),
                        Text(
                          product.price.toInt().toString(),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 13),
                    // trending down ikonları

                    // edit
                    Row(
                      children: [
                        if (product.percent > 10)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                        if (product.percent > 40)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                        if (product.percent > 80)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                      ],
                    ),
                    SizedBox(height: 10),
                    // "View" butonu
                    ElevatedButton(
                      onPressed: () {
                        // Sayfaya geçiş yapmak
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TheProduct(product: product),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Butonun arka plan rengi
                        foregroundColor: Colors.white, // Buton metninin rengi
                      ),
                      child: Text("View"),
                    )
                  ],
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
        backgroundColor: Colors.white,
        title: Text('🔥 🔥 🔥', style: TextStyle(fontSize: 40))
      ),
      body: 
      Container(
        color : Colors.white,
        child: ListView(
        children:[ 
          Card(
          margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
          color: Colors.white, // Arka planı beyaz yapıyoruz
          shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black),
            borderRadius: BorderRadius.circular(12), // Kartın kenarlarını yuvarlatıyoruz
            ),
          child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              product.productName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Soldaki Column: Ürün resmi ve bilgilerini tutacak
                Image.asset(
                  product.imageURL,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover, // Görselin uyumlu şekilde görünmesi için
                ),

                  ElevatedButton(
                    onPressed: () {
                      _launchURL(product.saleURL);
                    },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(140, 45),
                        backgroundColor: Colors.black, // Butonun arka plan rengi
                        foregroundColor: Colors.white, // Buton metninin rengi
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Yuvarlak köşeler
                        ),
                    ),
                    child: Text("BUY"),
                    )
              ],
            ),
            Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 15),
                        Text("Price: ",
                          style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),),
                        Icon(FontAwesomeIcons.dollarSign),
                        SizedBox(width: 1.5),
                        Text(
                          product.price.toInt().toString(),
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Discount Percent: ", style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),),
                        Icon(Icons.percent),
                        Text(product.percent.toInt().toString(), style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),),
                        SizedBox(width: 7,),
                        if (product.percent > 10)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                        if (product.percent > 40)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                        if (product.percent > 80)
                          Icon(Icons.trending_down,
                              color: Colors.black, size: 25),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
              side: BorderSide(
              color: Colors.black),
              borderRadius: BorderRadius.circular(6), // Kartın kenarlarını yuvarlatıyoruz
            ),
              child: Column(children: [
            Text("Product Specification:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
            Padding(padding: const EdgeInsets.all(1.0),
              child: Text(product.property, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
            )
            ],
            ),
            )
          ],
        ),
      ),
    )
        ],
      ),
    )
    );
  }
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  
  if (await canLaunchUrl(uri)) {
    // Safari içinde açılmasını zorunlu kıl
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}