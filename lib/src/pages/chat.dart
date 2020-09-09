import 'dart:io';

import 'package:chatapp/src/models/ChatMessagesResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/src/models/user.dart';
import 'package:chatapp/src/widgets/chatMessage.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/services/chat.dart';
import 'package:chatapp/src/services/socket.dart';

class ChatPage extends StatefulWidget {


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _txtController = TextEditingController();
  final _focusNode = FocusNode();
  bool isWriting = false;

  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  List<ChatMessage> _messages = [
    
  ];

  @override
  void initState() {
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);
    this.socketService.socket.on('mensaje-personal', _messageListener);
    _loadChatHistory( this.chatService.userTo.uid );

    super.initState();
  }

  void _loadChatHistory( String userId ) async {
    List<Message> chatMessages = await this.chatService.getChatMessages( userId );
    final history = chatMessages.map(( m ) => ChatMessage(
      text: m.message,
      uid: m.my,
      animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 0) )..forward(),
    ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _messageListener( dynamic payload ){
    print('tengo mensaje: $payload');
    ChatMessage message = ChatMessage(
      text: payload['message'],
      uid: payload['to'],
      animationController: AnimationController( vsync:  this, duration: Duration( milliseconds: 300 ) ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final User userTo = this.chatService.userTo;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Text('${userTo.name.substring(0, 2)}', style: TextStyle(fontSize: 12)),
              maxRadius: 12,
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text('${userTo.name}', style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: ( _, i ) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              )
            ),
            Divider(height: 1),
            // TODO: Caja de texto
            Container(
              decoration: BoxDecoration(
                color: Colors.white
              ),
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric( horizontal: 8 ),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _txtController,
                onSubmitted: _handleSubmit,
                onChanged: ( String value ){
                  setState(() {
                    if( value.trim().length > 0 ){
                      isWriting = true;
                    } else {
                      isWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                  
                ),
                focusNode: _focusNode,
              ),
            ),

            // TODO: Botón de enviar
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4 ),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'),
                onPressed: (){},
              ) 
              : Container(
                margin: EdgeInsets.symmetric( horizontal: 4 ),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[400]
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon( Icons.send ),
                    onPressed: isWriting
                    ? () => _handleSubmit( _txtController.text.trim() )
                    : null
                  ),
                ),
              )
            ),

          ],
        ),
      ),
    );
  }

  void _handleSubmit( String value ){
    if( value.length == 0 ) return;
    _txtController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage( uid: authService.user.uid, text: value, animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 200) ) );
    newMessage.animationController.forward();
    _messages.insert(0, newMessage);
    setState(() {isWriting = false;});
    this.socketService.emit('mensaje-personal', {
      'my': this.authService.user.uid,
      'to': this.chatService.userTo.uid,
      'message': value
    });
  }

  @override
  void dispose() {
    // Limpiar cada una de las instancias los animations controllers
    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

}