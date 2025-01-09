import 'package:flutter/material.dart';

class CarModelPage extends StatefulWidget {
  CarModelPage({Key? key, required this.selectedCarModel, required this.onSelect,}) : super(key: key);

  final String selectedCarModel;

  final Function onSelect;

  @override
  State<CarModelPage> createState() => _CarModelPageState();
}

class _CarModelPageState extends State<CarModelPage> {
  List<String> carModels = [
    "Bajaj RE Compact",
    "TVS King",
    "Mahindra Alfa",
    "Toyota Prius",
    "Toyota Corolla Axio",
    "Honda Fit Shuttle",
    "Nissan NV200 ",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "What is your car model?",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),



        ListView.builder(
          itemBuilder: (ctx, i) {
            return ListTile(

                onTap: () => widget.onSelect(carModels[i]),
              visualDensity: VisualDensity(vertical: -4),
              title: Text(carModels[i]),
              trailing: widget.selectedCarModel == carModels[i]
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
          itemCount: carModels.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
        )
      ],
    );
  }
}
