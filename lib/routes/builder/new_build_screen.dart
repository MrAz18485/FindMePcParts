import 'package:findmepcparts/routes/builder/build.dart';
import 'package:findmepcparts/routes/builder/part.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'select_part_screen.dart'; // import for part picking



class NewBuildScreen extends StatefulWidget {
  const NewBuildScreen({Key? key}) : super(key: key);

  @override
  State<NewBuildScreen> createState() => _NewBuildScreenState();
}

class _NewBuildScreenState extends State<NewBuildScreen> {
  final TextEditingController _buildNameController = TextEditingController(text: "New Build");
  late List<String> partNames;
  late List<Part> selectedParts;
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? '');
  final String _username = FirebaseAuth.instance.currentUser?.displayName ?? '';

  @override
  void initState() {
    super.initState();
    partNames = [
      'Processor (CPU)',
      'CPU Cooler',
      'Motherboard',
      'GPU',
      'Memory',
      'Storage',
      'Power Supply',
      'Case',
    ];
    // Initialize selectedParts with default values
    selectedParts = partNames.map((partName) {
      return Part(
        name: partName,
        category: partName,
        price: 0,
        imageUrl: '',
      );
    }).toList();
  }

  double get totalPrice {
    return selectedParts.fold(0, (sum, part) => sum + part.price);
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          controller: _buildNameController,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              String newBuildName = _buildNameController.text.trim();
              if (newBuildName.isNotEmpty) {
                Build newBuild = Build(
                  name: newBuildName,
                  parts: selectedParts,
                  isExpanded: false,
                );
                String buildId = await _databaseService.saveBuild(_username, newBuild);
                newBuild.id = buildId;
                Navigator.of(context).pop(newBuild); // page is popped, return newBuild as param. to prev page
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: partNames.length,
                itemBuilder: (context, index) {
                  return buildPartTile(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPartTile(int index) {
    final part = selectedParts[index];
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () async {
          final selectedPart = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectPartScreen(
                category: partNames[index],
              ),
            ),
          );
          if (selectedPart != null && selectedPart is Part) {
            setState(() {
              selectedParts[index] = selectedPart;
            });
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: part.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(part.imageUrl, fit: BoxFit.cover),
                      )
                    : const Center(child: Icon(Icons.memory, color: Colors.black54)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partNames[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      part.price > 0 ? '\$${part.price.toStringAsFixed(2)}' : 'Select a part',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: part.price > 0 ? Colors.black87 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (part.price > 0 && part.buyUrl != null)
                TextButton(
                  onPressed: () => _launchUrl(part.buyUrl!),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Buy',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
