import 'dart:io';

import 'package:chatapp/src/widgets/chatMessage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {


  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _txtController = TextEditingController();
  final _focusNode = FocusNode();
  bool isWriting = false;

  List<ChatMessage> _messages = [
    
  ];

  @override
  Widget build(BuildContext context) {
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
              child: Text('LI', style: TextStyle(fontSize: 12)),
              maxRadius: 12,
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text('Lisbety León', style: TextStyle(color: Colors.black87, fontSize: 12))
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
    final newMessage = ChatMessage( uid: '1234', text: value, animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 200) ) );
    newMessage.animationController.forward();
    _messages.insert(0, newMessage);
    setState(() {isWriting = false;});
  }

  @override
  void dispose() {
    // TODO: Off del socket
    // Limpiar cada una de las instancias los animations controllers
    for( ChatMessage message in _messages ){
      message.animationController.dispose();
    }
    super.dispose();
  }

}