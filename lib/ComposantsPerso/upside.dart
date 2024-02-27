import 'package:flutter/material.dart';
import 'package:medo_plante_1/ComposantsPerso/constants.dart';

class Upside extends StatelessWidget {
  const Upside({Key? key, required this.imgUrl}) : super(key: key);
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.5,
          color: KPrimaryColor, // Added comma here
          child: Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Image.asset(
              imgUrl,
              alignment: Alignment.topCenter,
              scale: 8,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 175,
          child: Image.network("src"),
        ),
      ],
    );
  }
}