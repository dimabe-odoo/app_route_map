import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:apk_route_map/bloc/login_bloc.dart';
import 'package:apk_route_map/bloc/provider.dart';
import 'package:apk_route_map/services/auth_service.dart';
import 'package:apk_route_map/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fzregex/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toast/toast.dart';

import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;
  var colors = const Color(0xff1f418b);
  String truck_patent;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final auth = new AuthService();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final changePassController = new TextEditingController();

  _LoginPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[_backgroundCreate(context), _formLogin(context)],
      ),
    );
  }

  Widget _formLogin(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 35.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: FormField(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder: (field) {
                return Column(
                  children: <Widget>[
                    Text(
                      'Ingrese sus datos',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    Container(
                      width: size.width - 100,
                      height: 50,
                      child: TextFormField(
                        validator: EmailValidator(
                            errorText: "este correo no es valido"),
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: Icon(Icons.mail_outline)),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Container(
                        width: size.width - 100,
                        height: 50,
                        child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: "Contraseña",
                                prefixIcon: Icon(Icons.lock)))),
                    SizedBox(height: 30.0),
                    GFButton(
                      onPressed: () {
                        setState(() {
                          auth
                              .login(
                                  emailController.text, passwordController.text)
                              .then((value) {
                            if (value['ok']) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                  (route) => false);
                            } else {
                              Toast.show(value['message'], context);
                            }
                          });
                        });
                      },
                      text: "Iniciar Sesion",
                      color: colors,
                    ),
                    GFButton(
                      child: Text('¿Olvido su contraseña?'),
                      onPressed: () {
                        setState(() {
                          showDialog(
                            context: context,
                            builder: (context) => changePassword(context),
                          );
                        });
                      },
                      textColor: Colors.blue,
                      color: Colors.transparent,
                    )
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
    );
  }

  Widget changePassword(BuildContext context) {
    return AlertDialog(
      title: Text("Cambio de Contrasteña"),
      content: Column(
        children: <Widget>[
          TextFormField(
            controller: changePassController,
            decoration: InputDecoration(
                hintText: "Correo:", prefixIcon: Icon(Icons.email)),
          )
        ],
      ),
      scrollable: true,
      actions: <Widget>[
        GFButton(onPressed: () {}, text: "Cancelar"),
        GFButton(
            onPressed: () {
              setState(() {

              });
            },
            text: "Confirmar")
      ],
    );
  }

  Widget _backgroundCreate(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orangeBackground = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[Color(0xff1f418b), Color(0xff1c5eed)])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        orangeBackground,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              GFAvatar(
                child: Image(
                  image: AssetImage('assets/img/logo.png'),
                  width: 150,
                ),
                shape: GFAvatarShape.circle,
              ),
              SizedBox(
                width: double.infinity,
                height: 10.0,
              ),
            ],
          ),
        )
      ],
    );
  }
}
