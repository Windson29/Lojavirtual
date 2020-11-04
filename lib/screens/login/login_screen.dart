import 'package:flutter/material.dart';
import 'package:lojadomdiegoapp/helpers/validators.dart';
import 'package:lojadomdiegoapp/models/user_manager.dart';
import 'package:lojadomdiegoapp/models/users.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text ('Entrar'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/signup');

            },
            textColor: Colors.white,
            child: const Text(
              'Criar Conta',
            style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __){
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      enabled: !userManager.loading,
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email){
                        if (!emailValid(email))
                          return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16,),
                    TextFormField(
                      enabled: !userManager.loading,
                      controller: senhaController,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      autocorrect: false,
                      validator: (senha){
                        if (senha.isEmpty || senha.length < 6)
                          return 'Senha inválida';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: (){

                        },
                        padding: EdgeInsets.zero,
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    SizedBox(
                      height: 44,
                      child: RaisedButton(
                        onPressed: userManager.loading ? null : (){
                          if (formkey.currentState.validate()){
                            userManager.signIn(
                                user: User(
                                  email: emailController.text,
                                  senha: senhaController.text,
                                ),
                                onFail: (e) {
                                  scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text('Falha ao entrar:  $e'),
                                        backgroundColor: Colors.black,
                                      )
                                  );
                                },
                                onSuccess: (){
                                  Navigator.of(context).pop();
                                }
                            );
                          }
                        },
                        color: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).primaryColor.withAlpha(100),
                        textColor: Colors.white,
                        child: userManager.loading ?
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ) :
                        const Text ('ENTRAR',
                          style: TextStyle(
                              fontSize: 18
                          ),),
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ),
      ),
    );
  }
}
