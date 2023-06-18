
import 'package:flutter/material.dart';

class OverlayItem extends StatelessWidget{
  // constructor
  const OverlayItem({
    required this.value,
    required this.controller,
    required this.parent,
    super.key
  });

  // properties
  final String                value;
  final TextEditingController controller;
  final OverlayEntry          parent;

  // methos
  void _handleOnPressed(){
      controller.text = value;
      parent.remove();
  }

  // builder
  @override
  Widget build(BuildContext context) {

    return  Material(
              child: ListTile(
                      onTap: _handleOnPressed,
                      title: Text(value),
              ),
    );
  }
}