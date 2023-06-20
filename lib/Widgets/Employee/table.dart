import 'package:flutter/material.dart';

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({
    super.key,
    required this.getData,
  });

  final Function() getData;

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: null,
      showCheckboxColumn: false,
      showFirstLastButtons: true,
      rowsPerPage: 5,
      source: getData(),
      columns: const [
        DataColumn(
            label: Text('ID',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ))),
        DataColumn(
            label: Text('Tên',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ))),
        DataColumn(
            label: Text('Địa chỉ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ))),
        DataColumn(
            label: Text('SĐT',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                ))),
      ],
    );
  }
}
