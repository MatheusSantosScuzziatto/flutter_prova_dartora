import 'package:flutter/material.dart';
import 'package:flutter_prova1/telas/home.dart';
import 'package:flutter_prova1/telas/cadastro.dart';
import 'package:flutter_prova1/telas/lista.dart';
import 'package:flutter_prova1/telas/login.dart';
import 'package:flutter_prova1/telas/mensagens.dart';
import 'package:flutter_prova1/telas/recuperasenha.dart';
import 'package:flutter_prova1/telas/splashscreen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/home":
        return MaterialPageRoute(builder: (_) => Home());
      case "/mensagens":
        return MaterialPageRoute(builder: (_) => Mensagens(args));
      case "/lista":
        return MaterialPageRoute(builder: (_) => Lista());
      case "/recuperasenha":
        return MaterialPageRoute(builder: (_) => RecuperaSenha());
      case "/splash":
        return MaterialPageRoute(builder: (_) => SplashScreen());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
