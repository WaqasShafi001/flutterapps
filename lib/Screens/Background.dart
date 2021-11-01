import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget? child;
  const Background({
    Key? key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/splash.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(1),
              Colors.black.withOpacity(0.7),
            ])),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              bottom: 100,
              child: child!,
            ),

          ],
        ),
      ),
    );
  }
}