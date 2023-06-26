import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Widgets/Employee/add_button.dart';
import 'package:my_flutter_app/Widgets/Employee/delete_button.dart';

class VerticalInputArea extends StatefulWidget {
  const VerticalInputArea({
    super.key,
    required this.departmentList,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
    required this.getRef,
    required this.getData,
  });

  final List<Department> departmentList;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getAdressControl;
  final Function() getPhoneNumberControl;
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

  int selectedIndex = -1;

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
        Row(
          children: [
            const Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: SelectableText("Địa chỉ"),
                )),
            Expanded(
              flex: 2,
              child: TextField(
                controller: widget.getAdressControl(),
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
                  child: SelectableText("Số điện thoại"),
                )),
            Expanded(
              flex: 2,
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: widget.getPhoneNumberControl(),
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
            getAdressControl: widget.getAdressControl,
            getPhoneNumberControl: widget.getPhoneNumberControl,
            getDepartmentID: getDepartmentID,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DeleteButton(
              getIdControl: widget.getIdControl, getRef: widget.getRef),
        ),
      ],
    );
  }

  int getDepartmentID() {
    return widget.departmentList[selectedIndex].departmentID;
  }
}
