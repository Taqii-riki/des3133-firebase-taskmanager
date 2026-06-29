import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyTaskManagerApp());
}

class MyTaskManagerApp extends StatelessWidget {
  const MyTaskManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF141822), // Soft Slate Background
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF004D98),   // Barça Blue
          secondary: Color(0xFFA50044), // Barça Red
          surface: Color(0xFF1E2433),   // Card Slate
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E2433),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Color(0xFFEDBB00), fontSize: 20, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Color(0xFFEDBB00)),
        ),
        // Futuristic Asymmetric Input Fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1E2433),
          labelStyle: const TextStyle(color: Color(0xFFEDBB00)), // Gold text
          prefixIconColor: const Color(0xFFEDBB00),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            borderSide: BorderSide(color: Color(0xFF004D98), width: 1.5), // Blue outline
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            borderSide: BorderSide(color: Color(0xFFEDBB00), width: 2), // Gold glow on focus
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            borderSide: BorderSide(color: Color(0xFFA50044), width: 1.5),
          ),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) return const TaskListScreen();
          return const LoginScreen();
        },
      ),
    );
  }
}