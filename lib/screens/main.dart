
import 'package:flutter/material.dart';
import 'package:ssn_attendance/screens/login.dart';
import 'package:ssn_attendance/screens/homepage.dart';
import 'package:ssn_attendance/screens/faculty.dart';
import 'package:ssn_attendance/screens/register_student.dart';
import 'package:ssn_attendance/screens/register_faculty.dart';
import 'package:ssn_attendance/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: Wrapper(),
      initialRoute: 'login',
      routes: {
        'login':(context) => MyLogin(),
        'homepage':(context) => MyHomepage(email: ""),
        'faculty':(context) => MyFaculty(email: ""),
        'register_student':(context) => RegStu(),
        'register_faculty':(context) => RegFac(),

      }
    ),
  );
}

