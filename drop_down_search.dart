import 'package:flutter/material.dart';

import 'show_list_tile.dart';
// TODO: tengo que implementar stylos para el widget
// ignore: must_be_immutable
class DropdownSearch extends StatelessWidget{
  // properties
  late  OverlayEntry                  _overlayEntry;
  late  OverlayState                  _overlay;
  late  TextEditingController?        controller;
  late  ValueNotifier<List<String>>   dependecies;
  late  LayerLink                     layerLink;
  final List<String>                  listSugestion;
  final double                        width;
  final double                        height;
  final double                        sugestionHeight;
  final String                        failMessage;
  final Icon?                         iconClear;


  // constructor
  DropdownSearch
    ({
      this.sugestionHeight = 200,
      this.height = 40,
      this.width = 300,
      this.controller,
      this.iconClear,
      this.failMessage = 'fail:not sugestion',
      required this.listSugestion,
      super.key
    }){

    controller = controller ?? TextEditingController();
    layerLink = LayerLink();
    dependecies = ValueNotifier<List<String>>(listSugestion);

    _overlayEntry = OverlayEntry(builder: (context){

      return Positioned(
        width: width,
        height: sugestionHeight,
        child: CompositedTransformFollower(
          offset: Offset(0,height),
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
    if(res.isEmpty) res.add(failMessage);
    dependecies.value = res;
  }
  void _handleSubmit(String value){
    _overlayEntry.remove();
    dependecies.value = listSugestion;
  }

  // builder
  @override
  Widget build(BuildContext context) {
    // inicialicer overlay field
    _overlay = Overlay.of(context);
    final suffix = iconClear != null 
      ? IconButton(
          icon: iconClear!, 
          onPressed: controller!.clear,
        )
      : null;
 

    return CompositedTransformTarget(
      link: layerLink,
      child: Focus(
        onFocusChange: _handleFocus,
        child:  SizedBox(
          width: width,
          height: height,
          child: TextField( 
            decoration:InputDecoration(
              suffixIcon: suffix             ),
            onSubmitted: _handleSubmit,
            onChanged: _findSugestion,
            controller: controller,
          ),
        ),
      ),
    );
  }
}
