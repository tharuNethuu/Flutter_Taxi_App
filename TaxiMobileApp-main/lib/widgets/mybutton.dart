import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget DecisionButton( String icon, String text, Function onPressed, double width, {double height=60}){
  return InkWell(
    onTap: () => onPressed(),
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
           color: Colors.black.withOpacity(0.05),
                  spreadRadius: 3,
                  blurRadius: 3,
          ),
        ]
       ),
       child:Row (
        children: [
        Container(
          width: 66,
          height: height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 2, 96, 173),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8)),
          ),
          child: Center(
            child: Image.asset(icon,width: 30,)) ,
        ),

        Expanded(child: Text(text,style: GoogleFonts.poppins(color: Colors.black,fontSize: 16,
                        fontWeight: FontWeight.w600, ), textAlign: TextAlign.center ,)),

       

       ],),
    ),
  );
}