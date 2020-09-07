import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData prefixIcon;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController txtController;
  final bool isPassword;

  const CustomInput({
    Key key, 
    @required this.prefixIcon, 
    @required this.hintText, 
    @required this.txtController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5
          )
        ]
      ),
      child: TextField(
        autocorrect: false,
        obscureText: this.isPassword,
        controller: this.txtController,
        keyboardType: this.keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon( this.prefixIcon ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.hintText
        ),
      )
    );
  }
}