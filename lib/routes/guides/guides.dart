import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';


class Guides extends StatefulWidget {
  const Guides({super.key});

  @override
  State<Guides> createState() => _Guides();
}

class _Guides extends State<Guides> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ["Entry Level", "Mid Range", "High End"];
  bool isLoading = true;
  Map<String, List<Map<String, dynamic>>> guideItems = {};

  @override
  void initState() {
    super.initState();
    _loadGuides();
  }

  Future<void> _loadGuides() async {
    try {
      final guidesSnapshot = await FirebaseFirestore.instance.collection('guides').get();
      final guides = guidesSnapshot.docs;
      
      // Initialize guideItems with empty lists
      for (var category in categories) {
        guideItems[category] = [];
      }

      // Sort guides into categories
      for (var doc in guides) {
        final data = doc.data();
        final tier = data['tier'] as String?;
        if (tier != null && categories.contains(tier)) {
          guideItems[tier]!.add({
            'title': doc.id,
            'cpu': data['cpu'] ?? '',
            'gpu': data['gpu'] ?? '',
            'ram': data['ram'] ?? '',
            'price': data['price'] ?? '',
            'cooler': data['cooler'] ?? '',
            'case': data['case'] ?? '',
          });
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading guides: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories[_selectedCategoryIndex];
    List<Map<String, dynamic>> selectedGuides = guideItems[selectedCategory] ?? [];

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

          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (selectedGuides.isEmpty)
            const Expanded(
              child: Center(child: Text('No guides available for this category')),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: selectedGuides.length,
                  itemBuilder: (context, index) {
                    final guide = selectedGuides[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: buildGuideCard(
                        context: context,
                        title: guide["title"]!,
                        cpu: guide["cpu"]!,
                        gpu: guide["gpu"]!,
                        ram: guide["ram"]!,
                        price: guide["price"]!,
                        cooler: guide["cooler"]!,
                        pccase: guide["case"]!,
                      ),
                    );
                  },
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
  required String title,
  required String cpu,
  required String gpu,
  required String ram,
  required String price,
  required String cooler,
  required String pccase,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider( color: Colors.black,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/guidesDetails', arguments: {
                'title': title,
                'cpu': cpu,
                'gpu': gpu,
                'ram': ram,
                'price': price,
                'cooler': cooler,
                'case': pccase,
              });
            },
            style: buttonStyle,
            child: const Text("Select"),
          )
        ],
      ),
      const SizedBox(height: 4),
      Text("CPU: $cpu"),
      Text("GPU: $gpu"),
      Text("RAM: $ram"),
      const SizedBox(height: 4),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 10),
    ],
  );
}

class GuidesDetailScreen extends StatefulWidget {
  const GuidesDetailScreen({super.key});

  @override
  State<GuidesDetailScreen> createState() => _GuidesDetailScreenState();
}

class _GuidesDetailScreenState extends State<GuidesDetailScreen> {
  bool isLoading = true;
  Map<String, dynamic>? buildData;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadBuildData();
      _isFirstLoad = false;
    }
  }

  Future<void> _loadBuildData() async {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final title = args['title']!;

    try {
      final doc = await FirebaseFirestore.instance.collection('guides').doc(title).get();
      if (doc.exists) {
        setState(() {
          buildData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading build data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.bodyBackgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: AppColors.appBarBackgroundColor,
          title: Text(
            args['title']!,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (buildData == null) {
      return Scaffold(
        backgroundColor: AppColors.bodyBackgroundColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: AppColors.appBarBackgroundColor,
          title: Text(
            args['title']!,
            style: const TextStyle(color: Colors.black, fontSize: 24),
          ),
        ),
        body: const Center(child: Text('Build data not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColors.appBarBackgroundColor,
        title: Text(
          args['title']!,
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.black),
            const SizedBox(height: 20),
            
            // CPU Section
            _buildComponentSection(
              title: 'CPU',
              name: buildData!['cpu'] ?? args['cpu']!,
              imageUrl: buildData!['cpu_url'],
              buyLink: buildData!['buy_link'],
            ),
            
            // GPU Section
            _buildComponentSection(
              title: 'GPU',
              name: buildData!['gpu'] ?? args['gpu']!,
              imageUrl: buildData!['gpu_url'],
              buyLink: buildData!['buy_link'],
            ),
            
            // RAM Section
            _buildComponentSection(
              title: 'RAM',
              name: buildData!['ram'] ?? args['ram']!,
              imageUrl: buildData!['ram_url'],
              buyLink: buildData!['buy_link'],
            ),
            
            // Case Section
            _buildComponentSection(
              title: 'Case',
              name: buildData!['case'] ?? args['case']!,
              imageUrl: buildData!['case_url'],
              buyLink: buildData!['buy_link'],
            ),
            
            // Cooler Section
            _buildComponentSection(
              title: 'CPU Cooler',
              name: buildData!['cooler'] ?? args['cooler']!,
              imageUrl: buildData!['cooler_url'],
              buyLink: buildData!['buy_link'],
            ),
            
            const SizedBox(height: 20),
            Text(
              "Total Price: ${buildData!['price'] ?? args['price']!}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            if (buildData!['buy_link'] != null) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _launchUrl(buildData!['buy_link']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Buy All Parts', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComponentSection({
    required String title,
    required String name,
    String? imageUrl,
    String? buyLink,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (imageUrl != null)
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
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
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}