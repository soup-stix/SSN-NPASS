import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ssn_attendance/screens/homepage.dart';
import 'package:ssn_attendance/screens/faculty.dart';
import 'package:ssn_attendance/screens/register_student.dart';
import 'package:ssn_attendance/services/auth.dart';

class MyLogin extends StatefulWidget{
  const MyLogin({Key?key}): super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  String dropdownValue = 'Student';
  String final_password = "";
  String final_emailid = "";
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("𝙎𝙎𝙉 пPАSS", style: TextStyle(fontSize: 30,),),//Image.network("https://www.ssn.edu.in/wp-content/uploads/2020/06/SSN-Institutions-1.png",
            //fit: BoxFit.contain,
            //height: 32,
          //),
          centerTitle: true,
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
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: MediaQuery.of(context).size.height*0.64,
                      width: MediaQuery.of(context).size.width*0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white70,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                          Container(
                            height: MediaQuery.of(context).size.height*0.1,
                            child: Image.network("https://www.ssn.edu.in/wp-content/uploads/2020/06/SSN-Institutions-1.png",),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.05,),
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
                                      print(dropdownValue);
                                    });
                                  },
                                  items: <String>['Student', 'Faculty',]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: TextStyle(fontSize: 20),),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.03,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.1,
                            child: TextField(
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: 'E-mail ID',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                              onChanged: (text) {
                                final_emailid = text;
                                print(final_emailid);
                              },
                              onSubmitted: (String emailid) { print("submitted\n");
                              setState(() {
                                final_emailid = emailid;
                              });
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.0006,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.1,
                            child: TextField(
                              obscureText: true,
                              obscuringCharacter: "*",
                              decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (text) {
                                final_password = text;
                                print(final_password);
                              },
                              onSubmitted: (String password) { print("submitted\n");
                              setState(() {
                                final_password = password;
                              });
                              },
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height*0.0006,),
                          Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: MediaQuery.of(context).size.height*0.05,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
                            child: ElevatedButton(
                              child: Text("LOGIN"),
                              onPressed: () async {
                                //dynamic sign_result = await _auth.signinemail(final_emailid,final_password);
                                dynamic sign_result = await _auth.signindatabase(final_emailid,final_password,dropdownValue);
                                if (sign_result == 1){
                                  print("User does not exist");
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('User does not exist!!', style: TextStyle(color: Colors.red,),),
                                        content: Text('Please check email-Id and Password and try again later...\nor register....'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        elevation: 5,
                                      )
                                  );
                                }
                                else if (sign_result == 2){
                                  print("Wrong Password!!");
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Wrong Password!!', style: TextStyle(color: Colors.red,),),
                                        content: Text('Please check email-Id and Password and try again later...'),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        elevation: 5,
                                      )
                                  );
                                }
                                else if (sign_result == 3){
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                            title: Text("Inavlid email!!",
                                              style: TextStyle(
                                                color: Colors.red,),),
                                            content: Text('Invalid email!!\nTry ssn mail..'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            elevation: 5,
                                          )
                                  );
                                }
                                else{
                                  print("Login sucessful!!");
                                  if (dropdownValue == 'Student') {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MyHomepage(email: final_emailid),
                                        ));
                                    //Navigator.pushNamed(context, 'homepage');
                                  }
                                  else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                        builder: (context) => MyFaculty(email: final_emailid),
                                ));
                                  }
                                }
                                //_auth.signindatabase(final_emailid,final_password);
                                /*if (final_emailid == "anand" && final_password == "nancy") {
                                  print(final_emailid);
                                  print(final_password);
                                  Navigator.pushNamed(context,'homepage');
                                }
                                else{
                                  print("Try again!!");
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text('Invalid Credentials!!', style: TextStyle(color: Colors.red,),),
                                        content: Text('Please check email-Id and Password and try again later...'),
                                      )
                                  );

                                }*/
                              },

                            ),
                          ),
                          TextButton(
                            child: Text("Register..."),
                              onPressed: () {
                                  if (dropdownValue == 'Student') {
                                    Navigator.pushNamed(context, 'register_student');
                                  }
                                  else{
                                    Navigator.pushNamed(context, 'register_faculty');
                                  }
                              },
                            /*{
                              dynamic register_result = await _auth.registeremail(final_emailid,final_password);
                              if (register_result == 0){
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Registered Sucessfully!!', style: TextStyle(color: Colors.green,),),
                                      content: Text('Plese sign in using ur newly registered email and password!'),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      elevation: 5,
                                    )
                                );
                              }
                              else{
                                if (register_result == 12){
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                            title: Text("Invalid email!!!",
                                              style: TextStyle(
                                                color: Colors.red,),),
                                            content: Text('Try registering with ssn mail!!'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            elevation: 5,
                                          )
                                  );
                                }
                                else {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                            title: Text(register_result,
                                              style: TextStyle(
                                                color: Colors.red,),),
                                            content: Text('Try signing in!!'),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            elevation: 5,
                                          )
                                  );
                                }
                              }
                              },*/
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
      ),
    );
  }
}