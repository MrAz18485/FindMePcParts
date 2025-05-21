import 'package:findmepcparts/routes/builder/part.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

// burda belki birkaç tanesinde daha utility class'daki color'u kullanabiliriz?

class PartOption {
  final String id;
  final String name;
  final String price;
  final String image;
  final String buyUrl;
  final Map<String, dynamic> attributes;

  PartOption({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.buyUrl,
    required this.attributes,
  });

  factory PartOption.fromMap(Map<String, dynamic> map) {
    return PartOption(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      image: map['image'] ?? '',
      buyUrl: map['buy_url'] ?? '',
      attributes: Map<String, dynamic>.from(map)..removeWhere((key, value) => 
        ['id', 'name', 'price', 'image', 'buy_url'].contains(key)),
    );
  }

  String getFormattedAttributes() {
    List<String> formattedAttrs = [];
    final cat = (attributes['category'] ?? '').toString().toLowerCase();

    String getFirst(dynamic val) {
      if (val == null) return '';
      if (val is List && val.isNotEmpty) return val[0].toString();
      return val.toString();
    }

    if (cat.contains('cooler')) {
      if (attributes['fan_rpm'] != null) formattedAttrs.add('Fan: ${getFirst(attributes['fan_rpm'])}');
      if (attributes['noise_level'] != null) formattedAttrs.add('Noise: ${getFirst(attributes['noise_level'])}');
      if (attributes['water_cooled'] != null) formattedAttrs.add('Water Cooled: ${getFirst(attributes['water_cooled'])}');
    }
    else if (cat.contains('cpu')) {
      if (attributes['core_clock'] != null) formattedAttrs.add('Core: ${getFirst(attributes['core_clock'])}');
      if (attributes['boost_clock'] != null) formattedAttrs.add('Boost: ${getFirst(attributes['boost_clock'])}');
      if (attributes['core_count'] != null && attributes['thread_count'] != null) {
        formattedAttrs.add('${getFirst(attributes['core_count'])} C / ${getFirst(attributes['thread_count'])} T');
      }
      if (attributes['l2_cache'] != null) formattedAttrs.add('L2: ${getFirst(attributes['l2_cache'])}');
      if (attributes['l3_cache'] != null) formattedAttrs.add('L3: ${getFirst(attributes['l3_cache'])}');  
      if (attributes['socket'] != null) formattedAttrs.add(getFirst(attributes['socket']));

    } else if (cat.contains('gpu')) {
      if (attributes['chipset'] != null) formattedAttrs.add(getFirst(attributes['chipset']));
      if (attributes['chipset'] != null && !attributes['chipset'].contains('GB') && attributes['memory'] != null) {
        formattedAttrs.add(getFirst(attributes['memory']));
      }   
      if (attributes['memory_type'] != null) formattedAttrs.add(getFirst(attributes['memory_type']));   
      if (attributes['core_clock'] != null) formattedAttrs.add('Core: ${getFirst(attributes['core_clock'])}');
      if (attributes['boost_clock'] != null) formattedAttrs.add('Boost: ${getFirst(attributes['boost_clock'])}');
      if (attributes['cooling'] != null) formattedAttrs.add(getFirst(attributes['cooling']));
      
    } else if (cat.contains('memory')) {
      if (attributes['modules'] != null && attributes['modules'].toString().isNotEmpty) {
        formattedAttrs.add(getFirst(attributes['modules']));
      } else if (attributes['capacity'] != null && attributes['capacity'].toString().isNotEmpty) {
        String cap = getFirst(attributes['capacity']);
        if (!cap.toLowerCase().contains('gb')) cap = cap + ' GB';
        formattedAttrs.add(cap);
      }
      if (attributes['speed'] != null && attributes['speed'].toString().isNotEmpty) formattedAttrs.add(getFirst(attributes['speed']));
      if (attributes['type'] != null && attributes['type'].toString().isNotEmpty) formattedAttrs.add(getFirst(attributes['type']));
    } else if (cat.contains('storage')) {
      if (attributes['capacity'] != null) formattedAttrs.add(getFirst(attributes['capacity']));
      if (attributes['type'] != null) formattedAttrs.add(getFirst(attributes['type']));
      if (attributes['interface'] != null) formattedAttrs.add(getFirst(attributes['interface']));
    } else if (cat.contains('power supply')) {
      if (attributes['wattage'] != null) formattedAttrs.add(getFirst(attributes['wattage']));
      if (attributes['efficiency_rating'] != null) formattedAttrs.add(getFirst(attributes['efficiency_rating']));
    } else if (cat.contains('case')) {
      if (attributes['type'] != null) formattedAttrs.add(getFirst(attributes['type']));
      if (attributes['form_factor'] != null) formattedAttrs.add(getFirst(attributes['form_factor']));
      if (attributes['dimensions'] != null && attributes['dimensions'][0] != null) {
        String dims = getFirst(attributes['dimensions'][0]);
        // Örneğin 'x' karakteri ile bölüp alt alta yazalım:
        List<String> parts = dims.split(' x ');
        String formattedDimensions = parts.join('\n'); // Satırlara böldük
        formattedAttrs.add('Dimension:\n$formattedDimensions');
      }

      } else if (cat.contains('motherboard')) {
      if (attributes['chipset'] != null) formattedAttrs.add(getFirst(attributes['chipset']));
      if (attributes['socket'] != null) formattedAttrs.add(getFirst(attributes['socket']));
      if (attributes['memory_type'] != null) formattedAttrs.add(getFirst(attributes['memory_type']));
      if (attributes['form_factor'] != null) formattedAttrs.add(getFirst(attributes['form_factor']));
        }

    return formattedAttrs.where((e) => e.isNotEmpty).join('\n');
  }

  Part toPart() {
    return Part(
      name: name,
      category: attributes['category'] ?? '',
      price: double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
      imageUrl: image,
      buyUrl: buyUrl,
      attributes: attributes,
    );
  }
}

class SelectPartScreen extends StatefulWidget {
  final String category;
  final List<Part> selectedParts;
  
  const SelectPartScreen({
    Key? key, 
    required this.category,
    required this.selectedParts,
  }) : super(key: key);

  @override
  State<SelectPartScreen> createState() => _SelectPartScreenState();
}

class _SelectPartScreenState extends State<SelectPartScreen> {
  List<PartOption> parts = [];
  final DatabaseService _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser?.uid ?? '');
  bool isLoading = true;
  String searchQuery = '';
  String selectedSortBy = 'price';
  String selectedSortOrder = 'ascending';
  double minPrice = 0;
  double maxPrice = 5000;

  @override
  void initState() {
    super.initState();
    _loadParts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Sayfa her görünür olduğunda parçaları yeniden yükle
    _loadParts();
  }

  Future<void> _loadParts() async {
    try {
      setState(() {
        isLoading = true;
      });
      
      // Mevcut build'den motherboard'u bul
      Part? motherboard;
      if (widget.selectedParts.isNotEmpty) {
        motherboard = widget.selectedParts.firstWhere(
          (part) => part.category.toLowerCase() == 'motherboard' && part.price > 0,
          orElse: () => Part(name: '', category: '', price: 0, imageUrl: ''),
        );
      }

      final List<Map<String, dynamic>> partData = await _databaseService.fetchPartsByCategory(
        widget.category,
        selectedParts: widget.selectedParts,
      );
      
      if (mounted) {
        setState(() {
          parts = partData.map((data) {
            final part = PartOption.fromMap(data);
            return part;
          }).toList();

          // Eğer CPU seçiliyorsa ve motherboard varsa, uyumluluk kontrolü yap
          if (widget.category.toLowerCase() == 'processor (cpu)' && motherboard != null && motherboard.price > 0) {
            parts = parts.where((part) {
              final partSocket = part.attributes['socket']?.toString() ?? '';
              final motherboardSocket = motherboard?.attributes['socket']?.toString() ?? '';
              return partSocket == motherboardSocket;
            }).toList();
          }
          
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading parts: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  List<PartOption> get filteredParts {
  return parts.where((part) {
    final lowerQuery = searchQuery.toLowerCase();

    // Ürün ismine göre arama
    final matchesName = part.name.toLowerCase().contains(lowerQuery);

    // Attributes içindeki tüm string değerleri birleştir
    final attributesText = part.attributes.values
      .where((attr) => attr != null)
      .map((attr) {
        if (attr is List) {
          return attr.join(' ').toLowerCase();
        } else {
          return attr.toString().toLowerCase();
        }
      })
      .join(' ');

    // Attributes içinde arama
    final matchesAttributes = attributesText.contains(lowerQuery);

    final priceValue = double.tryParse(part.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
    final matchesPrice = priceValue >= minPrice && priceValue <= maxPrice;

    // İsim veya attributes'da arama varsa kabul et
    return (matchesName || matchesAttributes) && matchesPrice;
  }).toList()
    ..sort((a, b) {
      final priceA = double.tryParse(a.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      final priceB = double.tryParse(b.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

      if (selectedSortBy == 'price') {
        return selectedSortOrder == 'ascending' 
            ? priceA.compareTo(priceB)
            : priceB.compareTo(priceA);
      }
      return 0;
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search ${widget.category}',
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
                color: Colors.black,
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
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : parts.isEmpty
    ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              'No compatible ${widget.category} found',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Some of your selected parts may not be compatible.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Please review your configuration and try again.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredParts.length,
            itemBuilder: (context, index) {
              final part = filteredParts[index];
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
                margin: const EdgeInsets.only(bottom: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, part.toPart());
                  },
                  borderRadius: BorderRadius.circular(12),
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                          width: 90,
                          height: 90,
                            decoration: BoxDecoration(
                            color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                part.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                return const Center(child: Icon(Icons.memory, color: Colors.black54));
                                },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  part.name, 
                                  style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  part.getFormattedAttributes(),
                                  style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                part.price,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (part.buyUrl.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextButton(
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(part.buyUrl))) {
                                  await launchUrl(Uri.parse(part.buyUrl));
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                              ),
                                minimumSize: const Size(60, 44),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: const Text(
                                'Buy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Filter'),
              content: SingleChildScrollView(
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
                    RangeSlider(
                      activeColor: Colors.black,
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
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackgroundColor, 
                    foregroundColor: AppColors.buttonTextColor, 
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    this.setState(() {}); // Refresh the list with new filters
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
