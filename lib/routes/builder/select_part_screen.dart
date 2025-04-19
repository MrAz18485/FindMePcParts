import 'package:flutter/material.dart';
import 'package:findmepcparts/util/colors.dart';

// burda belki birkaç tanesinde daha utility class'daki color'u kullanabiliriz?

class PartOption {
  final String name;
  final String rating;
  final String price;

  final String attributes;

  PartOption({required this.name, required this.rating, required this.price, required this.attributes});
}

class SelectPartScreen extends StatelessWidget {
  final List<PartOption> parts = [
    PartOption(name: "part_name1", rating: "4.5⭐", price: "\$100", attributes: "Attribute details here..."),
    PartOption(name: "part_name2", rating: "4.0⭐", price: "\$150", attributes: "Attribute details here..."),
    PartOption(name: "part_name3", rating: "4.8⭐", price: "\$200", attributes: "Attribute details here..."),
    PartOption(name: "part_name4", rating: "5.0⭐", price: "\$250", attributes: "Attribute details here..."),
  ];

  SelectPartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black, // Aynı renk ve kalınlık
                    width: 1.5,
                  ),
                ),
              ),
            ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.normalIconColor),
            onPressed: () {
              showFilterPopup(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final part = parts[index];
          return Card(
            shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), 
                    side: BorderSide(
                      color: Colors.black, 
                      width: 1.5, 
                    ),
                  ),
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Center(child: Icon(Icons.memory)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(part.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(part.rating),
                            Text(part.price),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop(part.name);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                 Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                      color: const Color.fromARGB(28, 164, 142, 141),
                      borderRadius: BorderRadius.circular(12), 
                      ),
                      child: Text(
                      part.attributes,
                      style: const TextStyle(color: Colors.black),
                      ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showFilterPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedSortBy = 'price';
        String selectedSortOrder = 'ascending';
        double minPrice = 0;
        double maxPrice = 1000;

        return AlertDialog(backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Filter'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    const Text('Sort By:'),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          selectedColor: Colors.black,
                          backgroundColor: Colors.white,
                          label: Text(
                            'Price',
                            style: TextStyle(
                              color: selectedSortBy == 'price' ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedSortBy == 'price',
                          onSelected: (_) => setState(() => selectedSortBy = 'price'),
                        ),
                        ChoiceChip(
                            selectedColor: Colors.black,
                            backgroundColor: Colors.white,
                            label: Text(
                            'Reviews',
                            style: TextStyle(
                              color: selectedSortBy == 'reviews' ? Colors.white : Colors.black,
                            ),
                            ),
                            selected: selectedSortBy == 'reviews',
                            onSelected: (_) => setState(() => selectedSortBy = 'reviews'),
                            ),
                            ChoiceChip(
                            selectedColor: Colors.black,
                            backgroundColor: Colors.white,
                            label: Text(
                            'Other Attributes',
                            style: TextStyle(
                              color: selectedSortBy == 'other' ? Colors.white : Colors.black,
                            ),
                            ),
                            selected: selectedSortBy == 'other',
                            onSelected: (_) => setState(() => selectedSortBy = 'other'),
                            ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Sort Order:'),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                            selectedColor: Colors.black,
                            backgroundColor: Colors.white,
                            label: Text(
                              'Ascending',
                              style: TextStyle(
                                color: selectedSortOrder == 'ascending' ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: selectedSortOrder == 'ascending',
                            onSelected: (_) => setState(() => selectedSortOrder = 'ascending'),
                          ),
                        ChoiceChip(
                          selectedColor: Colors.black,
                          backgroundColor: AppColors.bodyBackgroundColor,
                          label: Text(
                            'Descending',
                            style: TextStyle(
                              color: selectedSortOrder == 'descending' ? Colors.white : Colors.black,
                            ),
                          ),
                          selected: selectedSortOrder == 'descending',
                          onSelected: (_) => setState(() => selectedSortOrder = 'descending'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Price Range:'),
                    RangeSlider(activeColor: Colors.black,
                    inactiveColor: Colors.grey,
                      values: RangeValues(minPrice, maxPrice),
                      min: 0,
                      max: 5000,
                      divisions: 100,
                      labels: RangeLabels('${minPrice.round()}₺', '${maxPrice.round()}₺'),
                      onChanged: (RangeValues values) {
                        setState(() {
                          minPrice = values.start;
                          maxPrice = values.end;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text('Other Attributes (if any):'),
                    const SizedBox(height: 8),
                    const Text(
                      'Other attributes will be shown here based on part type.',
                      style: TextStyle(color: AppColors.bodyTextColor),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              style:  ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackgroundColor, 
                        foregroundColor: AppColors.buttonTextColor, 
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Filters can be applied here
              },
              child: const Text('Apply',),
            ),
          ],
        );
      },
    );
  }
}
