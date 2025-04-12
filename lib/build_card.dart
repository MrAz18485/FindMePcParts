import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:findmepcparts/build.dart';
import 'package:findmepcparts/main.dart';
import 'dart:io';

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
                    Text(userbuild.components.toString().substring(1, userbuild.components.toString().length - 1), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    SizedBox(height: 20,),
                    ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PartPage(BuildName: userbuild.buildname, parts: userparts,)));
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
  @override
  Widget build(BuildContext context)
  {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(side:BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5),),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.CurrentPart.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  SizedBox(height: 10,),
                  Text(widget.CurrentPart.partcategory, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ), 
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
            TextButton(onPressed: () {
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(File('placeholder.png')),
                  SizedBox(height: 5,),
                  Text(widget.CurrentPart.partname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  SizedBox(height: 5,),
                  Text(widget.CurrentPart.partcategory, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  Row(children: [],)
                ],
              );
            }, style: ElevatedButton.styleFrom(backgroundColor: Colors.white), child: Icon(Icons.arrow_downward_rounded, color: Colors.black,))            
            ],)
        ],
      ),
    );
  }
}

