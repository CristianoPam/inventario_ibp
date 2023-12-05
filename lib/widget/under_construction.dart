import 'package:flutter/material.dart';

class UnderConstruction extends StatelessWidget {
  const UnderConstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration:   BoxDecoration(
        border: Border(bottom:BorderSide(width: 10)),
        
        color: Colors.white,
        image: DecorationImage(image: AssetImage('assets/images/page-under-construction.png') ),),
      );
      
  }
}



