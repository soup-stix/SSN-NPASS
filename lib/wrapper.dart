import 'package:flutter/material.dart';
import 'package:ssn_attendance/screens/homepage.dart';
import 'package:ssn_attendance/screens/login.dart';
import 'package:ssn_attendance/services/authenticate.dart';

class Wrapper extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //returns home or application widget
    return MyLogin();

  }
}