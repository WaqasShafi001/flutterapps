import 'package:flutter/material.dart';
import 'package:flutterapps/Helper/constants.dart';

class SocalIcon extends StatelessWidget {
  final String? iconSrc;
  final VoidCallback? press;
  const SocalIcon({
    Key? key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 50,
        width: 50,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: kPrimaryLightColor,
          ),
          shape: BoxShape.circle,
        ),
        child: Image(
          image: AssetImage(iconSrc!),
        color: Colors.white,
       ),
      ),
    );
  }
}