import 'package:flutter/material.dart';

import 'show_list_tile.dart';

// ignore: must_be_immutable
class DropdownSearch extends StatelessWidget{
  // properties
  late  OverlayEntry                  _overlayEntry;
  late  OverlayState                  _overlay;
  late  TextEditingController?        controller;
  late  ValueNotifier<List<String>>   dependecies;
  late  LayerLink                     layerLink;
  final List<String>                  listSugestion;

  // constructor
  DropdownSearch
    ({
      this.controller,
      required this.listSugestion,
      super.key
    }){

    controller = controller ?? TextEditingController();
    layerLink = LayerLink();
    dependecies = ValueNotifier<List<String>>(listSugestion);

    _overlayEntry = OverlayEntry(builder: (context){

      return Positioned(
        // TODO: tengo que obtener tamaño del textfield
        width: 200,
        height: 400,
        child: CompositedTransformFollower(
          offset: const Offset(0,50),
          link: layerLink ,
          child: ShowListTile(
            dependecies,
            controller: controller!, 
            parent: _overlayEntry
          )        
        ),
      );
    }
    );
  
  }


  // methos
  void _handleFocus(bool isFocus){
    if(isFocus) _overlay.insert(_overlayEntry);
    /*isFocus 
      ? _overlay.insert(_overlayEntry)
      : Timer(const Duration(milliseconds: 300),_overlayEntry.remove);
    */
  }
  void _findSugestion(String query){
    final res = listSugestion.where((e) => e.toLowerCase().contains(query.toLowerCase())).toList();
    if(res.isEmpty) res.add("not found");
    dependecies.value = res;
  }

  // builder
  @override
  Widget build(BuildContext context) {
    // inicialicer overlay field
    _overlay = Overlay.of(context);

    return CompositedTransformTarget(
      link: layerLink,
      child: Focus(
        onFocusChange: _handleFocus,
        child:  TextField( 
          onChanged: _findSugestion,
          controller: controller,
        ),
      ),
    );
  }
}
