import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

Widget greenIntroWidget3() {
  return Container(
    width: Get.width,
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/mask4.png'), fit: BoxFit.cover)),
    height: Get.height * 0.6,

/* child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/logo.svg'),
        const SizedBox(
          height: 60,
        ),
        
      ],
    ) ,
), */
  );
}
