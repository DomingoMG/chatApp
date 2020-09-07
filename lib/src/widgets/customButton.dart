import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final Function callback;
  final String title;

  const CustomButton({
    Key key, 
    @required this.callback, 
    @required this.title
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        child: Center(
          child: Text('$title', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold))
        )
      ),
      onPressed: this.callback,
    );
  }
}