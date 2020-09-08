import 'package:chatapp/src/pages/chat.dart';
import 'package:chatapp/src/pages/loading.dart';
import 'package:chatapp/src/pages/login.dart';
import 'package:chatapp/src/pages/register.dart';
import 'package:chatapp/src/pages/users.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function( BuildContext )> appRoutes = {
  'users':       ( _ ) => UsersPage(),
  'chat':        ( _ ) => ChatPage(),
  'login':       ( _ ) => LoginPage(),
  'register':    ( _ ) => RegisterPage(),
  'loading':     ( _ ) => LoadingPage()
};