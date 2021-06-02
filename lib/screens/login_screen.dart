import 'package:flutter/material.dart';
import 'package:loja_importacao/helpers/class_helpers.dart';
import 'package:loja_importacao/models/user_model.dart';
import 'package:loja_importacao/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final FailLogin _snackError2 = FailLogin();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _snackError2.text = "Erro no Login ou Senha!";
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            "Entrar",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text("Criar Conta"),
              style: TextButton.styleFrom(
                  primary: Colors.white, textStyle: TextStyle(fontSize: 18)),
            ),
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(hintText: "E-mail"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text!.isEmpty || !text.contains("@"))
                        return "E-mail inválido!";
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text!.isEmpty || text.length < 6)
                        return "Senha inválida!";
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty)
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Insira seu e-mail de recuperação!"),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        else {
                          model.recoverPass(_emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Confira seu e-mail!"),
                            backgroundColor: Theme.of(context).primaryColor,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text("Esqueci minha Senha"),
                      style: TextButton.styleFrom(
                          primary: Colors.black,
                          textStyle: TextStyle(fontSize: 16),
                          padding: EdgeInsets.zero),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {}
                      model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSucess: _onSucess,
                          onFail: _snackError2.showSk());
                    },
                    child: Text("Entrar"),
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        onPrimary: Colors.white,
                        textStyle: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }
}
