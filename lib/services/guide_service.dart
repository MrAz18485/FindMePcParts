import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/models/guide_model.dart';

class GuideService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _guidesCollection = _firestore.collection('guides');

  // Check if guides collection exists and list documents
  static Future<void> checkGuidesCollection() async {
    try {
      print('Checking guides collection...');
      final snapshot = await _guidesCollection.get();
      print('Guides collection has ${snapshot.docs.length} documents');

      for (var doc in snapshot.docs) {
        print('Found document: ${doc.id}');
      }
    } catch (e) {
      print('Error checking guides collection: $e');
    }
  }

  // Fetch all guides from Firebase
  static Future<Map<String, List<Guide>>> fetchGuides() async {
    try {
      print('Fetching guides from Firebase...');

      // First try to get all documents from the collection
      final QuerySnapshot snapshot = await _guidesCollection.get();
      print('Got ${snapshot.docs.length} guides from Firebase collection');

      // Group guides by tier
      Map<String, List<Guide>> result = {
        "Entry Level": [],
        "Mid Range": [],
        "High End": [],
      };

      // Process each document from the collection
      if (snapshot.docs.isNotEmpty) {
        for (var doc in snapshot.docs) {
          try {
            print('Processing document: ${doc.id}');
            final data = doc.data() as Map<String, dynamic>;

            // Add document ID to the data
            Map<String, dynamic> guideData = {
              ...data,
              'id': doc.id,
            };

            final guide = Guide.fromJson(guideData);
            print('Created guide with tier: ${guide.tier}');

            // Add to the appropriate tier
            if (result.containsKey(guide.tier)) {
              result[guide.tier]!.add(guide);
              print('Added guide to tier: ${guide.tier}');
            } else {
              print('Warning: Unknown tier ${guide.tier}, defaulting to Entry Level');
              result["Entry Level"]!.add(guide);
            }
          } catch (docError) {
            print('Error processing document ${doc.id}: $docError');
          }
        }
      } else {
        // If no documents found in collection, try specific IDs
        print('No documents found in collection, trying specific IDs');

        List<String> guideIds = [
          'AMD Entry Level',
          'Intel Entry Level',
          'AMD Mid Range',
          'Intel Mid Range',
          'AMD High End',
          'Intel High End'
        ];

        // Try to get each guide by ID
        for (String id in guideIds) {
          try {
            print('Fetching guide with ID: $id');
            DocumentSnapshot doc = await _guidesCollection.doc(id).get();

            if (doc.exists) {
              print('Document exists: $id');
              final data = doc.data() as Map<String, dynamic>;

              // Add document ID to the data
              Map<String, dynamic> guideData = {
                ...data,
                'id': doc.id,
              };

              final guide = Guide.fromJson(guideData);
              print('Created guide with tier: ${guide.tier}');

              // Determine which tier to add to based on ID
              String tier = "Entry Level";
              if (id.contains("Mid")) {
                tier = "Mid Range";
              } else if (id.contains("High")) {
                tier = "High End";
              }

              result[tier]!.add(guide);
              print('Added guide to tier: $tier');
            } else {
              print('Document does not exist: $id');
            }
          } catch (docError) {
            print('Error fetching document $id: $docError');
          }
        }
      }

      print('Final result: ${result.map((key, value) => MapEntry(key, value.length))} guides');

      // If we didn't get any guides, use mock data
      if (result.values.every((list) => list.isEmpty)) {
        print('No guides found in Firebase, using mock data');
        return _getMockGuides();
      }

      return result;
    } catch (e) {
      print('Error fetching guides from Firebase: $e');
      // If there's an error, use mock data
      print('Using mock data instead');
      return _getMockGuides();
    }
  }

  // Mock data to use when the Firebase call fails
  static Map<String, List<Guide>> _getMockGuides() {
    return {
      "Entry Level": [
        Guide(
          id: "amd-entry-level",
          title: "AMD Entry Level",
          cpu: "AMD Ryzen 5 5500",
          cpuUrl: "https://cdn03.ciceksepeti.com/cicek/kcm6868811-1/L/amd-ryzen-5-5500-6-core-3-60-4.20ghz-19mb-cache-65w-wraith-stealth-fan-am4-soket-box-kutulu-grafik-kart-yok-fan-var-kcm6868811-1-37517ff2cfdd487c9594d00c0cd00e71.jpg",
          gpu: "AMD Radeon RX 6600",
          gpuUrl: "https://productimages.hepsiburada.net/s/130/375-375/110000081134193.jpg",
          ram: "16GB DDR4",
          ramUrl: "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
          cooler: "Cooler Master Hyper 212",
          coolerUrl: "https://m.media-amazon.com/images/I/81o-F9OX7fL._AC_UF1000,1000_QL80_.jpg",
          pcCase: "NZXT H510",
          caseUrl: "https://cdn.akakce.com/_static/1009220864/nzxt-h510.png",
          price: "\$634.34",
          level: "entry",
          tier: "Entry Level",
          buyLink: "https://app.hb.biz/q3D5w6fpzIta",
        ),
        Guide(
          id: "intel-entry-level",
          title: "Intel Entry Level",
          cpu: "Intel Core i3-14100F",
          cpuUrl: "https://m.media-amazon.com/images/I/61ng+T6sKhL._AC_UF1000,1000_QL80_.jpg",
          gpu: "NVIDIA GeForce GTX 1650",
          gpuUrl: "https://m.media-amazon.com/images/I/61-XBUvVboL._AC_UF1000,1000_QL80_.jpg",
          ram: "16GB DDR4",
          ramUrl: "https://cdn.vatanbilgisayar.com/Upload/PRODUCT/crucial/thumb/131059-1_large.jpg",
          cooler: "Cooler Master Hyper 212",
          coolerUrl: "https://m.media-amazon.com/images/I/81o-F9OX7fL._AC_UF1000,1000_QL80_.jpg",
          pcCase: "NZXT H510",
          caseUrl: "https://cdn.akakce.com/_static/1009220864/nzxt-h510.png",
          price: "\$663.12",
          level: "entry",
          tier: "Entry Level",
          buyLink: "https://app.hb.biz/q3D5w6fpzIta",
        ),
      ],
      "Mid Range": [
        Guide(
          id: "amd-mid-range",
          title: "AMD Mid Range",
          cpu: "AMD Ryzen 5 7600",
          cpuUrl: "https://m.media-amazon.com/images/I/61SYYFOtJJL._AC_UF1000,1000_QL80_.jpg",
          gpu: "AMD Radeon RX 7700 XT",
          gpuUrl: "https://m.media-amazon.com/images/I/71Wkk4n9olL._AC_UF1000,1000_QL80_.jpg",
          ram: "32GB DDR5",
          ramUrl: "https://m.media-amazon.com/images/I/61K3FS0-IEL._AC_UF1000,1000_QL80_.jpg",
          cooler: "Noctua NH-D15",
          coolerUrl: "https://m.media-amazon.com/images/I/91Hw1zcWw4L._AC_UF1000,1000_QL80_.jpg",
          pcCase: "Fractal Design Meshify C",
          caseUrl: "https://m.media-amazon.com/images/I/81T0yEVD3FL._AC_UF1000,1000_QL80_.jpg",
          price: "\$1345.77",
          level: "mid",
          tier: "Mid Range",
          buyLink: "https://app.hb.biz/q3D5w6fpzIta",
        ),
      ],
      "High End": [
        Guide(
          id: "amd-high-end",
          title: "AMD High End",
          cpu: "AMD Ryzen 9 7950X3D",
          cpuUrl: "https://m.media-amazon.com/images/I/61lNpYEbS1L._AC_UF1000,1000_QL80_.jpg",
          gpu: "AMD Radeon RX 7900 XTX",
          gpuUrl: "https://m.media-amazon.com/images/I/71p75xLTTDL._AC_UF1000,1000_QL80_.jpg",
          ram: "32GB DDR5",
          ramUrl: "https://m.media-amazon.com/images/I/61K3FS0-IEL._AC_UF1000,1000_QL80_.jpg",
          cooler: "Corsair H150i",
          coolerUrl: "https://m.media-amazon.com/images/I/71EPdGyDJrL._AC_UF1000,1000_QL80_.jpg",
          pcCase: "Lian Li PC-O11 Dynamic",
          caseUrl: "https://m.media-amazon.com/images/I/61XmJPRcGhL._AC_UF1000,1000_QL80_.jpg",
          price: "\$2354.03",
          level: "high",
          tier: "High End",
          buyLink: "https://app.hb.biz/q3D5w6fpzIta",
        ),
      ],
    };
  }
}
