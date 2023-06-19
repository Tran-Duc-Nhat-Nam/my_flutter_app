import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/Models/department.dart';
import 'package:my_flutter_app/Models/employee.dart';
import 'package:my_flutter_app/Widgets/table_header.dart';
import 'package:my_flutter_app/Widgets/table_text.dart';
import 'firebase_options.dart';

DatabaseReference? employeeRef;
DatabaseReference? departmentRef;
EmployeeData? eData;
DepartmentData? dData;

int position = -1;
int dPosition = -1;

var idControl = TextEditingController();
var nameControl = TextEditingController();
var addressControl = TextEditingController();
var phoneNumberControl = TextEditingController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  employeeRef = FirebaseDatabase.instance.ref("Employees");
  departmentRef = FirebaseDatabase.instance.ref("Departments");

  runApp(const MyApp());
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          labelLarge: TextStyle(
            color: Colors.cyan,
            fontSize: 20,
          ),
          labelMedium: TextStyle(
            color: Colors.cyan,
            fontSize: 16,
          ),
          labelSmall: TextStyle(
            color: Colors.cyan,
            fontSize: 12,
          ),
          displayLarge: TextStyle(
            color: Colors.cyan,
            fontSize: 12,
          ),
          displayMedium: TextStyle(
            color: Colors.cyan,
            fontSize: 12,
          ),
          displaySmall: TextStyle(
            color: Colors.cyan,
            fontSize: 12,
          ),
        ),
        brightness: Brightness.light,
        colorScheme: const ColorScheme(
          primary: Colors.white,
          primaryContainer: Colors.amber,
          secondary: Colors.green,
          secondaryContainer: Color(0xFFFAFBFB),
          background: Colors.lightBlue,
          surface: Colors.white,
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.deepOrange,
          onPrimary: Colors.orange,
          onSecondary: Colors.yellow,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamBuilder<DatabaseEvent> builder = employeeGUI();
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý nhân viên'),
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                ),
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text(
                  'Nhân viên',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (selectedIndex != 0) {
                    setState(() {
                      builder = employeeGUI();
                      selectedIndex = 0;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text(
                  'Phòng ban',
                  style: TextStyle(
                    color: Colors.lightBlue,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (selectedIndex != 1) {
                    setState(() {
                      builder = departmentGUI();
                      selectedIndex = 1;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: builder);
  }

  StreamBuilder<DatabaseEvent> employeeGUI() {
    return StreamBuilder(
        stream: departmentRef!.onValue,
        builder: (context, snapshot) {
          return StreamBuilder(
              stream: employeeRef!.onValue,
              builder: (context2, snapshot2) {
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

                List<Employee> employeeList = <Employee>[];
                if (snapshot2.hasData &&
                    snapshot2.data != null &&
                    (snapshot2.data!).snapshot.value != null) {
                  final eList = (snapshot2.data!).snapshot.children;
                  for (var e in eList) {
                    employeeList.add(Employee(
                        int.parse(e.key.toString()),
                        e.children.elementAt(0).value.toString(),
                        e.children.elementAt(1).value.toString(),
                        e.children.elementAt(2).value.toString()));
                  }
                  employeeList.sort(
                    (a, b) => a.employeeID.compareTo(b.employeeID),
                  );
                }

                eData = EmployeeData(employeeList: employeeList);
                dData = DepartmentData(departmentList: departmentList);

                return LayoutBuilder(
                  builder: (BuildContext buildContext,
                      BoxConstraints boxConstraints) {
                    if (boxConstraints.maxWidth > 600) {
                      return EmployeeGUI(
                          employeeList: employeeList,
                          departmentList: departmentList);
                    } else {
                      return SafeArea(
                        child: SafeEmployeeGUI(
                            employeeList: employeeList,
                            departmentList: departmentList),
                      );
                    }
                  },
                );
              });
        });
  }

  StreamBuilder<DatabaseEvent> departmentGUI() {
    return StreamBuilder(
        stream: departmentRef!.onValue,
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

          dData = DepartmentData(departmentList: departmentList);

          return LayoutBuilder(
            builder:
                (BuildContext buildContext, BoxConstraints boxConstraints) {
              if (boxConstraints.maxWidth > 600) {
                return DepartmentGUI(departmentList: departmentList);
              } else {
                return const SafeArea(child: Placeholder());
              }
            },
          );
        });
  }
}

class EmployeeGUI extends StatelessWidget {
  const EmployeeGUI({
    super.key,
    required this.employeeList,
    required this.departmentList,
  });

  final List<Employee> employeeList;
  final List<Department> departmentList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataTableHeader(
                    text: "Nhân viên",
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: EmployeeTable(),
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
                  DataTableHeader(
                    text: "Phòng ban",
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DepartmentTable(),
                  ),
                ],
              ),
            ),
          ],
        ),
        InputArea(departmentList: departmentList),
      ],
    );
  }
}

class DepartmentGUI extends StatelessWidget {
  const DepartmentGUI({
    super.key,
    required this.departmentList,
  });

  final List<Department> departmentList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTableHeader(
              text: "Phòng ban",
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DepartmentTable(),
            ),
          ],
        ),
        InputArea(departmentList: departmentList),
      ],
    );
  }
}

class InputArea extends StatefulWidget {
  const InputArea({
    super.key,
    required this.departmentList,
  });

  final List<Department> departmentList;

  @override
  State<InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  bool isReadOnly = true;

  refresh() {
    setState(() {
      isReadOnly = !isReadOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
        if (boxConstraints.maxWidth > 600) {
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
                      controller: idControl,
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
                      controller: nameControl,
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
                      controller: addressControl,
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
                      controller: phoneNumberControl,
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
                        onChanged: (value) {},
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
                        child: AddButton(notifyParent: refresh),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DeleteButton(),
                      ),
                    ],
                  )),
            ],
          );
        } else {
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
                      controller: idControl,
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
                      controller: nameControl,
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
                      controller: addressControl,
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
                      controller: phoneNumberControl,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AddButton(notifyParent: refresh),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: DeleteButton(),
              ),
            ],
          );
        }
      },
    );
  }
}

class AddButton extends StatefulWidget {
  const AddButton({
    super.key,
    required this.notifyParent,
  });

  final Function() notifyParent;

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
              idControl.clear();
              nameControl.clear();
              addressControl.clear();
              phoneNumberControl.clear();
              text = "Lưu";
              position = -1;
              eData!.update();
              widget.notifyParent();
            });
          } else {
            if (nameControl.text.isNotEmpty &&
                addressControl.text.isNotEmpty &&
                phoneNumberControl.text.isNotEmpty) {
              DatabaseReference newEmpolyeeRef =
                  employeeRef!.child(idControl.text);

              var event = await newEmpolyeeRef.once();
              var snapshot = event.snapshot;

              if (snapshot.value == null) {
                newEmpolyeeRef.set({
                  "name": nameControl.text,
                  "address": addressControl.text,
                  "phoneNumber": phoneNumberControl.text,
                });
                idControl.clear();
                nameControl.clear();
                addressControl.clear();
                phoneNumberControl.clear();
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

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    return ElevatedButton(
        onPressed: () {
          if (idControl.text.isNotEmpty) {
            showAlertDialog(context);
          } else {
            messenger.showSnackBar(
                const SnackBar(content: Text("Vui lòng điền đủ thông tin")));
          }
        },
        child: Text(
          "Delete",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Không"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        DatabaseReference newEmpolyeeRef = employeeRef!.child(idControl.text);
        newEmpolyeeRef.remove();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Xác nhận xóa"),
      content: const Text("Bạn có muốn xóa thông tin nhân viên này không?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class SafeEmployeeGUI extends StatelessWidget {
  const SafeEmployeeGUI({
    super.key,
    required this.employeeList,
    required this.departmentList,
  });

  final List<Employee> employeeList;
  final List<Department> departmentList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DataTableHeader(
          text: "Nhân viên",
        ),
        const EmployeeTable(),
        const DataTableHeader(
          text: "Nhân viên",
        ),
        const EmployeeTable(),
        InputArea(
          departmentList: departmentList,
        ),
      ],
    );
  }
}

class EmployeeData extends DataTableSource {
  EmployeeData({
    required this.employeeList,
  });

  final List<Employee> employeeList;

  @override
  DataRow? getRow(int index) {
    final p = employeeList[index];

    return DataRow.byIndex(
      onSelectChanged: (value) {
        showInfo(p);
        position = index;
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
        if (position == index) {
          return Colors.grey[200];
        }
        return Colors.white; // Use the default value.
      }),
    );
  }

  void showInfo(Employee p) {
    idControl.text = p.employeeID.toString();
    nameControl.text = p.name;
    addressControl.text = p.address;
    phoneNumberControl.text = p.phoneNumber;
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

class DepartmentData extends DataTableSource {
  DepartmentData({
    required this.departmentList,
  });

  final List<Department> departmentList;

  @override
  DataRow? getRow(int index) {
    final p = departmentList[index];

    return DataRow.byIndex(
      onSelectChanged: (value) {
        dPosition = index;
        notifyListeners();
      },
      index: index,
      cells: [
        DataCell(TableText(text: p.departmentID.toString())),
        DataCell(TableText(text: p.name.trim())),
      ],
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        if (position == index) {
          return Colors.grey[200];
        }
        return Colors.white; // Use the default value.
      }),
    );
  }

  void update() {
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => departmentList.length;

  @override
  int get selectedRowCount => 0;
}

class EmployeeTable extends StatelessWidget {
  const EmployeeTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: null,
      showCheckboxColumn: false,
      showFirstLastButtons: true,
      rowsPerPage: 5,
      source: eData!,
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

class DepartmentTable extends StatelessWidget {
  const DepartmentTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      header: null,
      showCheckboxColumn: false,
      showFirstLastButtons: true,
      rowsPerPage: 5,
      source: dData!,
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
