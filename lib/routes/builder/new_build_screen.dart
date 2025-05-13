import 'package:findmepcparts/routes/builder/build.dart';
import 'package:findmepcparts/routes/builder/part.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:flutter/material.dart';

import 'select_part_screen.dart'; // import for part picking

class NewBuildScreen extends StatefulWidget {
  const NewBuildScreen({Key? key}) : super(key: key);

  @override
  State<NewBuildScreen> createState() => _NewBuildScreenState();
}

class _NewBuildScreenState extends State<NewBuildScreen> {
  final TextEditingController _buildNameController = TextEditingController(text: "New_build");

  late List<String> partNames;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: TextField(
          controller: _buildNameController,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.appBarTitleColor, fontWeight: FontWeight.bold, fontSize: 20),
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.bodyBackgroundColor,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              String newBuildName = _buildNameController.text.trim();
              if (newBuildName.isNotEmpty) {
                List<Part> selectedParts = partNames.map((partName) {
                  return Part(
                    name: partName,
                    category: '', // You can fill category later if you want
                    price: 0,
                    imageUrl: '',
                  );
                }).toList();

                Build newBuild = Build(
                  name: newBuildName,
                  parts: selectedParts,
                  isExpanded: false,
                );

                Navigator.of(context).pop(newBuild); // Send full Build object back
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.black, fontSize: 20)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Total:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('... TL'),
            const Text('... Watt'),
            const SizedBox(height: 16),
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
        side: BorderSide(
          color: Colors.black, 
          width: 1.5, 
        ),
      ),
      color: AppColors.bodyBackgroundColor,
     
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          color: Colors.grey,
          child: const Center(child: Icon(Icons.memory)),
        ),
        title: Text(partNames[index]),
        trailing: IconButton(
          icon: const Icon(Icons.add, color: Colors.black),
          onPressed: () async {
            final selectedPartName = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SelectPartScreen()),
            );
            if (selectedPartName != null && selectedPartName is String) {
              setState(() {
                partNames[index] = selectedPartName;
              });
            }
          },
        ),
      ),
    );
  }
}
