import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_prova1/RouteGenerator.dart';
import 'package:flutter_prova1/telas/login.dart';

void main() async {
  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute, //onGenerateRoute é chamado toda vez que uma rota precisa ser inicializada ou aberta
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
  ));
}