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
    
      margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
      color: AppColors.cardBackGroundColor, 
      shape: RoundedRectangleBorder(side: BorderSide(
        color: AppColors.normalIconColor),
        borderRadius: BorderRadius.circular(12), 
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
               
                Image.asset(
                  product.imageURL,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),

                
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

                    
                    Row(
                      children: [
                        if (product.percent > 10)
                          Icon(Icons.trending_down,
                              color: AppColors.normalIconColor, size: 25),
                        if (product.percent > 40)
                          Icon(Icons.trending_down,
                              color: AppColors.normalIconColor, size: 25),
                        if (product.percent > 80)
                          Icon(Icons.trending_down,
                              color: AppColors.normalIconColor, size: 25),
                      ],
                    ),
                    SizedBox(height: 10),
               
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
        backgroundColor: AppColors.appBarBackgroundColor,
        centerTitle: true,
        title: Text('🔥 🔥 🔥', style: TextStyle(fontSize: 40)),
      ),
      body: 
      Container(
        color : AppColors.bodyBackgroundColor,
        child: ListView(
        children:[ 
          Card(
          margin: EdgeInsets.fromLTRB(10, 6, 10, 6),
          color: AppColors.bodyBackgroundColor, 
          shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black),
            borderRadius: BorderRadius.circular(12),
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
                Image.asset(
                  product.imageURL,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover, 
                ),

                  ElevatedButton(
                    onPressed: () {
                      launchUniversalURL(product.saleURL);
                    },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(140, 45),
                        backgroundColor: AppColors.buttonBackgroundColor, 
                        foregroundColor: AppColors.buttonTextColor, 
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                              color: AppColors.normalIconColor, size: 25),
                        if (product.percent > 40)
                          Icon(Icons.trending_down,
                              color: AppColors.normalIconColor, size: 25),
                        if (product.percent > 80)
                          Icon(Icons.trending_down,
                              color: AppColors.normalIconColor, size: 25),
                        ],
                      ),
                    ],
                  ),
            SizedBox(height: 10),
            Card(
              color: AppColors.bodyBackgroundColor,
              shape: RoundedRectangleBorder(
              side: BorderSide(
              color: AppColors.bodyIconColor),
              borderRadius: BorderRadius.circular(6), 
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