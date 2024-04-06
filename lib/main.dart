import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskforge/firebase_options.dart';
import 'package:taskforge/view/screens/add_task_page.dart';
import 'package:taskforge/view/screens/home_page.dart';
import 'package:taskforge/view/screens/login_page.dart';
import 'package:taskforge/view/screens/register_page.dart';
import 'package:taskforge/view/screens/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/home': (context) => HomePage(),
        '/addtask': (context) => AddTaskView(),
        '/splash':(context) => SplashView(),
      },
      theme: ThemeData(
        textTheme: TextTheme(
          displayMedium: TextStyle(color: Colors.white, fontSize: 18),
          displaySmall: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        scaffoldBackgroundColor: const Color(0xff0E1D3E),
        appBarTheme: AppBarTheme(
            color: Color(0xff0E1D3E),
            iconTheme: IconThemeData(color: Colors.white)),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
//2.30.00 time line