import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/Screens/department_screen.dart';
import 'package:my_flutter_app/Screens/employee_screen.dart';
import 'Firebase/firebase_options.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
      debugShowCheckedModeBanner: false,
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
  var selectedIndex = 0;
  Widget builder = EmployeeScreen(
      employeeRef: FirebaseDatabase.instance.ref("Employees"),
      departmentRef: FirebaseDatabase.instance.ref("Departments"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản lý nhân viên',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          padding: EdgeInsets.zero,
          margin: EdgeInsets.zero,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color.fromRGBO(30, 144, 255, 1),
                  Color.fromRGBO(148, 0, 211, 1),
                ]),
          ),
        ),
      ),
      drawer: Drawer(
        surfaceTintColor: Colors.amber,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    builder = EmployeeScreen(
                        employeeRef: FirebaseDatabase.instance.ref("Employees"),
                        departmentRef:
                            FirebaseDatabase.instance.ref("Departments"));
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
                    builder = DepartmentScreen(
                        departmentRef:
                            FirebaseDatabase.instance.ref("Departments"));
                    selectedIndex = 1;
                  });
                }
              },
            ),
            ListTile(
              title: const Text(
                'Video',
                style: TextStyle(
                  color: Colors.lightBlue,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                if (selectedIndex != 1) {
                  setState(() {
                    builder = const VideoApp();
                    selectedIndex = 2;
                  });
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: builder,
    );
  }
}

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  _VideoAppState();

  TextEditingController tec = TextEditingController();
  var videoId = 'X8mhF6HgzVA';

  @override
  Widget build(BuildContext context) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

    return Scaffold(
      body: Column(
        children: [
          const Text('Tên phim'),
          TextField(
            controller: tec,
          ),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                var v = tec.text.split('v=');
                print(v);
                controller.videoUrl.then((value) => {print(value)});
                if (v.length > 1) {
                  videoId = v[1];
                }
              });
            },
          ),
          Center(
              child: YoutubePlayer(
            controller: controller,
            aspectRatio: 16 / 9,
          )),
        ],
      ),
    );
  }
}
