import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:x_app_a/core/local_storage/prfs.dart';
import 'package:x_app_a/screens/auth/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dynamic token = await AppLocalStorage.getdata('token');
  await Firebase.initializeApp();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Firebase',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: token != null
          ? const MyHomePage(title: 'Firebase toturial')
          : const SiginIn(),
    );
  }
}
