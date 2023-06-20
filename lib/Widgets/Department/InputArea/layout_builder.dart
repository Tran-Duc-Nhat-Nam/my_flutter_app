import 'package:flutter/material.dart';
import 'package:my_flutter_app/Widgets/Department/InputArea/horizontal_layout.dart';
import 'package:my_flutter_app/Widgets/Department/InputArea/vertical_layout.dart';

class InputArea extends StatefulWidget {
  const InputArea({
    super.key,
    required this.getPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.setPosition,
    required this.getRef,
    required this.getData,
  });

  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getRef;
  final Function() getData;

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool isReadOnly = true;

  refresh() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
        if (boxConstraints.maxWidth > 600) {
          return HorizontalInputArea(
            getPosition: widget.getPosition,
            setPosition: widget.setPosition,
            getIdControl: widget.getIdControl,
            getNameControl: widget.getNameControl,
            getRef: widget.getRef,
            getData: widget.getData,
          );
        } else {
          return VerticalInputArea(
            getPosition: widget.getPosition,
            setPosition: widget.setPosition,
            getIdControl: widget.getIdControl,
            getNameControl: widget.getNameControl,
            getRef: widget.getRef,
            getData: widget.getData,
          );
        }
      },
    );
  }
}
