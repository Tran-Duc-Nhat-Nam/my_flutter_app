import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/employee.dart';
import 'package:my_flutter_app/Widgets/table_text.dart';

class EmployeeData extends DataTableSource {
  EmployeeData({
    required this.employeeList,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
  });

  final List<Employee> employeeList;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getAdressControl;
  final Function() getPhoneNumberControl;

  @override
  DataRow? getRow(int index) {
    final p = employeeList[index];

    return DataRow.byIndex(
      onSelectChanged: (value) {
        showInfo(p);
        setPosition(index);
        notifyListeners();
      },
      index: index,
      cells: [
        DataCell(TableText(text: p.employeeID.toString())),
        DataCell(TableText(text: p.name.trim())),
        DataCell(TableText(text: p.address.trim())),
        DataCell(TableText(text: p.phoneNumber.trim())),
      ],
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (getPosition() == index) {
          return Colors.grey[200];
        }
        return Colors.white; // Use the default value.
      }),
    );
  }

  void showInfo(Employee p) {
    getIdControl().text = p.employeeID.toString();
    getNameControl().text = p.name;
    getAdressControl().text = p.address;
    getPhoneNumberControl().text = p.phoneNumber;
  }

  void update() {
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employeeList.length;

  @override
  int get selectedRowCount => 0;
}
