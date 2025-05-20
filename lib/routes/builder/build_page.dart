import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_build_screen.dart';
import 'select_part_screen.dart';
import 'package:findmepcparts/routes/builder/part.dart';
import 'package:findmepcparts/routes/builder/build.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:findmepcparts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


class NBuildPage extends StatefulWidget {
  const NBuildPage({Key? key}) : super(key: key);

  @override
  State<NBuildPage> createState() => _BuildPageState();
}

class _BuildPageState extends State<NBuildPage> {
  List<Build> builds = [];
  List<Build> local_builds = [];

  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? '');
  final String _username = FirebaseAuth.instance.currentUser?.displayName ?? '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuilds();
  }

  Future<void> _loadBuilds() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Check if user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('Error: User is not authenticated');
        final List<Map<String, dynamic>> local_build_data = await _databaseService.fetchBuilds(_username);
        
        setState(() {
          local_builds = local_build_data.map((data) => Build.fromMap(data, data["id"])).toList();
          isLoading = false;
        });
        return;
      }
      
      print('Current user: ${user.displayName}');
      print('Current user ID: ${user.uid}');
      
      final List<Map<String, dynamic>> buildData = await _databaseService.fetchBuilds(_username);
      List<String> build_ids = [];

      buildData.forEach((element) {
        build_ids.add(element["id"]);
      },);

      print('Fetched build data: $build_ids');
      
      setState(() {
        builds = buildData.map((data) => Build.fromMap(data, data["id"])).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading builds: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Default part names in order (for reset purpose)
  final List<String> defaultPartNames = [
    'Processor (CPU)',
    'CPU Cooler',
    'Motherboard',
    'GPU',
    'Memory',
    'Storage',
    'Power Supply',
    'Case',
  ];

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    String? curr_uid = auth.currentUser?.uid;

    print(curr_uid); // for debugging only.
    
    return Scaffold(
      bottomNavigationBar: CustomNavBar(),
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Your Builds',
          style: appBarTitleTextStyle
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.normalIconColor),
            onPressed: () async {
              final newBuild = await Navigator.of(context).push(_createRoute());
              if (newBuild != null && newBuild is Build) {
                setState(() {
                  if (auth.currentUser != null)
                  {
                    builds.add(newBuild);
                  }
                  else
                  {
                    local_builds.add(newBuild);
                  }
                });
              }
            },
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : (builds.isEmpty && local_builds.isEmpty) 
          ? const Center(child: Text('No builds yet. Create your first build!'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: 
        (auth.currentUser != null) ?
        ListView.builder(
          itemCount: builds.length,
          itemBuilder: (context, index) {
            return buildCard(builds[index], index);
          }
        ) : 
        ListView.builder(
          itemCount: local_builds.length,
          itemBuilder: (context, index) {
            return buildCard(local_builds[index], index);
          }
        )
      ),
    );
  }

  Widget buildCard(Build build, int buildIndex) {
    final auth = Provider.of<AuthService>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
        side: BorderSide(
          color: Colors.black87, 
          width: 1.5, 
        ),
      ),
      color: AppColors.bodyBackgroundColor,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  build.name,
                  style: bodyTitleStyle,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          build.isExpanded = !build.isExpanded;
                        });
                      }, 
                      child: Text(build.isExpanded ? 'Hide' : 'View', style: TextStyle(color: Colors.black),),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.flameColor),
                      onPressed: () async {
                        print(build.id);
                        if (build.id != null) {
                          await _databaseService.deleteBuild(build.id!);
                          setState(() {
                            if (auth.currentUser != null)
                            {
                              builds.removeAt(buildIndex);
                            }
                            else
                            {
                              local_builds.removeAt(buildIndex);
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),

            if (build.isExpanded) ...[
              const SizedBox(height: 8),
              Column(
                children: build.parts.asMap().entries.map((entry) {
                  int partIndex = entry.key;
                  Part part = entry.value;
                  return buildPartItem(build, buildIndex, part, partIndex);
                }).toList(),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget buildPartItem(Build build, int buildIndex, Part part, int partIndex) {
    final auth = Provider.of<AuthService>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey, 
          width: 1.5, 
        ),
      ),
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: part.imageUrl.isNotEmpty
                ? Image.network(
                    part.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.memory));
                    },
                  )
                : const Center(child: Icon(Icons.memory)),
          ),
        ),
        title: Text(part.name),
        subtitle: Text(
          '${part.category}\n\$${part.price.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 12),
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final selectedPart = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectPartScreen(
                      category: part.category,
                      selectedParts: build.parts,
                    ),
                  ),
                );
                if (selectedPart != null && selectedPart is Part) {
                  setState(() {
                    build.parts[partIndex] = selectedPart;
                    if (build.id != null) {
                      _databaseService.updateBuild(build.id!, build);
                    }
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.flameColor),
              onPressed: () {
                setState(() {
                  if (partIndex < defaultPartNames.length) {
                    build.parts[partIndex] = Part(
                      name: defaultPartNames[partIndex],
                      category: defaultPartNames[partIndex],
                      price: 0,
                      imageUrl: '',
                    );
                  } else {
                    build.parts[partIndex] = Part(
                      name: 'Part',
                      category: '',
                      price: 0,
                      imageUrl: '',
                    );
                  }
                  if (build.id != null) {
                    _databaseService.updateBuild(build.id!, build);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const NewBuildScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Future<void> deleteBuild(String buildId) async {
    await FirebaseFirestore.instance.collection("builds").doc(buildId).delete();
  }
}