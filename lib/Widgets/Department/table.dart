import 'package:flutter/material.dart';

class DepartmentTable extends StatelessWidget {
  const DepartmentTable({
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
      ],
    );
  }
}
