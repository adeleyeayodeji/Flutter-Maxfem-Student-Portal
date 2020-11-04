import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../Service/api.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../main.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //Form Key
  final _formkey = GlobalKey<FormState>();
  var message;
  //FLutter Toast
  FToast fToast;
  //Overide
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(String message, place) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: place,
      toastDuration: Duration(seconds: 5),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // emailController.addListener(_printLatestValue);
  // }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //  _printLatestValue() {
  //   print("Second text field: ${emailController.text}");
  // }

  _userLogin(String email, String password) async {
    var response = await userAuth(email, password);
    return response;
  }

  redirectUser(String data, String result) async {
    //Set data
    await setUserData("userdata", data);
    await setUserData("userresult", result);
    //Get data
    var respo = await getUserData("userdata");
    //Make Route
    Route route = MaterialPageRoute(
        builder: (context) => ProfileScreen("userdata", respo));
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    //Loader Initialization
    final pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,

      /// your body here
      customBody: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: Colors.green,
      ),
    );
    //Retrun view

    //Save email to form
    _updateEmail() async {
      var respo = await getUserData("useremail");
      (respo == null)
          ? emailController.text = ""
          : emailController.text = respo;
    }
    _updateEmail();
    //Return view
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                      child: Text('Login',
                          style: TextStyle(
                              fontSize: 80.0, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                      child: Text('.',
                          style: TextStyle(
                              fontSize: 80.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    )
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email cannot be empty";
                            }
                          },
                          controller: emailController,
                          decoration: InputDecoration(
                              labelText: 'EMAIL',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password cannot be empty";
                            }
                          },
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: 'PASSWORD',
                              labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          obscureText: true,
                        ),
                        SizedBox(height: 5.0),
                        GestureDetector(
                          onTap: () {
                            _showToast(
                                "Not Available Yet", ToastGravity.BOTTOM);
                          },
                          child: Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 20.0),
                            child: InkWell(
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        GestureDetector(
                          onTap: () async {
                            //Validate Form
                            if (_formkey.currentState.validate()) {
                              //Logs
                              pr.show();
                              //Declaring var
                              var userData;
                              var userResult;
                              var data;
                              //Making future request
                              var res = await _userLogin(emailController.text,
                                  passwordController.text);
                              //Checking if success
                              if (res['info'] == 'Success') {
                                //Get data
                                data = await dataAuth(res["data"]["ClassId"],
                                    res["data"]["Departments"]);
                                userData =
                                    '{"StudentId" : "${res["data"]["StudentId"]}", "StudentName": "${res["data"]["StudentName"]}", "classtype" : "${res["data"]["classtype"]}", "session" : "${res["data"]["session"]}", "logo" : "${res["data"]["logo"]}", "RollId" : "${res["data"]["RollId"]}", "StudentEmail" : "${res["data"]["StudentEmail"]}", "mobile": "${res["data"]["mobile"]}", "Gender": "${res["data"]["Gender"]}", "DOB": "${res["data"]["DOB"]}", "classname": "${data["classname"]}", "user_token": "${res["data"]["user_token"]}", "RegDate": "${res["data"]["RegDate"]}", "Status": "${res["data"]["Status"]}", "Departments": "${data["department"]}", "ClassId" : "${res["data"]["ClassId"]}"}';

                                //Get Result
                                userResult = await getResult(
                                    res["data"]["RollId"],
                                    res["data"]["ClassId"],
                                    res["data"]["StudentId"]);

                                //Set default email
                                await setUserData(
                                    "useremail", res["data"]["StudentEmail"]);
                              }
                              Future.delayed(Duration(seconds: 3), () async {
                                (res['info'] == 'Success')
                                    ? redirectUser(userData, userResult)
                                    : _showToast(
                                        res['info'], ToastGravity.CENTER);
                                //Hide loader
                                (res['info'] != 'Success') && await pr.hide();
                              });
                            }
                            //End loader
                          },
                          child: Container(
                            height: 40.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Padding(
                  // this is new
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom)),
            ],
          ),
        ));
  }
}
