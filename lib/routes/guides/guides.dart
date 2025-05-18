import 'package:findmepcparts/models/guide_model.dart';
import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/services/guide_service.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';


class Guides extends StatefulWidget {
  const Guides({super.key});

  @override
  State<Guides> createState() => _Guides();
}

class _Guides extends State<Guides> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ["Entry Level", "Mid Range", "High End"];

  bool _isLoading = true;
  Map<String, List<Guide>> _guideItems = {};

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // First check if the guides collection exists
      await GuideService.checkGuidesCollection();

      // Then fetch the guides
      final guides = await GuideService.fetchGuides();
      setState(() {
        _guideItems = guides;
        _isLoading = false;
      });

      print('Loaded guides: $_guideItems');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print('Error loading guides: $e');
    }
  }

 @override
Widget build(BuildContext context) {
  String selectedCategory = categories[_selectedCategoryIndex];
  List<Guide> selectedGuides = _guideItems[selectedCategory] ?? [];

  return Scaffold(
    backgroundColor: AppColors.bodyBackgroundColor,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Guides",
            style: appBarTitleTextStyle,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: categories
                .asMap()
                .entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        label: Text(
                          entry.value,
                          style: TextStyle(
                            color: _selectedCategoryIndex == entry.key ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _selectedCategoryIndex == entry.key,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategoryIndex = entry.key;
                          });
                        },
                        selectedColor: Colors.black,
                        backgroundColor: AppColors.bodyBackgroundColor,
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    )
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        if (_isLoading)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (selectedGuides.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                "No guides available for this category",
                style: TextStyle(fontSize: 16),
              ),
            ),
          )
        else
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RefreshIndicator(
                onRefresh: _loadGuides,
                child: ListView.builder(
                  itemCount: selectedGuides.length,
                  itemBuilder: (context, index) {
                    final guide = selectedGuides[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: buildGuideCard(
                        context: context,
                        guide: guide,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    ),
    bottomNavigationBar: CustomNavBar(),
  );
  }
}

Widget buildGuideCard({
  required BuildContext context,
  required Guide guide,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(color: Colors.black),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              guide.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Create a map with all guide properties
              final Map<String, dynamic> args = guide.toJson();

              // Ensure all required fields are present
              args['title'] = guide.title;
              args['cpu'] = guide.cpu;
              args['cpuUrl'] = guide.cpuUrl;
              args['gpu'] = guide.gpu;
              args['gpuUrl'] = guide.gpuUrl;
              args['ram'] = guide.ram;
              args['ramUrl'] = guide.ramUrl;
              args['cooler'] = guide.cooler;
              args['coolerUrl'] = guide.coolerUrl;
              args['case'] = guide.pcCase;
              args['caseUrl'] = guide.caseUrl;
              args['price'] = guide.price;
              args['buyLink'] = guide.buyLink;

              print('Navigating to details with args: $args');
              Navigator.pushNamed(context, '/guidesDetails', arguments: args);
            },
            style: buttonStyle,
            child: const Text("Select"),
          )
        ],
      ),
      const SizedBox(height: 4),
      Text("CPU: ${guide.cpu}"),
      Text("GPU: ${guide.gpu}"),
      Text("RAM: ${guide.ram}"),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(guide.price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}

