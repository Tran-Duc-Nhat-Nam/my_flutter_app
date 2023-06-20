import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Widgets/table_text.dart';

class DepartmentData extends DataTableSource {
  DepartmentData({
    required this.departmentList,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
  });

  final List<Department> departmentList;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;

  @override
  DataRow? getRow(int index) {
    final d = departmentList[index];

    return DataRow.byIndex(
      onSelectChanged: (value) {
        setPosition(index);
        showInfo(d);
        notifyListeners();
      },
      index: index,
      cells: [
        DataCell(TableText(text: d.departmentID.toString())),
        DataCell(TableText(text: d.name.trim())),
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

  void update() {
    notifyListeners();
  }

  void showInfo(Department d) {
    getIdControl().text = d.departmentID.toString();
    getNameControl().text = d.name;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => departmentList.length;

  @override
  int get selectedRowCount => 0;
}
