import 'package:findmepcparts/build.dart';
import 'package:findmepcparts/build_card.dart';
import 'package:findmepcparts/login_screens.dart';
import 'package:findmepcparts/product.dart';
import 'package:flutter/material.dart';
import 'package:findmepcparts/product_card.dart';
import 'package:findmepcparts/nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Product> products =  [
    Product(productName: "Intel Core i5 750 2,6 GHz 8 MB Cache 1156 Pin", price: 643 , percent: 35 ,imageURL: "assets/processor.webp", 
    property:"""
  Overclock: Yes
  Processor Technology: Core i5
  Bus Speed: 1066 MHz
  Socket Type: 1156 Pin
  Processor Generation: 1st Generation
  Processor Cache: 8 MB Cache
  Base Processor Speed: 2.6 GHz
  Processor Number: 750
  L3 Cache: 8 MB
  Stock Quantity: Less than 5 units""", saleURL: "https://www.hepsiburada.com/intel-core-i5-750-2-6-ghz-8-mb-cache-1156-pin-islemci-p-BD992322?magaza=kurtandkurt&wt_pc=akakce&adj_t=1fmpah5v_1fmqteof&adj_campaign=akakce&utm_source=pc&utm_medium=akakce&v=1.10.2" ),
    Product(productName: "GIGABYTE GeForce RTX™ 4060 WINDFORCE OC 8G", price: 13577, percent: 60 ,imageURL: "assets/4060.jpg",
    property: """
  HDMI Output: Yes
  Graphics Processor: GeForce RTX 4060
  Number of Fans: 2
  Display Port Output: 2
  Memory Capacity: 8 GB
  Display Port: Yes
  Memory Speed: 2125 MHz
  Processor Manufacturer: NVIDIA
  Bit Value: 128
  Brand: Gigabyte
  Memory Type: GDDR6""",
  saleURL: "https://www.n11.com/urun/gigabyte-nvidia-geforce-rtx-4060-windforce-oc-8g-gv-n4060wf2oc-8gd-8-gb-gddr6-128-bit-ekran-karti-40941002?magaza=hobbyturkey&utm_source=comp_epey&utm_medium=cpc&utm_campaign=epey_genel"),
    Product(productName: "Kingston 8GB 1333MHz DDR3", price: 379, percent: 90,imageURL: "assets/ram.jpg", 
    saleURL: "https://www.hepsiburada.com/kingston-8gb-1333mhz-ddr3-masaustu-ram-kvr1333d3n9-8g-p-BD304134?magaza=Teori&wt_pc=akakce&adj_t=1fmpah5v_1fmqteof&adj_campaign=akakce&utm_source=pc&utm_medium=akakce&v=1.2",
    property: """
  RAM Capacity: 8 GB
  Compatible Systems: PC
  RAM Speed: 1333 MHz
  CAS Latency: 9 ns
  Usage Type: DDR3
  Stock Quantity: Less than 50 units"""),
    Product(productName:'GIGABYTE A620M H AMD Soket AM5 DDR5 6400MHz(OC)' , price: 3581, percent: 23,imageURL: "assets/mainboard.jpg",
    saleURL: "https://www.amazon.com.tr/Gigabyte-B650M-S2H-Gaming-Anakart/dp/B0CGMBV6XD/ref=asc_df_B0CGMBV6XD?mcid=01e1fb63c24c30f08f739cd0360d6499&tag=trshpngglede-21&linkCode=df0&hvadid=710198765442&hvpos=&hvnetw=g&hvrand=17719072671939693891&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=1012764&hvtargid=pla-2261154914319&language=tr_TR&gad_source=4&th=1",
    property: """
  Socket Type: Socket AM5
  RAM Type: DDR5
  Motherboard Brand: GIGABYTE
  Motherboard Chipset: AMD® A620
  Motherboard Form Factor: mATX
  RAM Slot Count: 2
  Max. RAM Support: 96GB
  Supported Max RAM Speed: 5200MHz
  M.2 Slot Count: 1
  USB 3.2 Ports: 2
  USB 2.0 Ports: 1
  HDMI: 1
  DisplayPort: 1
  Wireless Connectivity (Wi-Fi): No
  Bluetooth: No
  Ethernet: 10/100/1000Mbps)""")
  ];


List<Build> builds = [
  Build(buildname: "Build 1", partsstring: ["Intel Core i5 750", "GeForce RTX 4060", "Kingston 8 GB 1333 Mhz RAM"], parts: [
    Part(partname: "Intel Core i5 750", partcategory: "Processor(CPU)", partprice: 15),
    Part(partname: "GeForce RTX 4060", partcategory: "Graphics Card(GPU)", partprice: 350, imageURL: 'assets/4060.jpg'),
    Part(partname: "Kingston 8 GB 1333 Mhz RAM", partcategory: "Physical Memory(RAM)", partprice: 30, imageURL: 'assets/ram.jpg')
  ]),
  Build(buildname: "Build 2", partsstring: ["Intel Core i7 13700"], parts: [
    Part(partname: "Intel Core i7 13700", partcategory: "Processor(CPU)", partprice: 150, imageURL: 'assets/i7_13700.jpg')
  ])
];

void main() {
  runApp(MaterialApp(
    initialRoute: '/splash',
    routes: {
      '/splash': (context) => const SplashScreen(),
      '/welcome': (context) => const LoginChoiceScreen(),
      '/signin': (context) => const SignInScreen(),
      '/signup': (context) => const SignUpScreen(),
      '/profileSetup': (context) => const ProfileSetupScreen(),
      '/sales': (context) =>  const OnSale(),
      '/community': (context) => const OnSale(),
      '/settings': (context) =>  const OnSale(),
      '/builder': (context) =>  const Builds(),
      '/guides': (context) =>  const OnSale(),
    },
  ));
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/welcome');
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.brown],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/goblin.png", width: 150, height: 150),
              const SizedBox(height: 20),
              const Text(
                "PC GOBLIN",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnSale extends StatelessWidget{
  const OnSale({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'On Fire',
              style: TextStyle(
                fontSize: 40,  // Yazı boyutunu buradan ayarlayabilirsiniz
              ),
            ),
            SizedBox(width: 8),
            Text('🔥', style: TextStyle(fontSize: 40))
          ],
        ),
      ),
      body:
        Container(
        color : Colors.white,
        child: 
          ListView(
          children: 
             products.map((product)=> ProductCard(
                product:product,)
            ).toList(),
        ),
        ),
      bottomNavigationBar:const CustomNavBar(),
    );
  }
}

class Builds extends StatelessWidget {
  const Builds({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Builds", style: TextStyle(fontSize: 40),),
            SizedBox(width: 10,),
            Expanded(
              child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {}, 
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.black), child: Text("+", style: TextStyle(color: Colors.white, fontSize: 30))),
              ],
            )
            )
          ],
        )
      ),
      body: Container(
        color: Colors.white,
        // margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: 
        ListView( 
          children: 
            builds.map((build) => Buildcard(userbuild: build)).toList(),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}

class PartPage extends StatefulWidget {
  final String BuildName;
  List<Part> parts;
  PartPage({super.key, required this.BuildName, required this.parts});
  @override
  State<PartPage> createState() => _PartPageState();
}

class _PartPageState extends State<PartPage> {  
  late List<PartCard> partCards = [];
  late List<TextButton> buttons = [];

  @protected
  @mustCallSuper
  void initState() {
    for (int i = 0; i < widget.parts.length; i++)
    {
      partCards.add(PartCard(CurrentPart: widget.parts[i]));
    }
    buttons.add(
      TextButton(onPressed: () {
        setState(() {
          print("Called delete!");
          partCards.clear();
          buttons.clear();
        });
      }, child: Icon(FontAwesomeIcons.trashCan, color: Colors.black, size: 25,)));
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, // Bayağı ilginç bir şey bu. Senin yaptığın product_card'daki geri gitme ikonunu appbar'a getiriyor :D 
                                         // https://api.flutter.dev/flutter/material/AppBar/automaticallyImplyLeading.html
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [Text(widget.BuildName, style: TextStyle(fontSize: 40),), Spacer(), TextButton(onPressed: () {}, child: Icon(FontAwesomeIcons.plus, color: Colors.black, size: 30,))]
              ),
            )
          ]
        )
      ),
      body:
      Container(
        color: Colors.white,
        child: 
          ListView(
            children: [
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20,),            
                  Column(
                    children: partCards,
                  ),
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // buttons[0]
                    
                    TextButton(onPressed: () {
                      setState(() {
                        print("Called delete!");
                        partCards.clear();
                      });
                    }, child: Icon(FontAwesomeIcons.trashCan, color: Colors.black, size: 25,))
                    
                  ],)
                ]
              )
            ],
          )
        ) 
    );
  }
}
