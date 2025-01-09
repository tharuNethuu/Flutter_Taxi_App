import 'package:flutter/material.dart';

class Car_clr extends StatefulWidget {
  Car_clr({Key? key, required this.selectedCarColor, required this.onSelect,}) : super(key: key);

  final String selectedCarColor;

  final Function onSelect;

  @override
  State<Car_clr> createState() => _Car_clrState();
}

class _Car_clrState extends State<Car_clr> {
  List<String> carColors = [
    "Green",
    "Red",
    "Yellow",
    "White",
    "Black",
    "Blue",
    "Another",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "What is the vehicle's color",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),



        ListView.builder(
          itemBuilder: (ctx, i) {
            return ListTile(

                onTap: () => widget.onSelect(carColors[i]),
              visualDensity: VisualDensity(vertical: -4),
              title: Text(carColors[i]),
              trailing: widget.selectedCarColor == carColors[i]
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor:Colors.blue[800],
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            );
          },
          itemCount: carColors.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        )
      ],
    );
  }
}
