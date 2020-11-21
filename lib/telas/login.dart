import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prova1/model/usuario.dart';
import 'package:flutter_prova1/telas/home.dart';

import '../input-customize.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  AnimationController _controllerAnimacao;
  Animation<double> _animacaoBlur;
  Animation<double> _animacaoFade;
  Animation<double> _animacaoSize;

  _validarCampos() {
    String email = _controllerEmail.text.toString();
    String senha = _controllerSenha.text.toString();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "Login sucesso!";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _autenticandoUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Favor preencher a senha!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Favor preencher o e-mail utilizando um @!";
      });
    }
  }

  _autenticandoUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaserUser) {
      Navigator.pushReplacementNamed(context, "/splash");
    }).catchError((error) {
      setState(() {
        _mensagemErro = "Erro ao autenticar o usuário!" + error.toString();
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    auth.signOut();

    if (usuarioLogado != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  @override
  void initState() {
    _verificarUsuarioLogado();
    super.initState();

    _controllerAnimacao =
        AnimationController(duration: Duration(milliseconds: 4000), vsync: this);

    _animacaoBlur = Tween<double>(begin: 5, end: 0)
        .animate(CurvedAnimation(parent: _controllerAnimacao, curve: Curves.ease));

    _animacaoFade = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _controllerAnimacao, curve: Curves.easeInOutQuint));

    _animacaoSize = Tween<double>(begin: 0, end: 500).animate(
        CurvedAnimation(parent: _controllerAnimacao, curve: Curves.decelerate));

    _controllerAnimacao.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("imagens/usuario.png"),
                fit: BoxFit.cover
            )
        ),
        padding: EdgeInsets.all(18),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/logo.png",
                    width: 200,
                    height: 150,
                  ),
                ),

                AnimatedBuilder(
                  animation: _animacaoSize,
                  builder: (context, widget) {
                    return Container(
                      width: _animacaoSize.value,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 15,
                                spreadRadius: 4
                            )
                          ]),
                      child: Column(
                        children: <Widget>[
                          InputCustomize(
                            hint: "Email",
                            obscure: false,
                            icon: Icon(Icons.person),
                            controller: _controllerEmail,
                          ),
                          InputCustomize(
                            hint: "Senha",
                            obscure: false,
                            icon: Icon(Icons.lock),
                            controller: _controllerSenha,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Padding(
                  padding: EdgeInsets.all(10),
                ),
                AnimatedBuilder(
                    animation: _animacaoSize,
                    builder: (context, widget) {
                      return InkWell(
                        onTap: () {
                          _validarCampos();
                        },
                        child: Container(
                          width: _animacaoSize.value,
                          height: 50,
                          child: Center(
                            child: Text(
                              "Entrar",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(255, 100, 127, 1),
                                Color.fromRGBO(255, 123, 145, 1),
                              ])
                          ),
                        ),
                      );
                    }
                ),

                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _animacaoFade,
                    child: GestureDetector(
                      child: Text(
                        "Não possui conta? Cadastre-se!",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/cadastro");
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _animacaoFade,
                    child: GestureDetector(
                      child: Text(
                        "Esqueci minha senha!",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/recuperasenha");
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
