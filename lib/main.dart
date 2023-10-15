import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/layout/home_layout.dart';
import 'package:to_do_app/providers/my_provider.dart';
import 'package:to_do_app/providers/tasks_provider.dart';
import 'package:to_do_app/screens/login/login.dart';
import 'package:to_do_app/shared/styles/theming.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.enableNetwork();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => MyProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => TasksProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MyProvider>(context);
    return MaterialApp(
      theme: MyThemeData.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: provider.fireBaseUser != null
          ? HomeLayout.routeName
          : LoginScreen.routeName,
      routes: {
        HomeLayout.routeName: (context) => HomeLayout(),
        LoginScreen.routeName: (context) => LoginScreen()
      },
    );
  }
}
