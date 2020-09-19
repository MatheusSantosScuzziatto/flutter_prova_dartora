import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:validadores/ValidarCPF.dart';
import 'package:flutter_prova1/model/usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerCPF = TextEditingController();
  TextEditingController _controllerRG = TextEditingController();
  TextEditingController _controllerSUS = TextEditingController();
  TextEditingController _controllerDtnascimento = TextEditingController();
  TextEditingController _controllerCEP = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerCidade = TextEditingController();
  TextEditingController _controllerEstado = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  DateTime _selectedDate = DateTime.now();

  _validaCampos() async {
    String _nome = _controllerNome.text.toString();
    String _cpf = _controllerCPF.text.toString();
    String _rg = _controllerRG.text.toString();
    String _sus = _controllerSUS.text.toString();
    String _dtnascimento = _controllerDtnascimento.text.toString();
    String _cep = _controllerCEP.text.toString();
    String _endereco = _controllerEndereco.text.toString();
    String _cidade = _controllerCidade.text.toString();
    String _estado = _controllerEstado.text.toString();
    String _email = _controllerEmail.text.toString().trim();
    String _senha = _controllerSenha.text.toString();

    if (CPF.isValid(_cpf)) {
      if (_nome.isNotEmpty) {
        if(_rg.isNotEmpty) {
          if(_sus.isNotEmpty) {
            if(_dtnascimento.isNotEmpty) {
              if(_cep.isNotEmpty) {
                if(_endereco.isNotEmpty) {
                  if(_cidade.isNotEmpty) {
                    if(_estado.isNotEmpty) {
                      if (_email.isNotEmpty && _email.contains("@")) {
                        if (_senha.isNotEmpty && _senha.length > 6) {
                          setState(() {
                            _mensagemErro = "";
                          });
                          Usuario usuario = Usuario();
                          usuario.nome = _nome;
                          usuario.cpf = _cpf;
                          usuario.rg = _rg;
                          usuario.sus = _sus;
                          usuario.dtnascimento = "${_controllerDtnascimento.text} ${TimeOfDay.now().hour.toString()}:${TimeOfDay.now().minute.toString()}";
                          usuario.cep = _cep;
                          usuario.endereco = _endereco;
                          usuario.cidade = _cidade;
                          usuario.estado = _estado;
                          usuario.email = _email;
                          usuario.senha = _senha;
                          usuario.urlImage = "https://firebasestorage.googleapis.com/v0/b/provapautora.appspot.com/o/medic.png?alt=media&token=1a08bba0-ec90-4454-9051-38df6029d2c8";
                          await _cadastrarUsuario(usuario);
                        } else {
                          setState(() {
                            _mensagemErro = "Digite uma senha com mais de 6 digitos!";
                          });
                        }
                      } else {
                        setState(() {
                          _mensagemErro = "Preencha o E-Mail!";
                        });
                      }
                    } else {
                      setState(() {
                        _mensagemErro = "Preencha o Estado!";
                      });
                    }
                  } else {
                    setState(() {
                      _mensagemErro = "Preencha a Cidade!";
                    });
                  }
                } else {
                  setState(() {
                    _mensagemErro = "Preencha o Endereco!";
                  });
                }
              } else {
                setState(() {
                  _mensagemErro = "Preencha o CEP!";
                });
              }
            } else {
              setState(() {
                _mensagemErro = "Preencha a Data de Nascimento!";
              });
            }
          } else {
            setState(() {
              _mensagemErro = "Preencha a Carteira do SUS!";
            });
          }
        } else {
          setState(() {
            _mensagemErro = "Preencha o RG!";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o Nome Completo!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "CPF inválido!";
      });
    }
  }

  _cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email.trim(), password: usuario.senha)
        .then((firebaseUser) {

     Firestore db =  Firestore.instance;
     db.collection("usuarios").document(firebaseUser.user.uid).setData(usuario.toMap());

     Navigator.pushReplacementNamed(context, "/home");

    }).catchError((error) {
      setState(() {
        print("erro: " + error.toString());
        _mensagemErro = "Erro ao cadastrar usuário, favor verificar!";
      });
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2900));
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        String dia = _selectedDate.day.toString();
        String mes = _selectedDate.month.toString();
        String ano = _selectedDate.year.toString();
        _controllerDtnascimento.text = "$dia/$mes/$ano";
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagens/usuario.png",
                    width: 200,
                    height: 150,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Nome Completo",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerCPF,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CpfInputFormatter()
                    ],
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "CPF",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerRG,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "RG",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerSUS,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Carteira do SUS",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerDtnascimento,
                    autofocus: true,
                    keyboardType: TextInputType.datetime,
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Data de Nascimento",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerCEP,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      CepInputFormatter()
                    ],
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "CEP",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerEndereco,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Endereço",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerCidade,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Cidade",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerEstado,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Estado",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerEmail,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "E-mail",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    controller: _controllerSenha,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 16),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        _validaCampos();
                      }),
                ),
                Center(
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
