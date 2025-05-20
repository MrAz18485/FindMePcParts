import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:findmepcparts/models/pc_build.dart';
import 'package:findmepcparts/routes/community/add_build.dart';
import 'dart:convert';

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.black,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
);

String formatPrice(double price) {
  return '\$${price.toStringAsFixed(2)}';
}

String formatRating(double rating, int count) {
  if (count == 0) return 'No ratings yet';
  return '${rating.toStringAsFixed(1)} (${count} ratings)';
}

Widget buildCommunityCard({
  required BuildContext context,
  required PcBuild build,
  required String documentId,
}) {
  final currentUser = FirebaseAuth.instance.currentUser;
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        color: Colors.black,
      ),
      Text(build.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Row(
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                build.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${build.ratingCount} reviews)',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          if (currentUser != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                build.hasUserRated(currentUser.uid) ? Icons.star : Icons.star_border,
                color: build.hasUserRated(currentUser.uid) ? Colors.amber : Colors.black54,
                size: 24,
              ),
              onPressed: () async {
                if (build.hasUserRated(currentUser.uid)) {
                  // Remove rating
                  try {
                    final docRef = FirebaseFirestore.instance.collection('community').doc(documentId);
                    final doc = await docRef.get();
                    
                    if (!doc.exists) {
                      throw Exception('Document does not exist');
                    }
                    
                    final currentRating = doc.data()?['rating'] ?? 0.0;
                    final currentCount = doc.data()?['ratingCount'] ?? 0;
                    final ratedBy = List<String>.from(doc.data()?['ratedBy'] ?? []);
                    
                    if (currentCount <= 1) {
                      // If this is the only rating, reset to 0
                      await docRef.update({
                        'rating': 0.0,
                        'ratingCount': 0,
                        'ratedBy': [],
                      });
                    } else {
                      // Remove user's rating and recalculate average
                      ratedBy.remove(currentUser.uid);
                      final newRating = ((currentRating * currentCount) - currentRating) / (currentCount - 1);
                      
                      await docRef.update({
                        'rating': newRating,
                        'ratingCount': currentCount - 1,
                        'ratedBy': ratedBy,
                      });
                    }
                  } catch (e) {
                    print('Error removing rating: $e');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error removing rating: $e')),
                      );
                    }
                  }
                } else {
                  // Add new rating
                  final userRating = await showDialog<double>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor:  AppColors.bodyBackgroundColor,
                      title: const Text('Rate this build'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return ListTile(
                            title: Text('${index + 1} stars'),
                            onTap: () => Navigator.pop(context, (index + 1).toDouble()),
                          );
                        }),
                      ),
                    ),
                  );

                  if (userRating != null) {
                    try {
                      final docRef = FirebaseFirestore.instance.collection('community').doc(documentId);
                      final doc = await docRef.get();
                      
                      if (!doc.exists) {
                        throw Exception('Document does not exist');
                      }
                      
                      final currentRating = doc.data()?['rating'] ?? 0.0;
                      final currentCount = doc.data()?['ratingCount'] ?? 0;
                      final ratedBy = List<String>.from(doc.data()?['ratedBy'] ?? []);
                      
                      if (ratedBy.contains(currentUser.uid)) {
                        throw Exception('You have already rated this build');
                      }
                      
                      final newRating = ((currentRating * currentCount) + userRating) / (currentCount + 1);
                      ratedBy.add(currentUser.uid);
                      
                      await docRef.update({
                        'rating': newRating,
                        'ratingCount': currentCount + 1,
                        'ratedBy': ratedBy,
                      });
                    } catch (e) {
                      print('Error updating rating: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating rating: $e')),
                        );
                      }
                    }
                  }
                }
              },
            ),
          ],
        ],
      ),
      const SizedBox(height: 4),
      Text(formatPrice(build.price), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/communityDetails', arguments: build);
          },
          style: buttonStyle,
          child: const Text("Select"),
        ),
      ),
      const SizedBox(height: 10),
      if (build.imageUrl.isNotEmpty)
        Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: build.imageUrl.startsWith('data:image')
                ? Image.memory(
                    base64Decode(build.imageUrl.split(',')[1]),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading base64 image: $error');
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      );
                    },
                  )
                : Image.network(
                    build.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading network image: $error');
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 50),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ),
      const SizedBox(height: 20),
    ],
  );
}

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _Community();
}

class _Community extends State<Community> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bodyBackgroundColor,
        centerTitle: false,
        title: Text(
          "Community",
          style: appBarTitleTextStyle,
        ),
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('community').snapshots(),
        builder: (context, snapshot) {
          // Basic error handling
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error.toString()}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // No data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No PC builds available yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddBuildScreen()),
                      );
                    },
                    style: buttonStyle,
                    child: const Text('Add First Build'),
                  ),
                ],
              ),
            );
          }

          // Try to show data
          try {
            final docs = snapshot.data!.docs;
            final sortedDocs = List<QueryDocumentSnapshot>.from(docs);
            
            // Sort by rating (highest to lowest)
            sortedDocs.sort((a, b) {
              final aRating = (a.data() as Map<String, dynamic>)['rating'] ?? 0.0;
              final bRating = (b.data() as Map<String, dynamic>)['rating'] ?? 0.0;
              return (bRating as num).compareTo(aRating as num);
            });

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: sortedDocs.map((doc) {
                try {
                  final data = doc.data() as Map<String, dynamic>;
                  final build = PcBuild.fromMap(data);
                  return buildCommunityCard(
                    context: context,
                    build: build,
                    documentId: doc.id,
                  );
                } catch (e) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Error loading build: $e'),
                          Text('Document ID: ${doc.id}'),
                          Text('Raw data: ${doc.data()}'),
                        ],
                      ),
                    ),
                  );
                }
              }).toList(),
            );
          } catch (e) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error displaying builds: $e',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FirebaseAuth.instance.currentUser != null
          ? FloatingActionButton(
              tooltip: "New Post",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddBuildScreen()),
                );
              },
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: CustomNavBar(),
    );
  }
}

class CommunityDetailScreen extends StatelessWidget {
  const CommunityDetailScreen({super.key});

  Future<String?> _getDocumentId(PcBuild build) async {
    final query = await FirebaseFirestore.instance
        .collection('community')
        .where('title', isEqualTo: build.title)
        .where('price', isEqualTo: build.price)
        .where('description', isEqualTo: build.description)
        .get();
    if (query.docs.isNotEmpty) {
      return query.docs.first.id;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final build = ModalRoute.of(context)!.settings.arguments as PcBuild;

    Future<void> _deletePost() async {
      final docId = await _getDocumentId(build);
      if (docId != null) {
        await FirebaseFirestore.instance.collection('community').doc(docId).delete();
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post deleted successfully!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not find post to delete.')),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColors.appBarBackgroundColor,
          title: Text(
            build.title,
            style: const TextStyle(color: Colors.black, fontSize: 24),
            maxLines: 1,                // Tek satırda tut
            overflow: TextOverflow.ellipsis, // Sığmazsa sonuna ...
          ),
        actions: [
          if (FirebaseAuth.instance.currentUser?.uid == build.uid) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              tooltip: 'Edit',
              onPressed: () async {
                final docId = await _getDocumentId(build);
                if (docId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBuildScreen(
                        buildToEdit: build,
                        documentId: docId,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not find post to edit.')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Delete',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text('Delete Post'),
                    content: const Text('Are you sure you want to delete this post?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _deletePost();
                }
              },
            ),
          ],
        ],
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Divider(color: Colors.black,),
          SizedBox(height: 10,),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 24),
              const SizedBox(width: 4),
              Text(
                build.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${build.ratingCount} reviews)',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Text("Price: ${formatPrice(build.price)}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(build.description),
          const SizedBox(height: 30),
          if (build.imageUrl.isNotEmpty)
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: build.imageUrl.startsWith('data:image')
                    ? Image.memory(
                        base64Decode(build.imageUrl.split(',')[1]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading base64 image: $error');
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 50),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          );
                        },
                      )
                    : Image.network(
                        build.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading network image: $error');
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, size: 50),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }
}