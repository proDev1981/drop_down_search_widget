import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'overlay_item.dart';

// ignore: must_be_immutable
class ShowListTile<T> extends StatefulWidget {
  // properties
  Widget?                     first;
  Widget?                     last;
  double?                     separation;
  //MainAxisAlignment?        alignment;
  double?                     width;
  double?                     height;
  final ValueListenable<T>    dep;
  final TextEditingController controller;
  final OverlayEntry          parent;
  List<FocusNode>?       focusEntries;
  // constructors
  ShowListTile(this.dep,{
    this.height,
    this.width,
    this.separation,
    this.focusEntries,
    required this.parent,
    required this.controller,
    //this.alignment,
    this.first,
    this.last,
    super.key
    }){ 
    //alignment   = alignment   ?? MainAxisAlignment.start;
    separation    = separation  ?? 0;
    width         = width       ?? 150;
    height        = height      ?? 100;
    focusEntries ??= <FocusNode>[];
  }
  // state
  @override
  State<StatefulWidget> createState() => _ShowListTileState();
}

class _ShowListTileState<T> extends State<ShowListTile> {
  // properties
  Widget? resWidget;

  @override
  void initState() {
    super.initState();
    widget.dep.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(ShowListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dep != widget.dep) {
      oldWidget.dep.removeListener(_valueChanged);
      widget.dep.addListener(_valueChanged);
    }
  }

  @override
  void dispose() {
    widget.dep.removeListener(_valueChanged);
    widget.focusEntries?.clear();
    super.dispose();
  }

  void _valueChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final list = (widget.dep.value as List);
    if(widget.focusEntries!.isNotEmpty) widget.focusEntries!.clear();

      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){

            widget.focusEntries?.add(FocusNode());

            return OverlayItem(
              focusNode: widget.focusEntries?[index],
              value: list[index],
              parent: widget.parent,
              controller: widget.controller ,
            );
          }
        )
      );
    }
}
