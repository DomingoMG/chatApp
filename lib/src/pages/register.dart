import 'package:chatapp/src/helpers/showAlert.dart';
import 'package:chatapp/src/services/auth.dart';
import 'package:chatapp/src/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/src/widgets/customInput.dart';
import 'package:chatapp/src/widgets/customButton.dart';
import 'package:chatapp/src/widgets/labels.dart';
import 'package:chatapp/src/widgets/logo.dart';
import 'package:provider/provider.dart';

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
    final AuthService authService = Provider.of<AuthService>( context );
    final socketService = Provider.of<SocketService>( context );
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
            callback: authService.isAuthNow ? null : () async {
              final registerSuccess = await authService.register(_txtName.text, _txtEmail.text.trim().toLowerCase(), _txtPassword.text);
              if( registerSuccess ){
                socketService.connect();
                showSimpleAlert(context, 'Completado', 'Se ha registrado con éxito.').then((value) => Navigator.of(context).pushReplacementNamed('login'));
              } else {
                showSimpleAlert(context, 'Error', 'Ya existe una cuenta con este correo electrónico');
              }
            },
          )
        ],
      ),
    );
  }
}