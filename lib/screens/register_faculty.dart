
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:mac_address/mac_address.dart';

class RegFac extends StatefulWidget{
  const RegFac({Key?key}): super(key: key);

  @override
  _RegFacState createState() => _RegFacState();
}

class _RegFacState extends State<RegFac> {
  String dev_mac = "";
  String email_id = "";
  String sem = "";
  String f_name = "";
  String l_name = "";
  String reg_no = "";
  String password = "";

  void faculty_register() async{
    final url = 'http://10.0.2.2:5000/faculty_register';
    final dynamic send = await http.post(Uri.parse(url), body: json.encode({
      'email_id': email_id,
      'f_name': f_name,
      'l_name': l_name,
      'reg_no': reg_no,
      'password': password,
    }));
    final decoded = json.decode(send.body) as Map<String, dynamic>;
    print(decoded);
    if (decoded['status'] == 0) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text(
                'Already Registered!!!', style: TextStyle(color: Colors.red,),),
              content: Text('Please try signing in...'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
      );
    }
    if (decoded['status'] == 1) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text(
                'Registered!!!', style: TextStyle(color: Colors.green,),),
              content: Text('Thank you for registering with SSN nPASS...'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Icon(Icons.menu_rounded, color: Colors.black,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        backgroundColor: Colors.blueAccent,
        title: Image.network("https://www.ssn.edu.in/wp-content/uploads/2020/06/SSN-Institutions-1.png",
          fit: BoxFit.contain,
          height: 32,
        ),

        //centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Container(

          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30,left: 60,right: 60,),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/logo.png'), fit: BoxFit.fill)),
                ),
              ),
              //DrawerHeader(child: Text(""),/*child: Center(child: Text("LOGO",style: TextStyle(fontSize: 30,),)),*/),
              ListTile(
                  leading: Icon(Icons.lock_clock_rounded, color: Colors.black,),
                  title: Text("Logout",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, 'login');
                  }
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.black,),
                title: Text("Rate Us",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onTap: () {},
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.55,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    children: [
                      Text("Designed and Developed by:"),
                      Text("𝐀.𝐀𝐧𝐚𝐧𝐝", style: TextStyle(fontSize: 20,),),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
            image:DecorationImage(
              image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwflYli3_AU_tvzbrmDxZPEEGOeazVYerHvg&usqp=CAU",),
              fit: BoxFit.cover,),
          ),
          child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10,),
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.9,
                            width: MediaQuery.of(context).size.width*1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white70,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                                Text("Enter Faculty Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.blueAccent,),),
                                SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'First name',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      f_name = text;
                                      print(f_name);
                                    },
                                    onSubmitted: (String name) { print("submitted\n");
                                    setState(() {
                                      f_name = name;
                                    });
                                    },
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Last name',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      l_name = text;
                                      print(l_name);
                                    },
                                    onSubmitted: (String name) { print("submitted\n");
                                    setState(() {
                                      l_name = name;
                                    });
                                    },
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Email ID(@ssn.edu.in)',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      email_id = text;
                                      print(email_id);
                                    },
                                    onSubmitted: (String emailid) { print("submitted\n");
                                    setState(() {
                                      email_id = emailid;
                                    });
                                    },
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Digital ID(20XXXXXXXX)',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      reg_no = text;
                                      print(reg_no);
                                    },
                                    onSubmitted: (String regno) { print("submitted\n");
                                    setState(() {
                                      reg_no = regno;
                                    });
                                    },
                                  ),
                                ),
                                /*SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Semester',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (number) {
                                      sem = number;
                                      print(sem);
                                    },
                                    onSubmitted: (String semno) { print("submitted\n");
                                    setState(() {
                                      sem = semno;
                                      //print(f_name,"",l_name,reg_no,email_id,sem);
                                    });
                                    },
                                  ),
                                ),*/
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  height: MediaQuery.of(context).size.height*0.1,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: 'Password',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (number) {
                                      password = number;
                                      print(password);
                                    },
                                    onSubmitted: (String pass) { print("submitted\n");
                                    setState(() {
                                      password = pass;
                                      //print(f_name,"",l_name,reg_no,email_id,sem);
                                    });
                                    },
                                  ),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                                Container(
                                    width: MediaQuery.of(context).size.width*0.6,
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                                    child: ElevatedButton(
                                      child: Text("REGISTER"),
                                      onPressed: () async {
                                        faculty_register();
                                        /*print(f_name);
            print(l_name);
            print(email_id);
            print(reg_no);
            print(sem);*/
                                      },
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]
                  )
              )
          )
      ),
    );
  }
}