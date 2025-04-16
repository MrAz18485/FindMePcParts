import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:findmepcparts/build.dart';
import 'package:findmepcparts/main.dart';

class Buildcard extends StatelessWidget 
{
  final Build userbuild;
  const Buildcard({super.key, required this.userbuild});

  @override
  Widget build(BuildContext context)
  {
    return Card (
      color: Colors.white,
      shape: RoundedRectangleBorder(side:BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(12),),
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child:
          Row(
            children: [
              Icon(FontAwesomeIcons.wrench,),
              SizedBox(width: 15,),
              Expanded(child:
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text(userbuild.buildname, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 3,),
                    Text(userbuild.partsstring.toString().substring(1, userbuild.partsstring.toString().length - 1), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PartPage(BuildName: userbuild.buildname, parts: userbuild.parts,)));
                    }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white,), child: Text("View")),
                  ]
                ),
              )
            ],
      ))  
    );
  }
}

class PartCard extends StatefulWidget {
  final Part CurrentPart;
  const PartCard({super.key, required this.CurrentPart});
  @override
  State<PartCard> createState() => _PartCardState();
}

class _PartCardState extends State<PartCard> 
{
  bool pressed = false;
  List<Card> Cards = [];

  void _addNewPart(Card CurrentCard) {
    setState(() {
      Cards.add(CurrentCard);
      // print("Added widget!");
    });
  }

  void _removePart() {
    setState(() {
      Cards.remove(Cards[0]);
      // print("Removed widget!");
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(side:BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5),),
      child: Column( 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(widget.CurrentPart.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5,),
                      Text(widget.CurrentPart.partcategory, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5,),
                    ],
                  ), 
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {
                    setState(() {
                      if (!pressed)
                      {
                        _addNewPart(infoPart(widget.CurrentPart));
                      }
                      if (pressed)
                      {
                        _removePart();
                      }
                      pressed = !pressed;
                    });
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.white), child: Icon(pressed ? FontAwesomeIcons.arrowUp: FontAwesomeIcons.arrowDown, color: Colors.black,))
                ]
              ),

            ],
          ),
          for (int i = 0; i < Cards.length; i++)
            Cards[i]
        ]
      ),
    );
  }
}

Card infoPart(Part CP)
{
  return Card(
          color: Colors.white,
          elevation: 0,
          child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(CP.imageURL, height: 120, width: 120,),
                SizedBox(height: 5,),
                Text(CP.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(FontAwesomeIcons.dollarSign),
                  Text(CP.partprice.toInt().toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                ],)
              ],
            )
        );
}