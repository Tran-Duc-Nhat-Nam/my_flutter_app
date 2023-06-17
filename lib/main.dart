import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/Models/Employee.dart';

import 'firebase_options.dart';

List<Employee> employeeList = <Employee>[];
DatabaseReference? ref;
EmployeeData? eData;

int position = -1;

var idControl = TextEditingController();
var nameControl = TextEditingController();
var addressControl = TextEditingController();
var phoneNumberControl = TextEditingController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  ref = FirebaseDatabase.instance.ref("Employees");

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: StreamBuilder(stream: ref!.onValue, builder: buildLayout));
  }

  Widget buildLayout(context, snapshot) {
    List<Employee> employeeList = <Employee>[];

    if (snapshot.hasData &&
        snapshot.data != null &&
        (snapshot.data!).snapshot.value != null) {
      final eList = (snapshot.data!).snapshot.children;
      eList.forEach((e) {
        if (e != null) {
          employeeList.add(Employee(
            int.parse(e.key.toString()),
            e.value['name'].toString(),
            e.value['address'].toString(),
            e.value['phoneNumber'].toString(),
          ));
        }
      });
      employeeList.sort(
        (a, b) => a.employeeID.compareTo(b.employeeID),
      );
    }

    eData = EmployeeData(employeeList: employeeList);

    return LayoutBuilder(
      builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
        if (boxConstraints.maxWidth > 600) {
          return TableArea(employeeList: employeeList);
        } else {
          return SafeArea(
            child: SafeTableArea(employeeList: employeeList),
          );
        }
      },
    );
  }
}

class TableArea extends StatelessWidget {
  const TableArea({
    super.key,
    required this.employeeList,
  });

  final List<Employee> employeeList;

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
                  const DataTableHeader(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: EmployeeTable(employeeList: employeeList),
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
                  const DataTableHeader(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: EmployeeTable(employeeList: employeeList),
                  ),
                ],
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
                  child: SelectableText("Mã nhân viên"),
                )),
            Expanded(
              flex: 6,
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
              flex: 6,
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
              flex: 6,
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
              flex: 6,
              child: TextField(
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                controller: phoneNumberControl,
              ),
            ),
          ],
        ),
        Container(
            margin: const EdgeInsets.all(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: AddButton(),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DeleteButton(),
                ),
              ],
            ))
      ],
    );
  }
}

class AddButton extends StatefulWidget {
  const AddButton({
    super.key,
  });

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
            });
          } else {
            if (nameControl.text.isNotEmpty &&
                addressControl.text.isNotEmpty &&
                phoneNumberControl.text.isNotEmpty) {
              DatabaseReference newEmpolyeeRef = ref!.child(idControl.text);

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
        DatabaseReference newEmpolyeeRef = ref!.child(idControl.text);
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

class SafeTableArea extends StatelessWidget {
  const SafeTableArea({
    super.key,
    required this.employeeList,
  });

  final List<Employee> employeeList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const DataTableHeader(),
        EmployeeTable(employeeList: employeeList),
        const DataTableHeader(),
        // TableArea(employeeList: employeeList),
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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: AddButton(),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: DeleteButton(),
        ),
      ],
    );
  }
}

class DataTableHeader extends StatelessWidget {
  const DataTableHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: 12,
            right: 12,
          ),
          child: Text(
            textAlign: TextAlign.center,
            "Bảng nhân viên",
            textScaleFactor: 1.25,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue[300],
            ),
          ),
        ));
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

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({
    super.key,
    required this.employeeList,
  });

  final List<Employee> employeeList;

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
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

class TableText extends StatelessWidget {
  final String text;

  const TableText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: 64,
        child: Text(
          overflow: TextOverflow.ellipsis,
          text.toString().trim(),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
