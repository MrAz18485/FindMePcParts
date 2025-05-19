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

Widget buildCommunityCard({
  required BuildContext context,
  required PcBuild build,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        color: Colors.black,
      ),
      Text(build.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(build.rating, style: const TextStyle(color: Colors.grey)),
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
  bool _isLoading = true;
  String? _error;

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
          // Debug prints
          print('Connection State: ${snapshot.connectionState}');
          print('Has Error: ${snapshot.hasError}');
          print('Error: ${snapshot.error}');
          print('Has Data: ${snapshot.hasData}');
          if (snapshot.hasData) {
            print('Number of documents: ${snapshot.data!.docs.length}');
          }

          if (snapshot.hasError) {
            print('Firestore Error: ${snapshot.error}');
            return Center(
              child: Text(
                'Error loading posts: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

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

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: snapshot.data!.docs.map((doc) {
              try {
                final data = doc.data() as Map<String, dynamic>;
                print('Document data: $data'); // Debug print
                final build = PcBuild.fromMap(data);
                return buildCommunityCard(
                  context: context,
                  build: build,
                );
              } catch (e) {
                print('Error parsing document: $e');
                return const SizedBox.shrink();
              }
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
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
        title: Text(build.title, style: const TextStyle(color: Colors.black, fontSize: 24,)),
        actions: [
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
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Divider(color: Colors.black,),
          SizedBox(height: 10,),
          Text("Rating: ${build.rating}", style: const TextStyle(fontSize: 18)),
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