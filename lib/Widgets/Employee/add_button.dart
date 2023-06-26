import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddButton extends StatefulWidget {
  const AddButton({
    super.key,
    required this.notifyParent,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getRef,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
    required this.getDepartmentID,
  });

  final Function() notifyParent;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getAdressControl;
  final Function() getPhoneNumberControl;
  final Function() getRef;
  final Function() getDepartmentID;

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
              widget.getIdControl().clear();
              widget.getIdControl().clear();
              text = "Lưu";
              widget.setPosition(-1);
              // eData!.update();
              widget.notifyParent();
            });
          } else {
            if (widget.getIdControl().text.isNotEmpty &&
                widget.getNameControl().text.isNotEmpty &&
                widget.getAdressControl().text.isNotEmpty &&
                widget.getPhoneNumberControl().text.isNotEmpty) {
              DatabaseReference newEmpolyeeRef =
                  widget.getRef().child(widget.getIdControl().text);

              var event = await newEmpolyeeRef.once();
              var snapshot = event.snapshot;

              if (snapshot.value == null) {
                newEmpolyeeRef.set({
                  "name": widget.getNameControl().text,
                  "address": widget.getAdressControl().text,
                  "phoneNumber": widget.getPhoneNumberControl().text,
                  "departmentID": widget.getDepartmentID().toString(),
                });
                widget.getIdControl().clear();
                widget.getNameControl().clear();
                widget.getAdressControl().clear();
                widget.getPhoneNumberControl().clear();
                text = "Thêm";
                widget.notifyParent();
                messenger.showSnackBar(const SnackBar(
                    content: Text("Thêm nhân viên thông tin thành công")));
              } else {
                messenger.showSnackBar(const SnackBar(
                    content: Text("Thông tin nhân viên đã tồn tại")));
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
