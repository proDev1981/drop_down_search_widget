
import 'package:flutter/material.dart';

class OverlayItem extends StatelessWidget{
  // constructor
  const OverlayItem({
    required this.value,
    required this.controller,
    required this.parent,
    this.focusNode,
    super.key
  });

  // properties
  final String                value;
  final TextEditingController controller;
  final OverlayEntry          parent;
  final FocusNode?            focusNode;

  // methos
  void _handleOnPressed(){
      controller.text = value;
      parent.remove();
  }

  // builder
  @override
  Widget build(BuildContext context) {

    final color = value.contains('fail:') ? Colors.grey : null;
    final result = value.replaceFirst('fail:','');

    return  Material(
              child: ListTile(
                      focusNode: focusNode,
                      onTap: _handleOnPressed,
                      title: Text(
                                result,
                                style: TextStyle(color: color)
                              ),
              ),
    );
  }
}