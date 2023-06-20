import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Widgets/Employee/InputArea/horizontal_layout.dart';
import 'package:my_flutter_app/Widgets/Employee/InputArea/vertical_layout.dart';

class InputArea extends StatelessWidget {
  const InputArea({
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
        if (boxConstraints.maxWidth > 600) {
          return HorizontalInputArea(
              departmentList: departmentList,
              getPosition: getPosition,
              setPosition: setPosition,
              getIdControl: getIdControl,
              getNameControl: getNameControl,
              getRef: getRef,
              getData: getData,
              getAdressControl: getAdressControl,
              getPhoneNumberControl: getPhoneNumberControl);
        } else {
          return VerticalInputArea(
              departmentList: departmentList,
              getPosition: getPosition,
              setPosition: setPosition,
              getIdControl: getIdControl,
              getNameControl: getNameControl,
              getAdressControl: getAdressControl,
              getPhoneNumberControl: getPhoneNumberControl,
              getRef: getRef,
              getData: getData);
        }
      },
    );
  }
}
