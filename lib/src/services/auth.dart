import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/src/global/enviroment.dart';
import 'package:chatapp/src/models/loginResponse.dart';
import 'package:chatapp/src/models/user.dart';

class AuthService with ChangeNotifier {

  User user;
  final _storage = FlutterSecureStorage();

  
  bool _isAuthNow = false;
  bool get isAuthNow => this._isAuthNow;
  set setAuthNow( bool value ) {
    this._isAuthNow = value;
    notifyListeners();
  }

  Future<bool> login( String email, String password ) async {
    this.setAuthNow = true;

    final data = {
      'email': email,
      'password': password
    };

    print('${Environment.apiURL}/login/');
    
    final response = await http.post(
      '${Environment.apiURL}/login/',
      body: json.encode( data ),
      headers: {'Content-Type': 'application/json'}
    );

    if( response.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( response.body );
      this.user = loginResponse.user;
      await this._saveToken( loginResponse.token );
      this.setAuthNow = false;
      return true;
    }  else {
      this.setAuthNow = false;
      return false;
    }
  }

  Future<bool> register( String name, String email, String password ) async {
    this.setAuthNow = true;

    final data = {
      'name': name,
      'email': email,
      'password': password
    };
    
    final response = await http.post(
      '${Environment.apiURL}/login/new/',
      body: json.encode( data ),
      headers: {'Content-Type': 'application/json'}
    );

    if( response.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( response.body );
      this.user = loginResponse.user;
      await this._saveToken( loginResponse.token );
      this.setAuthNow = false;
      return true;
    }  else {
      this.setAuthNow = false;
      return false;
    }
  }

  // Getters and Setters static
  static Future<String> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'ChatApp_AuthToken');
    return token;
  }
  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'ChatApp_AuthToken');
  }
  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'ChatApp_AuthToken');
    final response = await http.get(
      '${Environment.apiURL}/login/renew',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      }
    );
    if( response.statusCode == 200 ){
      final loginResponse = loginResponseFromJson( response.body );
      this.user = loginResponse.user;
      await this._saveToken( loginResponse.token );
      print(response.body);
      return true;
    } else {
      this._logout();
      return false;
    }

  }
  Future<void> _saveToken( String token ) async  => await _storage.write(key: 'ChatApp_AuthToken', value: token);
  Future<void> _logout() async => await _storage.delete(key: 'ChatApp_AuthToken');
}