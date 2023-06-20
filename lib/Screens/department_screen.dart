import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Widgets/Department/InputArea/layout_builder.dart';
import 'package:my_flutter_app/Widgets/Department/table_data_source.dart';
import 'package:my_flutter_app/Widgets/Department/table.dart';
import 'package:my_flutter_app/Widgets/table_header.dart';

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key, required this.departmentRef});

  final DatabaseReference departmentRef;

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  DepartmentData? dData;

  int position = -1;

  var idControl = TextEditingController();
  var nameControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: widget.departmentRef.onValue,
          builder: (context, snapshot) {
            List<Department> departmentList = <Department>[];
            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data!).snapshot.value != null) {
              final eList = (snapshot.data!).snapshot.children;
              for (var e in eList) {
                departmentList.add(Department(
                  int.parse(e.key.toString()),
                  e.children.elementAt(0).value.toString(),
                ));
              }
              departmentList.sort(
                (a, b) => a.departmentID.compareTo(b.departmentID),
              );
            }

            dData = DepartmentData(
              departmentList: departmentList,
              getPosition: getPosition,
              setPosition: setPosition,
              getIdControl: getIdControl,
              getNameControl: getNameControl,
            );

            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const DataTableHeader(
                      text: "Phòng ban",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DepartmentTable(
                        getData: getData,
                      ),
                    ),
                  ],
                ),
                InputArea(
                  getPosition: getPosition,
                  setPosition: setPosition,
                  getIdControl: getIdControl,
                  getNameControl: getNameControl,
                  getRef: getRef,
                  getData: getData,
                ),
              ],
            );
          }),
    );
  }

  TextEditingController getIdControl() {
    return idControl;
  }

  int getPosition() {
    return position;
  }

  void setPosition(int p) {
    position = p;
  }

  TextEditingController getNameControl() {
    return nameControl;
  }

  DatabaseReference getRef() {
    return widget.departmentRef;
  }

  DepartmentData getData() {
    return dData!;
  }
}
