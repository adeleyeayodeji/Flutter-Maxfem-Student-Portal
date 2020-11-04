import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// String url = "http://10.0.2.2/admission/api/users.php";
String url = "https://www.admission.maxfemschools.com/api/users.php";

String imageURL = "https://result.maxfemschools.com/images/";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//Make User Auth Request
Future userAuth(String email, String password) async {
  //Make Request
  var response = await http.post(url,
      body: {'user_login': 'true', 'email': email, 'password': password});
  var convertToJson = jsonDecode(response.body);
  return convertToJson;
}

//Make User Auth Request
Future getResult(String rollid, String classid, String studentid) async {
  //Make Request
  var response = await http.post(url,
      body: {'view_result': 'true', 'rollid': rollid, 'classid': classid, 'studentid' : studentid});
  var convertToJson = response.body;
  return convertToJson;
}

//Make Data Auth Request
Future dataAuth(String classid, String departmentid) async {
  //Make Request
  var response = await http.post(url,
      body: {'class': 'true', 'classid': classid, 'departmentid': departmentid});
  var convertToJson = jsonDecode(response.body);
  return convertToJson;
}

//Set local data
Future setUserData(String name, String data) async {
  final SharedPreferences prefs = await _prefs;
  prefs.setString(name, data);
  return name;
}

//delete local data
Future deleteUserData(String name) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.remove(name);
}

//get local data
Future getUserData(String name) async {
  final SharedPreferences prefs = await _prefs;
  return prefs.get(name);
}

//Logout user
Future logoutUser(String name) async {
  await deleteUserData(name);
  await deleteUserData("userresult");
  return "loggedout";
}
