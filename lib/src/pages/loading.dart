import 'package:chatapp/src/pages/login.dart';
import 'package:chatapp/src/pages/users.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Object>(
        future: checkLoginState( context ),
        builder: (context, snapshot) {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      ),
    );
  }

  Future checkLoginState( BuildContext context ) async {
    final AuthService authService = Provider.of<AuthService>(context, listen: false);
    final SocketService socketService = Provider.of<SocketService>(context, listen: false);
    final isValidateToken = await authService.isLoggedIn();
    
    if( isValidateToken ){
      socketService.connect();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => UsersPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: ( _, __, ___ ) => LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
        )
      );
    }
  }
}