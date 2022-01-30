import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/http_exception.dart';

class Auth with ChangeNotifier{
  String token;
  DateTime expiryDate;
  String userId;
  Timer authTimer;


  bool get isAuth{
    return authToken != null;
  }
  String get userID{
    return userId;
  }

  String get authToken{
    if(expiryDate != null && expiryDate.isAfter(DateTime.now()) && token != null){
      return token;
    }
    return null;
  }

  Future<void> signUp({
    @required String email,
    @required String password,
  }) async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAbeCT6gDYUZlXbpUustPwaiigz2rPj3XQ');
    try{
      final response = await http.post(url , body: json.encode({
        'email' :email,
        'password':password,
        'returnSecureToken' : true,
      }));
      final responseData = jsonDecode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),),);
      autoLOgOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final uerData = json.encode({
        'token' : token,
        'userId' : userId,
        'expiryDate' : expiryDate.toIso8601String(),
      });
      prefs.setString('userData', uerData);
    }catch(error){
      throw error;
    }
  }

  Future<void> signIn({
    @required String email,
    @required String password,
  })async{
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAbeCT6gDYUZlXbpUustPwaiigz2rPj3XQ');
    try{
      final response = await http.post(url , body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      }));
      final responseData = jsonDecode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),),);
      autoLOgOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final uerData = json.encode({
        'token' : token,
        'userId' : userId,
        'expiryDate' : expiryDate.toIso8601String(),
      });
      prefs.setString('userData', uerData);
    }catch(error){
      throw error;
    }
  }


  Future <bool> tryLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData'))as Map<String , dynamic>;
    final expiryDAte = DateTime.parse(extractedUserData['expiryDate']);

    if(expiryDAte.isBefore(DateTime.now())){
      return false;
    }
    token = extractedUserData['token'];
    userId = extractedUserData['userId'];
    expiryDate = extractedUserData['expiryDate'];
    notifyListeners();
    autoLOgOut();
    return true;
  }
  void logOut(){
    token = null;
    expiryDate = null;
    userId = null;
    if(authTimer != null){
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
  }

  void autoLOgOut(){
    if(authTimer != null){
      authTimer.cancel();
    }
    final logoutTime = expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: logoutTime,), logOut);
  }
}