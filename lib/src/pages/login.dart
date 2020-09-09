import 'package:chatapp/src/helpers/showAlert.dart';
import 'package:chatapp/src/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/src/widgets/customInput.dart';
import 'package:chatapp/src/widgets/customButton.dart';
import 'package:chatapp/src/widgets/labels.dart';
import 'package:chatapp/src/widgets/logo.dart';
import 'package:chatapp/src/services/auth.dart';

class LoginPage extends StatelessWidget {
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
                Logo(title: 'Messenger'),
                _Form(),
                Labels(
                  infoAccount: '¿No tienes cuenta?',
                  btnTitle: 'Crear una ahora!',
                  navigateTo: 'register'
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

  final _txtEmail = TextEditingController();
  final _txtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final AuthService authServices = Provider.of<AuthService>( context );
    final SocketService socketService = Provider.of<SocketService>( context );
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
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
            title: 'Iniciar Sesión',
            callback: authServices.isAuthNow ? null : () async { 
              FocusScope.of(context).unfocus();
              final loginSuccess = await authServices.login( _txtEmail.text.trim().toLowerCase(), _txtPassword.text );
              if( loginSuccess ){
                socketService.connect();
                Navigator.of(context).pushReplacementNamed('users');
                // TODO: Navegar a otra pantalla
              } else {
                showSimpleAlert(context, 'Login incorrecto', 'Email o contraseña incorrecto.');
              }
            }
          )
        ],
      ),
    );
  }
}