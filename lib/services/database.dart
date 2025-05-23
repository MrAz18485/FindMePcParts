import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmepcparts/routes/builder/build.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmepcparts/routes/builder/part.dart';

class DatabaseService {
  final String uid;
  final bool isGuest;

  static const String _guestBuildsKey = 'guest_builds';
  List<Map<String, dynamic>>? _cachedGuestBuilds;

  DatabaseService({required this.uid}) : isGuest = FirebaseAuth.instance.currentUser == null;

  final CollectionReference userDataCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference buildsCollection = FirebaseFirestore.instance.collection('builds');

  // 🔐 Kullanıcı Bilgileri Güncelleme
  Future updateUserData (String username, String name, String surname, String email, String registeredAt) async {
    return await userDataCollection.doc(uid).set({
      'username': username,
      'name': name,
      'surname': surname,
      'email': email,
      'registered_at': registeredAt,
    });
  }

  Future updateUserSingleField(String field, String value) async {
    return await userDataCollection.doc(uid).update({field: value});
  }

  Future fetchUserData(String username) async {
    QuerySnapshot qs = await userDataCollection.get();
    for (var row in qs.docs) {
      if (row["username"] == username) {
        throw "Username exists!";
      }
    }
  }

  // 💾 Build Getirme
  Future<List<Map<String, dynamic>>> fetchBuilds(String username) async {
    try {
      if (isGuest) {
        if (_cachedGuestBuilds != null) {
          print('[CACHE] Guest builds from memory.');
          return _cachedGuestBuilds!;
        }

        final prefs = await SharedPreferences.getInstance();
        final String? buildsJson = prefs.getString(_guestBuildsKey);
        if (buildsJson == null) return [];

        List<dynamic> buildsList = jsonDecode(buildsJson);
        _cachedGuestBuilds = buildsList.map((b) => b as Map<String, dynamic>).toList();

        print('[DISK] Guest builds loaded.');
        return _cachedGuestBuilds!;
      } else {
        QuerySnapshot qs = await buildsCollection
            .where("uid", isEqualTo: uid)
            .get();

        return qs.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      }
    } catch (e) {
      print('Error in fetchBuilds: $e');
      rethrow;
    }
  }

  // 💾 Build Kaydetme
  Future<String> saveBuild(String username, Build build) async {
    if (isGuest) {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> builds = _cachedGuestBuilds ?? [];

      Map<String, dynamic> buildData = build.toMap();
      buildData['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      builds.add(buildData);

      _cachedGuestBuilds = builds;
      await prefs.setString(_guestBuildsKey, jsonEncode(builds));
      return buildData['id'];
    } else {
      DocumentReference docRef = await buildsCollection.add({
        'uid': uid,
        'name': build.name,
        'parts': build.parts.map((part) => {
          'name': part.name,
          'category': part.category,
          'price': part.price,
          'imageUrl': part.imageUrl,
        }).toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    }
  }

  // 🔄 Build Güncelleme
  Future<void> updateBuild(String buildId, Build build) async {
    if (isGuest) {
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> builds = _cachedGuestBuilds ?? [];

      int index = builds.indexWhere((b) => b['id'] == buildId);
      if (index != -1) {
        builds[index] = build.toMap();
        builds[index]['id'] = buildId;

        _cachedGuestBuilds = builds;
        await prefs.setString(_guestBuildsKey, jsonEncode(builds));
      }
    } else {
      await buildsCollection.doc(buildId).update({
        'name': build.name,
        'parts': build.parts.map((part) => {
          'name': part.name,
          'category': part.category,
          'price': part.price,
          'imageUrl': part.imageUrl,
        }).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // 🗑️ Build Silme
  Future<void> deleteBuild(String buildId) async {
    final prefs = await SharedPreferences.getInstance();
    if (!isGuest) {
      List<Map<String, dynamic>> builds = _cachedGuestBuilds ?? [];

      builds.removeWhere((build) => build['id'] == buildId);
      _cachedGuestBuilds = builds;
      await prefs.setString(_guestBuildsKey, jsonEncode(builds));
      await buildsCollection.doc(buildId).delete();
    }
    else
    {
      prefs.remove(_guestBuildsKey);
    }
  }

  void clearGuestCache() {
    _cachedGuestBuilds = null;
  }

  // 🔍 Parça Verileri
  Future<List<Map<String, dynamic>>> fetchParts() async {
    QuerySnapshot qs = await FirebaseFirestore.instance.collection("parts").get();
    return qs.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

Future<List<Map<String, dynamic>>> fetchPartsByCategory(String category, {List<Part>? selectedParts}) async {
  try {
    String collectionName = '';
    switch (category.toLowerCase()) {
      case 'processor (cpu)': collectionName = 'CPUs'; break;
      case 'gpu': collectionName = 'GPUs'; break;
      case 'cpu cooler': collectionName = 'cpu_coolers'; break;
      case 'motherboard': collectionName = 'motherboards'; break;
      case 'memory': collectionName = 'memory'; break;
      case 'storage': collectionName = 'storages'; break;
      case 'power supply': collectionName = 'psu'; break;
      case 'case': collectionName = 'cases'; break;
      default:
        print('Unknown category: $category');
        return [];
    }

    QuerySnapshot qs = await FirebaseFirestore.instance.collection(collectionName).get();

    // Cooler bringer
if (category.toLowerCase() == 'cpu cooler' && selectedParts != null) {
      QuerySnapshot? cpuFilteredQs;
      List<QueryDocumentSnapshot>? mbFilteredDocs;
      
      // CPU uyumluluğu kontrolü
      if (selectedParts[0].price > 0) {
      String cpuSocket = selectedParts[0].attributes['socket'] ?? '';
      if (cpuSocket.isNotEmpty) {
          cpuFilteredQs = await FirebaseFirestore.instance
            .collection(collectionName)
            .where('cpu_socket', arrayContains: cpuSocket)
            .get();
          if (cpuFilteredQs.docs.isEmpty) {
            return [];
          }
        }
      }
      
      // Motherboard uyumluluğu kontrolü
      if (selectedParts[2].price > 0) {
        String motherboardSocket = selectedParts[2].attributes['socket'] ?? '';
        if (motherboardSocket.isNotEmpty) {
          // Önce tüm cooler'ları al
          final allCoolers = await FirebaseFirestore.instance.collection(collectionName).get();
          
          // Motherboard socket'ine uyumlu olanları filtrele
          mbFilteredDocs = allCoolers.docs.where((doc) {
            final data = doc.data();
            final supportedSockets = List<String>.from(data['cpu_socket'] ?? []);
            return supportedSockets.contains(motherboardSocket);
          }).toList();
          
          if (mbFilteredDocs.isEmpty) {
            return [];
          }
        }
      }

      // Her iki filtreleme de yapıldıysa, kesişim kümesini bul
      if (cpuFilteredQs != null && mbFilteredDocs != null) {
        final cpuIds = cpuFilteredQs.docs.map((doc) => doc.id).toSet();
        final mbIds = mbFilteredDocs.map((doc) => doc.id).toSet();
        
        // Her iki kümede de olan ID'leri bul
        final commonIds = cpuIds.intersection(mbIds);
        
        if (commonIds.isEmpty) {
          return [];
        }

        // Ortak ID'lere sahip dokümanları al
        final filtered = cpuFilteredQs.docs.where((doc) => commonIds.contains(doc.id)).toList();
        
        return filtered.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['category'] = category;
          return data;
        }).toList();
      }
      
      // Sadece CPU filtresi varsa
      if (cpuFilteredQs != null) {
        return cpuFilteredQs.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['category'] = category;
          return data;
        }).toList();
      }
      
      // Sadece motherboard filtresi varsa
      if (mbFilteredDocs != null) {
        return mbFilteredDocs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['category'] = category;
          return data;
        }).toList();
      }

      // Hiçbir filtre yoksa tüm cooler'ları getir
      return qs.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['category'] = category;
        return data;
      }).toList();
    }
    
   // CPU bringer
else if (category.toLowerCase() == 'processor (cpu)' && selectedParts != null) {
  final allCPUsSnapshot = await FirebaseFirestore.instance.collection(collectionName).get();
  final allCPUsDocs = allCPUsSnapshot.docs;

  Set<String>? commonIds;

  // PSU filtresi
  if (selectedParts[6].price > 0) {
    double wattage = double.tryParse((selectedParts[6].attributes['wattage'] ?? '0').split(' ').first) ?? 0;
    wattage *= 0.8;
    if (selectedParts[3].price > 0) {
      wattage -= double.tryParse((selectedParts[3].attributes['tdp'] ?? '0').split(' ').first) ?? 0;
    }
    final psuIds = allCPUsDocs.where((doc) {
      final tdp = double.tryParse((doc['tdp'] ?? '0').toString().split(' ').first) ?? 0;
      return tdp <= wattage;
    }).map((doc) => doc.id).toSet();
    commonIds = psuIds;
  }

  // Cooler filtresi
  if (selectedParts[1].price > 0) {
    final coolerSockets = List<String>.from(selectedParts[1].attributes['cpu_socket'] ?? []);
    final coolerIds = allCPUsDocs.where((doc) {
      return coolerSockets.contains(doc['socket'] ?? '');
    }).map((doc) => doc.id).toSet();
    commonIds = commonIds?.intersection(coolerIds) ?? coolerIds;
  }

  // Motherboard filtresi
  if (selectedParts[2].price > 0) {
    final mbSocket = selectedParts[2].attributes['socket'] ?? '';
    final mbIds = allCPUsDocs.where((doc) {
      return doc['socket'] == mbSocket;
    }).map((doc) => doc.id).toSet();
    commonIds = commonIds?.intersection(mbIds) ?? mbIds;
  }

  if (commonIds == null) {
    return allCPUsDocs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  }

  if (commonIds.isEmpty) return [];

  return allCPUsDocs.where((doc) => commonIds!.contains(doc.id)).map((doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    data['category'] = category;
    return data;
  }).toList();
}

    // Motherboard Bringer
else if (category.toLowerCase() == 'motherboard' && selectedParts != null)  {
      QuerySnapshot? cpuFilteredQs;
      QuerySnapshot? memoryFilteredQs;
      List<QueryDocumentSnapshot>? coolerFilteredDocs;
      List<QueryDocumentSnapshot>? caseFilteredDocs;
      
      // CPU uyumluluğu kontrolü
      if (selectedParts[0].price > 0) {
        String cpuSocket = selectedParts[0].attributes['socket'] ?? '';
        if (cpuSocket.isNotEmpty) {
          cpuFilteredQs = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('socket', isEqualTo: cpuSocket)
              .get();
          if (cpuFilteredQs.docs.isEmpty) {
            return [];
          }
        }
      }
      
      // Cooler uyumluluğu kontrolü
      if (selectedParts[1].price > 0) {
        List<String> coolerSockets = List<String>.from(selectedParts[1].attributes['cpu_socket'] ?? []);
        if (coolerSockets.isNotEmpty) {
          // Önce tüm motherboard'ları al
          final allMotherboards = await FirebaseFirestore.instance.collection(collectionName).get();
          
          // Cooler socket'lerine uyumlu olanları filtrele
          coolerFilteredDocs = allMotherboards.docs.where((doc) {
            final data = doc.data();
            final socket = data['socket'] ?? '';
            return coolerSockets.contains(socket);
          }).toList();
          
          if (coolerFilteredDocs.isEmpty) {
            return [];
          }
        }
      }

      // Memory uyumluluğu kontrolü
      if (selectedParts[4].price > 0) {
        String memoryType = selectedParts[4].attributes['speed'].split('-')[0] ?? '';
        if (memoryType.isNotEmpty) {
          memoryFilteredQs = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('memory_type', isEqualTo: memoryType)
              .get();
          if (memoryFilteredQs.docs.isEmpty) {
            return [];
          }
        }
      }

      // Case uyumluluğu kontrolü
      if (selectedParts[7].price > 0) {
        List<String> caseType = List<String>.from(selectedParts[7].attributes['motherboard_form_factor'] ?? []);
        if (caseType.isNotEmpty) {
          // Önce tüm motherboard'ları al
          final allMotherboards = await FirebaseFirestore.instance.collection(collectionName).get();
          
          // Case form factor'lerine uyumlu olanları filtrele
          caseFilteredDocs = allMotherboards.docs.where((doc) {
            final data = doc.data();
            final factor = data['form_factor'] ?? '';
            return caseType.contains(factor);
          }).toList();
          
          if (caseFilteredDocs.isEmpty) {
            return [];
          }
        }
      }

      // Tüm filtrelerin kesişimini bul
      Set<String>? commonIds;
      
      // CPU filtresi varsa
      if (cpuFilteredQs != null) {
        commonIds = cpuFilteredQs.docs.map((doc) => doc.id).toSet();
      }
      
      // Cooler filtresi varsa
      if (coolerFilteredDocs != null) {
        final coolerIds = coolerFilteredDocs.map((doc) => doc.id).toSet();
        commonIds = commonIds?.intersection(coolerIds) ?? coolerIds;
      }
      
      // Memory filtresi varsa
      if (memoryFilteredQs != null) {
        final memoryIds = memoryFilteredQs.docs.map((doc) => doc.id).toSet();
        commonIds = commonIds?.intersection(memoryIds) ?? memoryIds;
      }
      
      // Case filtresi varsa
      if (caseFilteredDocs != null) {
        final caseIds = caseFilteredDocs.map((doc) => doc.id).toSet();
        commonIds = commonIds?.intersection(caseIds) ?? caseIds;
      }

      // Tüm motherboard'ları al
      final allMotherboards = await FirebaseFirestore.instance.collection(collectionName).get();
      
      // Eğer hiç filtre yoksa tüm motherboard'ları getir
      if (commonIds == null) {
        return allMotherboards.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          data['category'] = category;
          return data;
        }).toList();
      }

      // Eğer kesişim boşsa boş liste dön
      if (commonIds.isEmpty) {
        return [];
      }

      // Tüm filtrelere uyan motherboard'ları getir
      final filtered = allMotherboards.docs.where((doc) => commonIds!.contains(doc.id)).toList();

          return filtered.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            data['category'] = category;
            return data;
          }).toList();
        }
    // GPU bringer
else if (category.toLowerCase() == 'gpu' && selectedParts != null) {
  QuerySnapshot? wattageFilteredQs;
  List<QueryDocumentSnapshot>? compatibleDocs;
  double sum = 0;
  
  // Varsa işlemci gücünü ekle
  if (selectedParts[0].price > 0) {
    String? tdpStr = selectedParts[0].attributes['tdp']; // örn: "125 W"
    double tdp = double.tryParse(tdpStr?.split(' ').first ?? '0') ?? 0;
    sum += tdp;
  }
  
  // PSU'den küçük olmalı uyumluluğu kontrolü
  if (selectedParts[6].price > 0) {
    String? wattStr = selectedParts[6].attributes['wattage'];
    int watt = 0;
    
    if (wattStr != null && wattStr.contains(' ')) {
      watt = int.tryParse(wattStr.split(' ')[0]) ?? 0;
      
      // Tüm dokümanları çek
      wattageFilteredQs = await FirebaseFirestore.instance
        .collection(collectionName)
        .get();
      
      // Filtrelemeyi client-side (Dart tarafında) yap
      compatibleDocs = wattageFilteredQs.docs.where((doc) {
        final tdpStr = doc['tdp']; // örn: "300 W"
        final tdpInt = int.tryParse(tdpStr.toString().split(' ')[0]) ?? 0;
        return (tdpInt + sum) < (watt * 0.8);
      }).toList();
      
      if (compatibleDocs.isEmpty) {
        return [];
      }
    }
  }
  
  // Eğer compatibleDocs varsa onları döndür
  if (compatibleDocs != null) {
    return compatibleDocs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  }
  
  // Hiçbir filtre yoksa tüm GPU'ları getir
  return qs.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    data['category'] = category;
    return data;
  }).toList();
}

    // Memory bringer
else if (category.toLowerCase() == 'memory' && selectedParts != null) {
  QuerySnapshot? motherboardFilteredQs;
  List<QueryDocumentSnapshot>? compatibleDocs;

  if (selectedParts[2].price > 0) {
    String? memory = selectedParts[2].attributes['memory_type'];


    if (memory != null) {
      motherboardFilteredQs = await FirebaseFirestore.instance
          .collection(collectionName)
          .get();

      compatibleDocs = motherboardFilteredQs.docs.where((doc) {


        return (doc['speed'].split('-')[0] == memory);
      }).toList();


      if (compatibleDocs.isEmpty) {
 
        return [];
      }
    }
  }

  if (compatibleDocs != null) {
    return compatibleDocs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  }

  // Eğer filtre yoksa tüm RAM'leri getir
  return qs.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    data['category'] = category;
    return data;
  }).toList();
}

// PSU bringer
else if (category.toLowerCase() == 'power supply' && selectedParts != null) {
  QuerySnapshot? wattageFilteredQs;
  double sum = 0;

  // İşlemci gücünü ekle
  if (selectedParts[0].price > 0) {
    String? tdpStr = selectedParts[0].attributes['tdp']; // örneğin: "125 W"
    double tdp = double.tryParse(tdpStr?.split(' ').first ?? '0') ?? 0;
    sum += tdp;
  }

  // GPU gücünü ekle
  if (selectedParts[3].price > 0) {
    String? tdpStr = selectedParts[3].attributes['tdp']; // örneğin: "125 W"
    double tdp = double.tryParse(tdpStr?.split(' ').first ?? '0') ?? 0;
    sum += tdp;
  }

  // Tüm dokümanları çek
  wattageFilteredQs = await FirebaseFirestore.instance
      .collection(collectionName)
      .get();

  if (sum > 0) {
    // Filtreleme
    final compatibleDocs = wattageFilteredQs.docs.where((doc) {
      final wattStr = doc['wattage']; // örn: "750 W"
      final wattInt = int.tryParse(wattStr.toString().split(' ')[0]) ?? 0;
      return wattInt >= (sum * 1.25); // PSU gücü toplam güçten %25 fazla olmalı
    }).toList();

    if (compatibleDocs.isEmpty) {
      return [];
    }

    // Filtrelenmiş PSU'ları dön
    return compatibleDocs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  }

  // Filtre yoksa tüm PSU'ları dön
  return wattageFilteredQs.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    data['category'] = category;
    return data;
  }).toList();
}

// Case bringer
else if (category.toLowerCase() == 'case' && selectedParts != null) {
  List<QueryDocumentSnapshot>? mbFilteredDocs;

  // Motherboard uyumluluğu kontrolü
// Motherboard uyumluluğu kontrolü
  if (selectedParts[2].price > 0) {
    String motherboardForm = selectedParts[2].attributes['form_factor'] ?? '';
    if (motherboardForm.isNotEmpty) {
      // Önce tüm kasaları al
      final allCases = await FirebaseFirestore.instance.collection(collectionName).get();

      // Motherboard form factor'üne uyumlu olanları filtrele
      mbFilteredDocs = allCases.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final formFactorData = data['motherboard_form_factor'];

        List<String> supportedFormFactors;
        if (formFactorData is String) {
          supportedFormFactors = [formFactorData];
        } else if (formFactorData is Iterable) {
          supportedFormFactors = List<String>.from(formFactorData);
        } else {
          supportedFormFactors = [];
        }

        print(supportedFormFactors);
        return supportedFormFactors.contains(motherboardForm);
      }).toList();

      if (mbFilteredDocs.isEmpty) {
        return [];
      }
    }
  }

  // Eğer filtreli liste varsa onu döndür
  if (mbFilteredDocs != null) {
    return mbFilteredDocs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  }

  // Filtre yoksa tüm kasaları getir
  return qs.docs.map((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    data['category'] = category;
    return data;
  }).toList();
}

    // Hiçbir kategori eşleşmezse tüm parçaları getir
    return qs.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['category'] = category;
      return data;
    }).toList();
  } catch (e) {
    print('Error in fetchPartsByCategory: $e');
    rethrow;
  }
}
}