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
  List<Part> _partInfoWidget = [];

  void _addNewPart(Part partToAdd) {
    setState(() {
      _partInfoWidget.add(partToAdd);
      print("Added widget!");
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
                      _addNewPart(Part(partname: widget.CurrentPart.partname, partcategory: widget.CurrentPart.partcategory, partprice: widget.CurrentPart.partprice));
                      pressed = !pressed;
                    });
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.white), child: Icon(pressed ? FontAwesomeIcons.arrowUp: FontAwesomeIcons.arrowDown, color: Colors.black,))
                ]
              ),
              if (_partInfoWidget.length == 1)
                infoPart(_partInfoWidget[0]),
            ],
          ),
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
                Image.asset('assets/placeholder.png', height: 120, width: 120,),
                SizedBox(height: 5,),
                Text(CP.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                SizedBox(height: 5,),
                Text(CP.partprice.toInt().toString(), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                Row(children: [
                  Spacer(),
                    TextButton(onPressed: () {}, child: Icon(FontAwesomeIcons.trashCan))
                ],)
              ],
            )
        );
}

// add a child like this.
/*
                  _addNewWidget(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/placeholder.png'),
                      SizedBox(height: 5,),
                      Text(widget.CurrentPart.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      SizedBox(height: 5,),
                      Text(widget.CurrentPart.partcategory, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      Row(children: [
                        TextButton(onPressed: () {}, child: Icon(FontAwesomeIcons.trashCan))
                      ],)
                    ],
                  ));
*/