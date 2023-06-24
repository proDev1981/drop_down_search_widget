import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String?                       label;
  bool                                _isOvelayHover = false;
  bool                                _isTextFieldFocus = false;
  bool                                _isMenuVisible = false;

  // constructor
  DropdownSearch
    ({
      this.sugestionHeight = 200,
      this.height = 60,
      this.width = 300,
      this.controller,
      this.iconClear,
      this.failMessage = 'fail:not sugestion',
      required this.listSugestion,
      super.key, 
      this.label,
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
          child: MouseRegion(
            onEnter: _handleOverlayEnter,
            onExit: _handleOverlayExit,
            child: ShowListTile(
              dependecies,
              controller: controller!, 
              parent: _overlayEntry
            ),
          )        
        ),
      );
    }
    );
  
  }


  // methos
  void _handleOverlayEnter(PointerEnterEvent value) => _isOvelayHover = true;

  void _handleOverlayExit(PointerExitEvent value){
    _isOvelayHover = false;
    if(!_isTextFieldFocus) _handleSubmit("");
  }

  void _handleFocus(bool isFocus){
    if(isFocus){
      if(!_isMenuVisible){
        _overlay.insert(_overlayEntry);
        _isMenuVisible = true;
      }
    }
    if(!isFocus && !_isOvelayHover ){
      _handleSubmit("");
    } 
    _isTextFieldFocus = !_isTextFieldFocus;
  }

  void _findSugestion(String query){
    final res = listSugestion.where((e) => e.toLowerCase().contains(query.toLowerCase())).toList();
    if(res.isEmpty) res.add(failMessage);
    dependecies.value = res;
  }

  void _handleSubmit(String value){
    if(_isMenuVisible){
      _overlayEntry.remove();
      _isMenuVisible =false;
      dependecies.value = listSugestion;
    }
  }

  void _handleKeyEventTextField(RawKeyEvent e ){
    if(e.isKeyPressed(LogicalKeyboardKey.arrowRight)){
      // TODO: reparar textEditingController fail
    }
  }

  // builder
  @override
  Widget build(BuildContext context) {
    // inicialicer overlay field
    _overlay = Overlay.of(context);
    final suffix = iconClear != null 
      ? IconButton(
          icon: iconClear!, 
          onPressed: controller?.clear,
        )
      : null;

    return CompositedTransformTarget(
      link: layerLink,
      child: Focus(
        onFocusChange: _handleFocus,
        child:  SizedBox(
          width: width,
          height: height,
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: _handleKeyEventTextField ,
            child: TextField( 
              decoration:InputDecoration(
                label: label != null ? Text(label!) : null,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                suffixIcon: suffix,
              ),
              onSubmitted: _handleSubmit,
              onChanged: _findSugestion,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
