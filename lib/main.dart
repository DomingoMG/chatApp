import 'package:chatapp/src/routes/routes.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/services/chat.dart';
import 'package:chatapp/src/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
        ChangeNotifierProvider(create: ( _ ) => SocketService() ),
        ChangeNotifierProvider(create: ( _ ) => ChatService() )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        routes: appRoutes,
        initialRoute: 'loading',
      ),
    );
  }
}