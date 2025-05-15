import 'package:findmepcparts/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/util/colors.dart';
import 'new_build_screen.dart';
import 'select_part_screen.dart';
import 'package:findmepcparts/routes/builder/part.dart';
import 'package:findmepcparts/routes/builder/build.dart';
import 'package:findmepcparts/util/text_styles.dart';

import 'package:provider/provider.dart';
import 'package:findmepcparts/services/auth_provider.dart';

class NBuildPage extends StatefulWidget {
  const NBuildPage({Key? key}) : super(key: key);

  @override
  State<NBuildPage> createState() => _BuildPageState();
}

class _BuildPageState extends State<NBuildPage> {
  List<Build> builds = [
    Build(
      name: 'My Build 1',
      parts: [
        Part(name: "Intel Core i5 750", category: "Processor(CPU)", price: 15),
        Part(name: "GeForce RTX 4060", category: "Graphics Card(GPU)", price: 350, imageUrl: 'assets/4060.jpg'),
        Part(name: "Kingston 8 GB 1333 Mhz RAM", category: "Physical Memory(RAM)", price: 30, imageUrl: 'assets/ram.jpg')
      ],
    ),
    Build(
      name: 'My Build 2',
      parts: [
        Part(name: "Intel Core i7 13700", category: "Processor(CPU)", price: 150, imageUrl: 'assets/i7_13700.jpg')      
      ],
    ),
  ];

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
                  builds.add(newBuild);
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: builds.length,
          itemBuilder: (context, index) {
            return buildCard(builds[index], index);
          },
        ),
      ),
    );
  }

  Widget buildCard(Build build, int buildIndex) {
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
                      onPressed: () {
                        setState(() {
                          builds.removeAt(buildIndex);
                        });
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
          color: Colors.grey.shade300,
          child: const Center(child: Text('Image')),
        ),
        title: Text(part.name),
        subtitle: Text('${part.category}\n${part.price}'),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () async {
                final selectedPartName = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SelectPartScreen()),
                );
                if (selectedPartName != null && selectedPartName is String) {
                  setState(() {
                    build.parts[partIndex].name = selectedPartName;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.flameColor),
              onPressed: () {
                setState(() {
                  if (partIndex < defaultPartNames.length) {
                    build.parts[partIndex].name = defaultPartNames[partIndex];
                  } else {
                    build.parts[partIndex].name = 'Part';
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
}
