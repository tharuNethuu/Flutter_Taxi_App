import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

Widget textWidget({required String text, double fontSize =12, FontWeight = FontWeight.normal, double? height, Color color = Colors.black,}){
  return Text(text, style: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight, height: height, color: color),);
}