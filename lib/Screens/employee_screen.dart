import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Models/employee.dart';
import 'package:my_flutter_app/Widgets/Department/table.dart';
import 'package:my_flutter_app/Widgets/Department/table_data_source.dart';
import 'package:my_flutter_app/Widgets/Employee/InputArea/layout_builder.dart';
import 'package:my_flutter_app/Widgets/Employee/table.dart';
import 'package:my_flutter_app/Widgets/Employee/table_data_source.dart';
import 'package:my_flutter_app/Widgets/table_header.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({
    super.key,
    required this.employeeRef,
    required this.departmentRef,
  });

  final DatabaseReference employeeRef;
  final DatabaseReference departmentRef;

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  EmployeeData? eData;
  DepartmentData? dData;

  int position = -1;
  int dPosition = -1;

  var idControl = TextEditingController();
  var nameControl = TextEditingController();
  var addressControl = TextEditingController();
  var phoneNumberControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: widget.departmentRef.onValue,
            builder: (context, snapshot) {
              return StreamBuilder(
                  stream: widget.employeeRef.onValue,
                  builder: (context2, snapshot2) {
                    List<Employee> employeeList = <Employee>[];
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

                    if (snapshot2.hasData &&
                        snapshot2.data != null &&
                        (snapshot2.data!).snapshot.value != null) {
                      final eList = (snapshot2.data!).snapshot.children;
                      for (var e in eList) {
                        employeeList.add(Employee(
                          int.parse(e.key.toString()),
                          e.child("name").value.toString(),
                          e.child("address").value.toString(),
                          e.child("phoneNumber").value.toString(),
                          int.parse(e.child("departmentID").value.toString()),
                        ));
                      }
                      employeeList.sort(
                        (a, b) => a.employeeID.compareTo(b.employeeID),
                      );
                    }

                    eData = EmployeeData(
                        employeeList: employeeList,
                        getPosition: getPosition,
                        setPosition: setPosition,
                        getIdControl: getIdControl,
                        getNameControl: getNameControl,
                        getAdressControl: getAdressControl,
                        getPhoneNumberControl: getPhoneNumberControl);

                    return LayoutBuilder(
                      builder: (BuildContext buildContext,
                          BoxConstraints boxConstraints) {
                        if (boxConstraints.maxWidth > 600) {
                          return EmployeeGUI(
                              employeeList: employeeList,
                              departmentList: departmentList,
                              getEmployeeData: getEmployeeData,
                              getDepartmentData: getDepartmentData,
                              getPosition: getPosition,
                              setPosition: setPosition,
                              getIdControl: getIdControl,
                              getNameControl: getNameControl,
                              getRef: getRef,
                              getAdressControl: getAdressControl,
                              getPhoneNumberControl: getPhoneNumberControl);
                        } else {
                          return SafeArea(
                            child: SafeEmployeeGUI(
                                employeeList: employeeList,
                                departmentList: departmentList,
                                getEmployeeData: getEmployeeData,
                                getDepartmentData: getDepartmentData,
                                getPosition: getPosition,
                                setPosition: setPosition,
                                getIdControl: getIdControl,
                                getNameControl: getNameControl,
                                getAdressControl: getAdressControl,
                                getPhoneNumberControl: getPhoneNumberControl,
                                getRef: getRef),
                          );
                        }
                      },
                    );
                  });
            }));
  }

  int getPosition() {
    return position;
  }

  void setPosition(int p) {
    position = p;
  }

  TextEditingController getIdControl() {
    return idControl;
  }

  TextEditingController getNameControl() {
    return nameControl;
  }

  TextEditingController getAdressControl() {
    return addressControl;
  }

  TextEditingController getPhoneNumberControl() {
    return phoneNumberControl;
  }

  DatabaseReference getRef() {
    return widget.employeeRef;
  }

  EmployeeData getEmployeeData() {
    return eData!;
  }

  DepartmentData getDepartmentData() {
    return dData!;
  }
}

class EmployeeGUI extends StatelessWidget {
  const EmployeeGUI({
    super.key,
    required this.employeeList,
    required this.departmentList,
    required this.getEmployeeData,
    required this.getDepartmentData,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getRef,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
  });

  final List<Employee> employeeList;
  final List<Department> departmentList;
  final Function() getEmployeeData;
  final Function() getDepartmentData;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getAdressControl;
  final Function() getPhoneNumberControl;
  final Function() getRef;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DataTableHeader(
                    text: "Nhân viên",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: EmployeeTable(getData: getEmployeeData),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DataTableHeader(
                    text: "Phòng ban",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DepartmentTable(getData: getDepartmentData),
                  ),
                ],
              ),
            ),
          ],
        ),
        InputArea(
            departmentList: departmentList,
            getPosition: getPosition,
            setPosition: setPosition,
            getIdControl: getIdControl,
            getNameControl: getNameControl,
            getRef: getRef,
            getData: getEmployeeData,
            getAdressControl: getAdressControl,
            getPhoneNumberControl: getPhoneNumberControl),
      ],
    );
  }
}

class SafeEmployeeGUI extends StatelessWidget {
  const SafeEmployeeGUI({
    super.key,
    required this.employeeList,
    required this.departmentList,
    required this.getPosition,
    required this.setPosition,
    required this.getIdControl,
    required this.getNameControl,
    required this.getAdressControl,
    required this.getPhoneNumberControl,
    required this.getRef,
    required this.getEmployeeData,
    required this.getDepartmentData,
  });

  final List<Employee> employeeList;
  final List<Department> departmentList;
  final Function() getEmployeeData;
  final Function() getDepartmentData;
  final Function() getPosition;
  final Function(int) setPosition;
  final Function() getIdControl;
  final Function() getNameControl;
  final Function() getAdressControl;
  final Function() getPhoneNumberControl;
  final Function() getRef;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DataTableHeader(
          text: "Nhân viên",
        ),
        EmployeeTable(getData: getDepartmentData),
        const DataTableHeader(
          text: "Nhân viên",
        ),
        DepartmentTable(getData: getDepartmentData),
        InputArea(
            departmentList: departmentList,
            getPosition: getPosition,
            setPosition: setPosition,
            getIdControl: getIdControl,
            getNameControl: getNameControl,
            getRef: getRef,
            getData: getEmployeeData,
            getAdressControl: getAdressControl,
            getPhoneNumberControl: getPhoneNumberControl),
      ],
    );
  }
}
