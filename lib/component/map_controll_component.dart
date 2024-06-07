import 'package:flutter/material.dart';

class MapControllButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  const MapControllButton({
    Key? key,
    required this.width,
    required this.child,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.lightBlueAccent,
      ),
      child: Center(child: child),
    );
  }
}
