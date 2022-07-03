import email
from optparse import check_choice
from flask import Flask, jsonify, request
import json
import math, random
import psycopg2
from psycopg2 import Error
from datetime import date, datetime

#connection string declaration
connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")



app = Flask(__name__)

#global variable declaration
otp = ""
file = ""
ip = ""
name = ""


#post method for otp generation(recieves ap_mac, session_name  and returns along with otp)
@app.route('/send',methods=['POST'])
def return_otp():
    #referencing global variables
    global otp 
    global ip
    global name
    #calling generate otp function
    otp = generate_otp()

    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))

    #extracting ap_mac and session_name
    email = request_data['email']
    ip = request_data['ip']
    name = request_data['name']
    today = date.today()
    name = name+"_"+today.strftime("%d/%m/%y")
    request_data['name'] = name
    doa = ""+today.strftime("%y-%m-%d")
    now = datetime.now()
    time = now.strftime("%H:%M:%S")

    #attaching otp 
    request_data['otp'] = otp

    #writting all the deatils into the database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("insert into valid_session values('%s','%s','%s','%s','%s','%s')" %(name,otp,ip,doa,time,email))
    connection.commit()
    cursor.close()
    connection.close()

    return jsonify(request_data)

#post method to recieve otp, session_name, reg_no, ap_mac from the student
@app.route('/recieve',methods=['POST'])
def mark_attendance():
    #referencing global variables
    global file 
    global connection

    #storing recieved data as variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    file = request_data['session_name']

    #storing data in temporary variable
    session_name = request_data['session_name']
    today = date.today()
    session_name = session_name+"_"+str(today.strftime("%d/%m/%y"))
    print(session_name)
    request_data['session_name'] = session_name
    otp = request_data['otp']
    mac = request_data['ip']
    email = request_data['email']
    doa = ""+today.strftime("%y-%m-%d")

    #checking for existing attendance data
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select reg_no from student_login where email_id = '%s'"%(email))
    reg_no = cursor.fetchone()
    connection.commit()
    cursor.execute("select reg_no from student_attendance where otp='%s' and reg_no='%s' and session_name = '%s' and doa = '%s'"%(otp, reg_no[0],session_name,doa))
    ans = cursor.fetchone()
    connection.commit()
    
    if ans:
        print("found")
        request_data['state'] = 'marked'
        return jsonify(request_data)
    else:
        print("not present")

    cursor.close()
    connection.close()
    

    #writting all the deatils into the database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select otp from valid_session where session_name = '%s' and doa = '%s'"%(session_name,doa))
    check_otp = cursor.fetchall()
    print(check_otp)
    if not check_otp:
        print("na")
        request_data['state'] = 'na'
        return jsonify(request_data)

    #######check presence of otp in valid session
    print(check_otp[-1],otp)

    #save attendance
    if str(check_otp[-1][0]) == otp:
        print(check_otp[-1][0],otp)
        cursor.execute("insert into student_attendance values('%s','%s','%s','%s','','%s')"%(reg_no[0],session_name,otp,mac,doa))
        connection.commit()
        cursor.close()
        connection.close()
    else:
        print("nope")
        request_data['state'] = 'nope'
        return jsonify(request_data)

    request_data['state'] = 'done'
    print(request_data)
    return jsonify(request_data)
    
#login check
@app.route('/login',methods=['POST'])
def student_login():
    #global reference
    global connection

    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))

    #extracting ap_mac and session_name
    email = request_data['email']
    password = request_data['password']
    type = request_data['type']

    #checking the database
    if type == 'Student':
        connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
        cursor = connection.cursor()
        cursor.execute("select password from student_details where email_id='%s'"%(email))
        db_auth = cursor.fetchone()
        connection.commit()
    else:
        connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
        cursor = connection.cursor()
        cursor.execute("select pass from faculty_login where email_id='%s'"%(email))
        db_auth = cursor.fetchone()
        connection.commit()
    cursor.close()
    connection.close()
    print(db_auth[0])
    #exception handling for password
    #email doesnt exist
    if not db_auth:
        request_data['status'] = 1
        return jsonify(request_data)
    #wrong password
    elif db_auth[0] != password:
        request_data['status'] = 2
        return jsonify(request_data)
    #correct password
    elif db_auth[0] == password:
        request_data['status'] = 4
        return jsonify(request_data)

    return jsonify(request_data)

#generates a 4 digit otp 
def generate_otp():
    digits = "0123456789"
    OTP = ""
    for i in range(4) :
        OTP += digits[math.floor(random.random() * 10)]
 
    return OTP

#fetch student details from database
@app.route('/student_details',methods=['POST'])
def get_student_details():
    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select f_name, l_name, reg_no, semester from student_details where email_id = '%s'"%(request_data['email']))
    details = cursor.fetchone()
    print(details)
    #storing data in json
    request_data['f_name'] = details[0]
    request_data['l_name'] = details[1]
    request_data['reg_no'] = details[2]
    request_data['semester'] = details[3]
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify(request_data)


#to retrieve faculty details
@app.route('/faculty_details',methods=['POST'])
def get_faculty_details():
    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))

    email = request_data['email']
    print("This the email: ",email)
    
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select f_name, l_name, fac_id from faculty_detail where email_id = '%s'"%(email))
    details = cursor.fetchone()
    print(details)
    #storing data in json
    request_data['f_name'] = details[0]
    request_data['l_name'] = details[1]
    request_data['fac_id'] = details[2]
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify(request_data)



#fetch student subjects from database
@app.route('/student_subjects',methods=['POST'])
def get_student_subjects():
    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    print(request_data['semester'])
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select * from subject_semester where semester = '%s'"%(request_data['semester']))
    details = cursor.fetchone()
    print(details)
    #storing data in json
    request_data['subjects'] = [details[i]+" "+details[i+1] for i in range(1,len(details)-1,2)]
    print(request_data['subjects'])
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify(request_data)

#fetch student subjects from database
@app.route('/professor_subjects',methods=['POST'])
def get_professor_subjects():
    #storing received data into a variable
    request_data = request.data

    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    print(request_data['email'])
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select * from professor_subjects where email_id = '%s'"%(request_data['email']))
    details = cursor.fetchone()
    print(details)
    lst = []
    for i in range(1,len(details)-1,2):
        if details[i] != None and details[i+1] != None:
            lst.append(details[i]+" "+details[i+1])
    #storing data in json
    request_data['subjects'] = lst #[details[i]+" "+details[i+1] for i in range(1,len(details)-1,2)]
    print(request_data['subjects'])
    connection.commit()
    cursor.close()
    connection.close()
    return jsonify(request_data)

#to register students into the database
@app.route('/student_register',methods=['POST'])
def student_register():
    #storing received data into a variable
    request_data = request.data
    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    print(request_data['reg_no'])
    regno = request_data['reg_no']
    fname = request_data['f_name']
    lname = request_data['l_name']
    email = request_data['email_id']
    sem = int(request_data['sem'])
    password = request_data['password']
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select email_id from student_details where reg_no = '%s'"%(regno))
    details = cursor.fetchone()
    if not details:
        cursor.execute("insert into student_details values('%s','%s','%s','%s','%s','%s')"%(fname,lname,regno,email,sem,password))
        cursor.execute("insert into student_login values('%s','%s','%s')"%(email,password,regno))
        connection.commit()
        cursor.close()
        connection.close()
        request_data["status"] = 1
    else:
        request_data["status"] = 0

    return jsonify(request_data)


#to register faculty into the database
@app.route('/faculty_register',methods=['POST'])
def faculty_register():
    #storing received data into a variable
    request_data = request.data
    #decoding json data
    request_data = json.loads(request_data.decode('utf-8'))
    print(request_data['reg_no'])
    fac_id = request_data['reg_no']
    fname = request_data['f_name']
    lname = request_data['l_name']
    email = request_data['email_id']
    password = request_data['password']
    #fetching data from database
    connection = psycopg2.connect(user="postgres",
                                  password="anand",
                                  host="127.0.0.1",
                                  port="5432",
                                  database="ssn_attendance")
    cursor = connection.cursor()
    cursor.execute("select email_id from faculty_detail where fac_id = '%s'"%(fac_id))
    details = cursor.fetchone()
    if not details:
        cursor.execute("insert into faculty_login values('%s','%s')"%(email,password))
        cursor.execute("insert into faculty_detail values('%s','%s','%s','%s','%s')"%(fac_id,fname,lname,email,password))
        connection.commit()
        cursor.close()
        connection.close()
        request_data["status"] = 1
    else:
        request_data["status"] = 0

    return jsonify(request_data)


if __name__ == '__main__':
    app.run(debug = True)