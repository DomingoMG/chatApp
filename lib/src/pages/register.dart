import 'package:flutter/material.dart';
import 'package:chatapp/src/widgets/customInput.dart';
import 'package:chatapp/src/widgets/customButton.dart';
import 'package:chatapp/src/widgets/labels.dart';
import 'package:chatapp/src/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(title: 'Registro'),
                _Form(),
                Labels(
                  infoAccount: '¿Ya tienes una cuenta?',
                  btnTitle: 'Iniciar ahora!',
                  navigateTo: 'login'
                ),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200))
              ],
            ),
          ),
        ),
      )
    );
  }
}


class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final _txtName = TextEditingController();
  final _txtEmail = TextEditingController();
  final _txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            prefixIcon: Icons.perm_identity,
            hintText: 'Nombre',
            keyboardType: TextInputType.text,
            txtController: _txtName,
          ),
          CustomInput(
            prefixIcon: Icons.mail_outline,
            hintText: 'Correo',
            keyboardType: TextInputType.emailAddress,
            txtController: _txtEmail,
          ),
          CustomInput(
            prefixIcon: Icons.lock_outline,
            hintText: 'Contraseña',
            txtController: _txtPassword,
            isPassword: true,
          ),
          CustomButton(
            title: 'Crear cuenta',
            callback: (){
              print( _txtEmail.text );
              print( _txtPassword.text );
            },
          )
        ],
      ),
    );
  }
}