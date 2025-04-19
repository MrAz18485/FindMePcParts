import 'package:findmepcparts/nav_bar.dart';
import 'package:findmepcparts/util/colors.dart';
import 'package:findmepcparts/util/text_styles.dart';
import 'package:flutter/material.dart';


Widget buildCommunityCard({
  required BuildContext context,
  required String title,
  required String rating,
  required String price,
}) {
  String imageUrl;
  if (title == 'Mid Range Beast') {
    imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/501643.3add376deb95f0b932c098aba476bcd9.1600.jpg';
  } else if (title == 'RTX 4080 + 14900K Setup') {
    imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/501651.4a0f0ca20ae0880fc56c3e586c8a1ef9.1600.jpg';
  } else if (title == 'Budget Build') {
    imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/485439.72a1f8f9f98d3d8851daed55378ceb7c.1600.jpg';
  } else {
    imageUrl = 'https://via.placeholder.com/400';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Divider(
        color: Colors.black,
      ),
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Text(rating, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 4),
      Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/communityDetails', arguments: {
              'title': title,
              'rating': rating,
              'price': price,
            });
          },
          style: buttonStyle,
          child: const Text("Select"),
        ),
      ),
      const SizedBox(height: 10),
      Container(
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bodyBackgroundColor,
        centerTitle: false,
        title: Text(
              "Community" ,
              style: appBarTitleTextStyle,
            ),
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                
                  const SizedBox(height: 20),
                  buildCommunityCard(
                    context: context,
                    title: "Mid Range Beast",
                    rating: "★ 4.8 (32 reviews)",
                    price: "\$1323.67",
                  ),
                  const SizedBox(height: 20),
                  buildCommunityCard(
                    context: context,
                    title: "RTX 4080 + 14900K Setup",
                    rating: "★ 5.0 (50 reviews)",
                    price: "\$2897.56",
                  ),
                  buildCommunityCard(
                    context: context,
                    title: "Budget Build",
                    rating: "★ 4.2 (13 reviews)",
                    price: "\$617.43",
                  ),
              ]
            
            ),
          )
        ],
      ),
           floatingActionButton: FloatingActionButton(
              tooltip: "New Post",
              onPressed: () {},
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    String imageUrl;
    if (args['title'] == 'Mid Range Beast') {
      imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/501643.3add376deb95f0b932c098aba476bcd9.1600.jpg';
    } else if (args['title'] == 'RTX 4080 + 14900K Setup') {
      imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/501651.4a0f0ca20ae0880fc56c3e586c8a1ef9.1600.jpg';
    } else if (args['title'] == 'Budget Build') {
      imageUrl = 'https://cdna.pcpartpicker.com/static/forever/images/userbuild/485439.72a1f8f9f98d3d8851daed55378ceb7c.1600.jpg';
    } else {
      imageUrl = 'https://via.placeholder.com/400'; 
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppColors.appBarBackgroundColor,
        title: Text(args['title']!, style: const TextStyle(color: Colors.black, fontSize: 24,)),
      ),
      backgroundColor: AppColors.bodyBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),

          children: [
            Divider( color: Colors.black,),
            SizedBox(height: 10,),
            Text("Rating: ${args['rating']}", style: const TextStyle(fontSize: 18)),
            Text("Price: ${args['price']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text("Specs:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (args['title'] == 'Mid Range Beast') ...[
              const Text("CPU: Intel Core i5-12400F"),
              const Text("GPU: NVIDIA RTX 3060"),
              const Text("RAM: 16GB DDR4 3200MHz"),
              const Text("Motherboard: MSI B660M Mortar"),
              const Text("PSU: Corsair CX650M"),
              const Text("Case: NZXT H510"),
            ] else if (args['title'] == 'RTX 4080 + 14900K Setup') ...[
              const Text("CPU: Intel Core i9-14900K"),
              const Text("GPU: NVIDIA RTX 4080"),
              const Text("RAM: 64GB DDR5 6000MHz"),
              const Text("Motherboard: ASUS Z790 Hero"),
              const Text("PSU: Corsair RM1000x"),
              const Text("Case: Lian Li O11 Dynamic"),
            ] else if (args['title'] == 'Budget Build') ...[
              const Text("CPU: AMD Ryzen 3 4100"),
              const Text("GPU: AMD RX 6400"),
              const Text("RAM: 8GB DDR4 3000MHz"),
              const Text("Motherboard: ASRock A320M-HDV"),
              const Text("PSU: EVGA 500W Bronze"),
              const Text("Case: Cooler Master Q300L"),
            ],
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 150),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
    );
  }
}