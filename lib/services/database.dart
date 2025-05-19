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
    if (!isGuest) {
      print("Here");
      final prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> builds = _cachedGuestBuilds ?? [];

      builds.removeWhere((build) => build['id'] == buildId);
      _cachedGuestBuilds = builds;
      await prefs.setString(_guestBuildsKey, jsonEncode(builds));
      await buildsCollection.doc(buildId).delete();
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

    QuerySnapshot qs;

    // CPU seçiliyse -> uyumlu CPU Cooler'ları getir
    if (category.toLowerCase() == 'cpu cooler' && selectedParts != null && selectedParts[0].price > 0) {
      String cpuSocket = selectedParts[0].attributes['socket'] ?? '';
      if (cpuSocket.isNotEmpty) {
        qs = await FirebaseFirestore.instance
            .collection(collectionName)
            .where('cpu_socket', arrayContains: cpuSocket)
            .get();
      } else {
        qs = await FirebaseFirestore.instance.collection(collectionName).get();
      }
    }

    // Cooler seçiliyse -> uyumlu CPU'ları getir
    else if (category.toLowerCase() == 'processor (cpu)' && selectedParts != null && selectedParts.length > 1 && selectedParts[1].price > 0) {
      List<String> cpuSockets = List<String>.from(selectedParts[1].attributes['cpu_socket'] ?? []);

      if (cpuSockets.isNotEmpty) {
        if (cpuSockets.length <= 10) {
          qs = await FirebaseFirestore.instance
              .collection(collectionName)
              .where('socket', whereIn: cpuSockets)
              .get();
        } else {
          // whereIn sınırını aştıysa elle filtrele
          final all = await FirebaseFirestore.instance.collection(collectionName).get();
          final filtered = all.docs.where((doc) {
            final socket = doc['socket'];
            return cpuSockets.contains(socket);
          }).toList();

          return filtered.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            data['category'] = category;
            return data;
          }).toList();
        }
      } else {
        qs = await FirebaseFirestore.instance.collection(collectionName).get();
      }
    }

    // Diğer kategoriler
    else {
      qs = await FirebaseFirestore.instance.collection(collectionName).get();
    }

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