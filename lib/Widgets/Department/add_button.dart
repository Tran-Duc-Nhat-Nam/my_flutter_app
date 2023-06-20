import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({
    super.key,
    required this.notifyParent,
    required this.getPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.setPosition,
    required this.getRef,
  });

  final Function() notifyParent;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getRef;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  String text = "Thêm";

  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    return ElevatedButton(
        onPressed: () async {
          if (text == "Thêm") {
            setState(() {
              widget.getIdControl().clear();
              widget.getNameControl().clear();
              text = "Lưu";
              widget.setPosition(-1);
              widget.notifyParent();
            });
          } else {
            if (widget.getNameControl().text.isNotEmpty &&
                widget.getIdControl().text.isNotEmpty) {
              DatabaseReference newEmpolyeeRef =
                  widget.getRef().child(widget.getIdControl().text);

              var event = await newEmpolyeeRef.once();
              var snapshot = event.snapshot;

              if (snapshot.value == null) {
                newEmpolyeeRef.set({
                  "name": widget.getNameControl().text,
                });
                widget.getIdControl().clear();
                widget.getNameControl().clear();
                text = "Thêm";
                widget.notifyParent();
                messenger.showSnackBar(const SnackBar(
                    content: Text("Thêm thông tin phòng ban thành công")));
              } else {
                messenger.showSnackBar(const SnackBar(
                    content: Text("Thông tin phòng ban đã tồn tại")));
              }
            } else {
              messenger.showSnackBar(
                  const SnackBar(content: Text("Vui lòng điền đủ thông tin")));
            }
          }
        },
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ));
  }
}
