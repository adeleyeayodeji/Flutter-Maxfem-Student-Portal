import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Service/api.dart';

import '../main.dart';
import 'signin.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(new Duration(seconds: 3), () async {
      var respo = await getUserData("userdata");
      if (respo == null) {
        Route route = MaterialPageRoute(builder: (context) => SignInPage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route =
            MaterialPageRoute(builder: (context) => ProfileScreen("userdata", respo));
        Navigator.pushReplacement(context, route);
      }
    });
    //Return
    return SpinKitFadingCircle(
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.green, backgroundBlendMode: BlendMode.srcOver),
        );
      },
    );
  }
}
