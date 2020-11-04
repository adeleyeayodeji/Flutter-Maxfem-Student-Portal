import 'dart:async';
import 'dart:convert';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import './constants.dart';
import './pages/loader.dart';
import './widgets/profile_list_item.dart';

import 'pages/check_result.dart';
import 'pages/signin.dart';
import 'package:animated_splash/animated_splash.dart';
import './Service/api.dart';

void main() {
  //Load application
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      initTheme: kDarkTheme,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.of(context),
            home: AnimatedSplash(
                imagePath: 'assets/images/maxlogow.png',
                home: Loader(),
                duration: 5000,
                type: AnimatedSplashType.StaticDuration),
          );
        },
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final session;
  final data;
  //Contructor
  ProfileScreen(this.session, this.data);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //FLutter Toast
  FToast fToast;
  //Overide
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  _showToast(String message) {
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
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    //Redirect when logout clicked
    userLogoutRedirect(link) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (BuildContext context) => link));
    }

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

    var userData = jsonDecode(this.widget.data);
    //Profile design
    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: NetworkImage(imageURL + userData['logo']),
                ),
                GestureDetector(
                  onTap: () {
                    _showToast("Not Available Yet");
                  },
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: kSpacingUnit.w * 2.5,
                      width: kSpacingUnit.w * 2.5,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        heightFactor: kSpacingUnit.w * 1.5,
                        widthFactor: kSpacingUnit.w * 1.5,
                        child: Icon(
                          LineAwesomeIcons.pen,
                          color: Colors.white,
                          size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            userData['StudentName'],
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            userData['StudentEmail'],
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Container(
            height: kSpacingUnit.w * 4,
            width: kSpacingUnit.w * 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
              color: Colors.green,
            ),
            child: Center(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 0,
                    ),
                    child: Text(
                      userData['classname'],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    userData['Departments'] + " Dpt",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    var themeSwitcher = ThemeSwitcher(
      builder: (context) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 200),
          crossFadeState:
              ThemeProvider.of(context).brightness == Brightness.dark
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
          firstChild: GestureDetector(
            onTap: () async {
              ThemeSwitcher.of(context).changeTheme(theme: kLightTheme);
              await setUserData("mode", "light");
            },
            child: Icon(
              LineAwesomeIcons.sun,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
          secondChild: GestureDetector(
            onTap: () async {
              ThemeSwitcher.of(context).changeTheme(theme: kDarkTheme);
              await setUserData("mode", "dark");
            },
            child: Icon(
              LineAwesomeIcons.moon,
              size: ScreenUtil().setSp(kSpacingUnit.w * 3),
            ),
          ),
        );
      },
    );

    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),
        GestureDetector(
          onTap: () async {
            await logoutUser(this.widget.session);
            //Here
            pr.show();
            Future.delayed(Duration(seconds: 3), () {
              userLogoutRedirect(SignInPage());
            });
          },
          child: Icon(
            Icons.logout,
            size: ScreenUtil().setSp(kSpacingUnit.w * 3),
          ),
        ),
        profileInfo,
        themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );
    var reload = () async {
      var update = await getResult(
          userData["RollId"], userData["ClassId"], userData["StudentId"]);
      //Make a little delay
      Future.delayed(Duration(seconds: 1), () async {
        await setUserData("userresult", update);
        // print(update);
      });
    };
    //Reload result
    reload();
    //Return view
    return ThemeSwitchingArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                SizedBox(height: kSpacingUnit.w * 5),
                header,
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showToast("Not Available Yet");
                        },
                        child: ProfileListItem(
                          icon: LineAwesomeIcons.money_bill,
                          text: 'School Fees',
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // pr.show();
                          var response = await getUserData("userresult");
                          var resp2 = jsonDecode(response);
                          print(resp2["status"]["Status"]);
                          if (resp2["info"] == "No result") {
                            _showToast("Result not declared");
                          } else if (resp2["status"]["Status"] != '1') {
                            _showToast("Declared, but not active");
                          } else {
                            //Navigate forward
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CheckResult(userData, resp2)));
                          }
                        },
                        child: ProfileListItem(
                          icon: LineAwesomeIcons.newspaper,
                          text: 'Check Result',
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            _showToast("Not Available Yet");
                          },
                          child: ProfileListItem(
                            icon: LineAwesomeIcons.question_circle,
                            text: 'Make Complains',
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
