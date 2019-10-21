import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BaseAuth {

  Future<bool> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  String getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  String getAuthHeader();
}

class User {
  final String name;
  final String mail;
  final String password;

  User({this.name, this.mail, this.password});
}

class Auth implements BaseAuth {
  String name;
  String authHeader;

  @override
  Future<bool> signIn(String login, String password) {
    var body = jsonEncode({"username":login, "password":password});
    return http
        .post("http://localhost:2990/jira/rest/auth/1/session", headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        }, body: body)
        .then((res) => handleLogin(res, login, password))
        .catchError((error) => handleHttpError(error));
  }

  @override
  Future<bool> isEmailVerified() {
    return Future.delayed(Duration(seconds: 2), () => true);
  }

  @override
  Future<Function> signOut() {
    return Future.delayed(
        Duration(seconds: 2), () => Future.delayed(Duration(seconds: 1)));
  }

  @override
  Future<Function> sendEmailVerification() {
    return Future.delayed(
        Duration(seconds: 2), () => Future.delayed(Duration(seconds: 1)));
  }

  @override
  String getCurrentUser() {
    return this.name;
  }

  @override
  Future<String> signUp(String email, String password) {
    return Future.delayed(Duration(seconds: 2), () => "signed up");
  }

  bool handleLogin(http.Response response, String login, String password) {
    if(response.statusCode == 200) {
      this.name = login;
      final String pair = "$login:$password";
      final bytes = utf8.encode(pair);
      final base64Encoded = base64Encode(bytes);
      authHeader = "Basic $base64Encoded";
    }
    return response.statusCode == 200;
  }
  bool handleHttpError(StateError response) {
    print("Error http response: " + response.toString());
    return false;
  }

  @override
  String getAuthHeader() {
    return this.authHeader;
  }
}
