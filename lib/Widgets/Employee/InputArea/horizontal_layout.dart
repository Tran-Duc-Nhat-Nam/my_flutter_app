import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Widgets/Employee/add_button.dart';
import 'package:my_flutter_app/Widgets/Employee/delete_button.dart';

class HorizontalInputArea extends StatefulWidget {
  const HorizontalInputArea({
    super.key,
    required this.departmentList,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getRef,
    required this.getData,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
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
  State<HorizontalInputArea> createState() => _HorizontalInputAreaState();
}

class _HorizontalInputAreaState extends State<HorizontalInputArea> {
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
              flex: 6,
              child: TextField(
                readOnly: isReadOnly,
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
              flex: 6,
              child: TextField(
                readOnly: isReadOnly,
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
              flex: 6,
              child: TextField(
                readOnly: isReadOnly,
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
              flex: 6,
              child: TextField(
                readOnly: isReadOnly,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: widget.getPhoneNumberControl(),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Department>(
                  dropdownColor: Colors.blue,
                  items: widget.departmentList.map((item) {
                    return DropdownMenuItem<Department>(
                      value: item,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  value: selectedIndex < 0
                      ? null
                      : widget.departmentList[selectedIndex],
                  onChanged: (value) {
                    setState(() {
                      selectedIndex = widget.departmentList.indexOf(value!);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            )),
      ],
    );
  }

  int getDepartmentID() {
    return widget.departmentList[selectedIndex].departmentID;
  }
}
