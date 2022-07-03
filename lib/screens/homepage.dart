import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:ssn_attendance/screens/login.dart';
import 'dart:convert';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:mac_address/mac_address.dart';

class MyHomepage extends StatefulWidget{
  final String email;
  const MyHomepage({Key?key, required this.email}): super(key: key);

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  //variable declaration
  String otp = "";
  String session_name = "";
  String sub = "";
  String mac1 = "";
  dynamic dropdownValue = "";
  String f_name = "";
  String l_name = "";
  String reg_no = "";
  int semester = 0;
  List sub_list = [];


  dynamic id_checker() async {
    WifiInfoWrapper wifiObject = await WifiInfoPlugin.wifiDetails;
    mac1 = wifiObject.routerIp.toString();
    var mac2 = wifiObject.ipAddress.toString();
    var mac3 = wifiObject.networkId.toString();
    var mac4 = wifiObject.bssId.toString();
    var mac5 = wifiObject.macAddress.toString();
    var mac6 = wifiObject.signalStrength.toString();
    var mac7 = wifiObject.connectionType.toString();
    var mac8 = wifiObject.isHiddenSSid.toString();
    print(mac1 + "\n" + mac2 + "\n" + mac3 + "\n" + mac4 + "\n" + mac5 + "\n" +
        mac6 + "\n" + mac7 + "\n" + mac8);
  }

  void get_subjects() async{
    final url = 'http://10.0.2.2:5000/student_subjects';
    final dynamic send = await http.post(Uri.parse(url), body: json.encode({
      'semester': semester,
    }));
    final decoded = json.decode(send.body) as Map<String, dynamic>;
    print(decoded['subjects']);
    dropdownValue = decoded['subjects'][0];
    sub_list = decoded['subjects'];
  }

  void get_details() async{
    final url = 'http://10.0.2.2:5000/student_details';
    final dynamic send = await http.post(Uri.parse(url), body: json.encode({
      'email': widget.email,
    }));
    final decoded = json.decode(send.body) as Map<String, dynamic>;
    print(decoded);
    f_name = decoded['f_name'];
    l_name = decoded['l_name'];
    reg_no = decoded['reg_no'];
    semester = decoded['semester'];
  }

  void check_dialog(dynamic ans) async {
    showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text("Enter Details",style: TextStyle(fontWeight: FontWeight.bold),),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              elevation: 5,
              actionsPadding: EdgeInsets.all(10.0),
              actions: [
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'session name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      session_name = text;
                      print(session_name);
                    });
                  },
                  onSubmitted: (String ent_rollno) {
                    print("submitted\n");
                    setState(() {
                      session_name = ent_rollno;
                    });
                    //Navigator.of(context).pop();
                  },
                ),
                SizedBox(height: 10,),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'otp',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.circular(10),
                    ),

                  ),
                  onChanged: (text) {
                    otp = text;
                    print(otp);
                  },
                  onSubmitted: (String ent_otp) {
                    print("submitted\n");
                    otp = ent_otp;
                    //Navigator.of(context).pop();
                  },
                ),

                ElevatedButton(
                    onPressed: () async {
                      await id_checker();
                      check_state();
                      Navigator.of(context).pop();
                    }, child: Text("submit")),
              ],
            )
    );
  }


  void check_state() async {
    final url = 'http://10.0.2.2:5000/recieve';
    final dynamic send = await http.post(Uri.parse(url), body: json.encode({
      'email': widget.email,
      'session_name': session_name,
      'ip': mac1,
      'otp': otp
    }));
    final decoded = json.decode(send.body) as Map<String, dynamic>;
    print(widget.email);
    print(decoded);
    if (decoded['state'] == 'done') {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text(
                'Attendance Marked!!', style: TextStyle(color: Colors.green,),),
              //content: Text('Plese sign in using ur newly registered email and password!'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
      );
    }
    else if(decoded['state'] == 'marked') {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text('Already Marked!!', style: TextStyle(color: Colors.green,),),
              content: Text('Thank you for marking attendance.'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
      );
    }
    else if(decoded['state'] == 'na') {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text('Check Subject!!', style: TextStyle(color: Colors.red,),),
              content: Text('Pls try again...'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
              ),
            ),
      );
    }
    else {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(
              title: Text('Failed!!', style: TextStyle(color: Colors.red,),),
              content: Text('Please Try again'),
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
    get_details();
    get_subjects();
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
        title: Image.network(
          "https://www.ssn.edu.in/wp-content/uploads/2020/06/SSN-Institutions-1.png",
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
                padding: const EdgeInsets.only(
                  top: 30, bottom: 30, left: 60, right: 60,),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/logo.png'),
                          fit: BoxFit.fill)),
                ),
              ),
              //DrawerHeader(child: Text(""),/*child: Center(child: Text("LOGO",style: TextStyle(fontSize: 30,),)),*/),
              ListTile(
                  leading: Icon(Icons.lock_clock_rounded, color: Colors.black,),
                  title: Text("Logout", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, 'login');
                  }
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.black,),
                title: Text("Rate Us",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onTap: () {},
              ),
              SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.55,),
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
                        SizedBox(height: 30,),
                        Text("Welcome, "+f_name,
                          style: TextStyle(fontSize: 30,color: Colors.blue, fontWeight: FontWeight.bold,),

                        ),
                        SizedBox(height: 20,),

                        Text("Select Period:",style: TextStyle(fontSize: 20,color: Colors.blue,),),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.shade100,border: Border.all(color: Colors.blue,width: 2),),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10,),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10),
                                value: dropdownValue,
                                elevation: 16,
                                icon: Icon(Icons.arrow_downward_sharp),
                                style: TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                    session_name = newValue!;
                                    print(dropdownValue);
                                  });
                                },
                                items: sub_list.map((sub_list)/*<String> ['select subject',sub_list[0],sub_list[1],sub_list[2],sub_list[3],sub_list[4],sub_list[5],sub_list[6],sub_list[7]]
                                    .map<DropdownMenuItem<String>>((String value)*/ {
                                  return DropdownMenuItem<String>(
                                    value: sub_list,
                                    child: Text(sub_list, style: TextStyle(fontSize: 20),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("Enter OTP:",style: TextStyle(fontSize: 20,color: Colors.blue,),),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          height: MediaQuery.of(context).size.height*0.1,
                          child: TextField(

                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'otp',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (text) {
                              otp = text;
                              print(otp);
                            },
                            onSubmitted: (String password) { print("submitted\n");
                            setState(() {
                              otp = password;
                            });
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              await id_checker();
                              check_state();
                            },
                            child: Text("Submit")
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}