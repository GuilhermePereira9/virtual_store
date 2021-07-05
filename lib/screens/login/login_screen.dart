import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:virtual_store/helpers/validators.dart';
import 'package:provider/provider.dart';
import 'package:virtual_store/models/user.dart';
import 'package:virtual_store/models/user_manager.dart';

class LoginScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/signup');
              },
              child: const Text(
                'CRIAR CONTA',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ))
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formKey,
              child: Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.loadingFace) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        validator: (email) {
                          if (!emailValid(email)) return 'Email Invalido';
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: passController,
                        enabled: !userManager.loading,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        autocorrect: false,
                        obscureText: true,
                        validator: (pass) {
                          if (pass.isEmpty || pass.length < 6)
                            return 'Senha Invalida';
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text('Esqueci minha senha'),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formKey.currentState.validate()) {
                                  userManager.singIn(
                                      user: User(
                                          email: emailController.text,
                                          password: passController.text),
                                      onFail: (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                        ));
                                      },
                                      onSucess: () {
                                        Navigator.of(context).pop();
                                      });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            onSurface:
                                Theme.of(context).primaryColor.withAlpha(100)),
                        child: userManager.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                "Entrar",
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      SignInButton(Buttons.Facebook,
                          text: 'Entrar com Facebook', onPressed: () {
                        userManager.facebookLogin(onFail: (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Falha ao entrar: $e'),
                            backgroundColor: Colors.red,
                          ));
                        }, onSucess: () {
                          Navigator.of(context).pop();
                        });
                      })
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}
