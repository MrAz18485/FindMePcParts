import 'package:findmepcparts/nav_bar.dart';
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

  final Map<String, List<Map<String, String>>> guideItems = {
    "Entry Level": [
      {
        "title": "Intel Entry Level",
        "cpu": "Intel Core i3-14100F",
        "gpu": "NVIDIA GeForce GTX 1650",
        "ram": "16GB DDR4",
        "price": "\$663.12",
        "cooler": "Cooler Master Hyper 212",
        "case": "NZXT H510"
      },
      {
        "title": "AMD Entry Level",
        "cpu": "AMD Ryzen 5 5500",
        "gpu": "AMD Radeon RX 6600",
        "ram": "16GB DDR4",
        "price": "\$634.34",
        "cooler": "Cooler Master Hyper 212",
        "case": "NZXT H510"
      },
    ],
    "Mid Range": [
      {
        "title": "Intel Mid Range",
        "cpu": "Intel Core i5-13400F",
        "gpu": "NVIDIA RTX 4060 Ti",
        "ram": "32GB DDR4",
        "price": "\$1234.56",
        "cooler": "Noctua NH-D15",
        "case": "Fractal Design Meshify C"
      },
      {
        "title": "AMD Mid Range",
        "cpu": "AMD Ryzen 5 7600",
        "gpu": "AMD Radeon RX 7700 XT",
        "ram": "32GB DDR5",
        "price": "\$1345.77",
        "cooler": "Noctua NH-D15",
        "case": "Fractal Design Meshify C"
      },
    ],
    "High End": [
      {
        "title": "Intel High End",
        "cpu": "Intel Core i7-14700K",
        "gpu": "NVIDIA GeForce RTX 4080",
        "ram": "32GB DDR5",
        "price": "\$2427.89",
        "cooler": "Corsair H150i",
        "case": "Lian Li PC-O11 Dynamic"
      },
      {
        "title": "AMD High End",
        "cpu": "AMD Ryzen 9 7950X3D",
        "gpu": "AMD Radeon RX 7900 XTX",
        "ram": "32GB DDR5",
        "price": "\$2354.03",
        "cooler": "Corsair H150i",
        "case": "Lian Li PC-O11 Dynamic"
      },
    ],
  };

 @override
Widget build(BuildContext context) {
  String selectedCategory = categories[_selectedCategoryIndex];
  List<Map<String, String>> selectedGuides = guideItems[selectedCategory]!;

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

class GuidesDetailScreen extends StatelessWidget {
  const GuidesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      backgroundColor: AppColors.bodyBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black) ,
        backgroundColor: AppColors.appBarBackgroundColor,
        title: Text(
          args['title']!,
          style:  TextStyle(color: Colors.black, fontSize: 24,),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: Colors.black),
            SizedBox(height: 20,),
            Text("CPU: ${args['cpu']}", style: const TextStyle(fontSize: 18)),
            Text("GPU: ${args['gpu']}", style: const TextStyle(fontSize: 18)),
            Text("RAM: ${args['ram']} (3200 MHz)", style: const TextStyle(fontSize: 18)),
            Text("Motherboard: ASUS Prime B660M-A", style: const TextStyle(fontSize: 18)),
            Text("PSU: Corsair RM750", style: const TextStyle(fontSize: 18)),
            Text("Case: ${args['case']}", style: const TextStyle(fontSize: 18)),
            Text("CPU Cooler: ${args['cooler']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text("Total Price: ${args['price']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            const SizedBox(height: 20),
          ],
        ),
      ),
     
    );
  }
}