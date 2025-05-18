import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

/// This utility class helps upload sample guide data to Firebase Firestore.
/// You can run this once to populate your database with initial data.
class FirebaseDataUploader {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _guidesCollection = _firestore.collection('guides');

  /// Call this method to upload sample guide data to Firebase
  static Future<void> uploadSampleGuides() async {
    try {
      // Entry Level Guides
      await _guidesCollection.doc('AMD Entry Level').set({
        "title": "AMD Entry Level",
        "cpu": "AMD Ryzen 5 5500",
        "cpu_url": "https://cdn03.ciceksepeti.com/cicek/kcm6868811-1/L/amd-ryzen-5-5500-6-core-3-60-4.20ghz-19mb-cache-65w-wraith-stealth-fan-am4-soket-box-kutulu-grafik-kart-yok-fan-var-kcm6868811-1-37517ff2cfdd487c9594d00c0cd00e71.jpg",
        "gpu": "AMD Radeon RX 6600",
        "gpu_url": "https://productimages.hepsiburada.net/s/130/375-375/110000081134193.jpg",
        "ram": "16GB DDR4",
        "ram_url": "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
        "level": "entry",
        "price": "\$634.34",
        "tier": "Entry Level",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      await _guidesCollection.doc('Intel Entry Level').set({
        "title": "Intel Entry Level",
        "cpu": "Intel Core i3-14100F",
        "cpu_url": "https://m.media-amazon.com/images/I/61ng+T6sKhL._AC_UF1000,1000_QL80_.jpg",
        "gpu": "NVIDIA GeForce GTX 1650",
        "gpu_url": "https://m.media-amazon.com/images/I/61-XBUvVboL._AC_UF1000,1000_QL80_.jpg",
        "ram": "16GB DDR4",
        "ram_url": "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
        "case": "NZXT H510",
        "case_url": "https://cdn.akakce.com/_static/1009220864/nzxt-h510.png",
        "cooler": "Cooler Master Hyper 212",
        "cooler_url": "https://m.media-amazon.com/images/I/81o-F9OX7fL._AC_UF1000,1000_QL80_.jpg",
        "price": "\$663.12",
        "level": "entry",
        "tier": "Entry Level",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      // Mid Range Guides
      await _guidesCollection.doc('AMD Mid Range').set({
        "title": "AMD Mid Range",
        "cpu": "AMD Ryzen 5 7600",
        "cpu_url": "https://m.media-amazon.com/images/I/61SYYFOtJJL._AC_UF1000,1000_QL80_.jpg",
        "gpu": "AMD Radeon RX 7700 XT",
        "gpu_url": "https://m.media-amazon.com/images/I/71Wkk4n9olL._AC_UF1000,1000_QL80_.jpg",
        "ram": "32GB DDR5",
        "ram_url": "https://m.media-amazon.com/images/I/61K3FS0-IEL._AC_UF1000,1000_QL80_.jpg",
        "cooler": "Noctua NH-D15",
        "cooler_url": "https://m.media-amazon.com/images/I/91Hw1zcWw4L._AC_UF1000,1000_QL80_.jpg",
        "case": "Fractal Design Meshify C",
        "case_url": "https://m.media-amazon.com/images/I/81T0yEVD3FL._AC_UF1000,1000_QL80_.jpg",
        "price": "\$1345.77",
        "level": "mid",
        "tier": "Mid Range",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      await _guidesCollection.doc('Intel Mid Range').set({
        "title": "Intel Mid Range",
        "cpu": "Intel Core i5-13400F",
        "cpu_url": "https://m.media-amazon.com/images/I/61ng+T6sKhL._AC_UF1000,1000_QL80_.jpg",
        "gpu": "NVIDIA RTX 4060 Ti",
        "gpu_url": "https://m.media-amazon.com/images/I/61-XBUvVboL._AC_UF1000,1000_QL80_.jpg",
        "ram": "32GB DDR4",
        "ram_url": "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
        "cooler": "Noctua NH-D15",
        "cooler_url": "https://m.media-amazon.com/images/I/91Hw1zcWw4L._AC_UF1000,1000_QL80_.jpg",
        "case": "Fractal Design Meshify C",
        "case_url": "https://m.media-amazon.com/images/I/81T0yEVD3FL._AC_UF1000,1000_QL80_.jpg",
        "price": "\$1234.56",
        "level": "mid",
        "tier": "Mid Range",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      // High End Guides
      await _guidesCollection.doc('AMD High End').set({
        "title": "AMD High End",
        "cpu": "AMD Ryzen 9 7950X3D",
        "cpu_url": "https://m.media-amazon.com/images/I/61lNpYEbS1L._AC_UF1000,1000_QL80_.jpg",
        "gpu": "AMD Radeon RX 7900 XTX",
        "gpu_url": "https://m.media-amazon.com/images/I/71p75xLTTDL._AC_UF1000,1000_QL80_.jpg",
        "ram": "32GB DDR5",
        "ram_url": "https://m.media-amazon.com/images/I/61K3FS0-IEL._AC_UF1000,1000_QL80_.jpg",
        "cooler": "Corsair H150i",
        "cooler_url": "https://m.media-amazon.com/images/I/71EPdGyDJrL._AC_UF1000,1000_QL80_.jpg",
        "case": "Lian Li PC-O11 Dynamic",
        "case_url": "https://m.media-amazon.com/images/I/61XmJPRcGhL._AC_UF1000,1000_QL80_.jpg",
        "price": "\$2354.03",
        "level": "high",
        "tier": "High End",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      await _guidesCollection.doc('Intel High End').set({
        "title": "Intel High End",
        "cpu": "Intel Core i7-14700K",
        "cpu_url": "https://m.media-amazon.com/images/I/61ng+T6sKhL._AC_UF1000,1000_QL80_.jpg",
        "gpu": "NVIDIA GeForce RTX 4080",
        "gpu_url": "https://m.media-amazon.com/images/I/61-XBUvVboL._AC_UF1000,1000_QL80_.jpg",
        "ram": "32GB DDR5",
        "ram_url": "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
        "cooler": "Corsair H150i",
        "cooler_url": "https://m.media-amazon.com/images/I/71EPdGyDJrL._AC_UF1000,1000_QL80_.jpg",
        "case": "Lian Li PC-O11 Dynamic",
        "case_url": "https://m.media-amazon.com/images/I/61XmJPRcGhL._AC_UF1000,1000_QL80_.jpg",
        "price": "\$2427.89",
        "level": "high",
        "tier": "High End",
        "buy_link": "https://app.hb.biz/q3D5w6fpzIta",
      });

      print('Sample guides uploaded successfully!');
    } catch (e) {
      print('Error uploading sample guides: $e');
    }
  }

  /// A simple UI to trigger the data upload
  static Widget buildUploaderUI() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Data Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await uploadSampleGuides();
              },
              child: const Text('Upload Sample Guides to Firebase'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: This will add sample guides to your Firebase database.\n'
              'Only use this once to initialize your data.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
