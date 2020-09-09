import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/global/enviroment.dart';
import 'package:chatapp/src/models/ChatMessagesResponse.dart';

class ChatService extends ChangeNotifier {

  // Usuario para quien va el mensaje
  User userTo;

  Future<List<Message>> getChatMessages( String userId ) async {
    final response = await http.get(
      '${Environment.apiURL}/messages/$userId',
      headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final messagesResponse = chatMessagesResponseFromJson( response.body );
    return messagesResponse.messages;
  }



}