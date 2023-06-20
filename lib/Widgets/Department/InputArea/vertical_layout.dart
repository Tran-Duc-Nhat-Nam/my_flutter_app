import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/Widgets/Department/add_button.dart';
import 'package:my_flutter_app/Widgets/Department/delete_button.dart';

class VerticalInputArea extends StatefulWidget {
  const VerticalInputArea({
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
  State<VerticalInputArea> createState() => _VerticalInputAreaState();
}

class _VerticalInputAreaState extends State<VerticalInputArea> {
  bool isReadOnly = true;

  refresh() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: SelectableText("Mã nhân viên"),
                )),
            Expanded(
              flex: 2,
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: widget.getIdControl(),
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: SelectableText("Họ tên"),
                )),
            Expanded(
              flex: 2,
              child: TextField(
                controller: widget.getNameControl(),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AddButton(
            notifyParent: refresh,
            getPosition: widget.getPosition,
            setPosition: widget.setPosition,
            getIdControl: widget.getIdControl,
            getNameControl: widget.getNameControl,
            getRef: widget.getRef,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DeleteButton(
            getIdControl: widget.getIdControl,
            getRef: widget.getRef,
          ),
        ),
      ],
    );
  }
}
