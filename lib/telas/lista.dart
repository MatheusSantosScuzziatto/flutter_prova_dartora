import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prova1/model/quadrosintoma.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List _itens = [];
  List<QuadroSintoma> _quadros = List<QuadroSintoma>();

  @override
  void initState() {
    super.initState();
    _recuperaLista();
  }

  Future _recuperaLista() async {
    Firestore db =  Firestore.instance;
    QuerySnapshot querySnapshot = await db.collection("quadros").getDocuments();

    List<QuadroSintoma> listaTemporaria = List<QuadroSintoma>();
    for (DocumentSnapshot item in querySnapshot.documents) {
      var dados = item.data;
      QuadroSintoma quadro = QuadroSintoma();
      quadro.febre = dados["febre"];
      quadro.coriza = dados["coriza"];
      quadro.tosse = dados["tosse"];
      quadro.diarreia = dados["diarreia"];
      quadro.espirro = dados["espirro"];
      quadro.temperatura = dados["temperatura"];
      quadro.descricao = dados["descricao"];
      quadro.pressao = dados["pressao"];
      quadro.protocolo = dados["protocolo"];
      listaTemporaria.add(quadro);
    }
    setState(() {
      _quadros = listaTemporaria;
    });
    listaTemporaria = null;
    _carregarItens();
  }

  void _carregarItens() async {
    _itens = [];
    for(int i=0; i<_quadros.length; i++) {
      Map<String, dynamic> item = Map();
      item["id"] = "${_quadros[i].protocolo}";
      item["sintomas"] = "${_getSintomas(_quadros[i])}";
      item["temperatura"] = "${_quadros[i].temperatura}";
      item["pressao"] = "${_quadros[i].pressao}";
      item["descricao"] = "${_quadros[i].descricao}";
      setState(() {
        _itens.add(item);
      });
    }
  }

  String _getSintomas(QuadroSintoma quadro) {
    String ret = "Sintomas: ";
    if(quadro.febre == "TRUE") {
      ret += "febre; ";
    }
    if(quadro.coriza == "TRUE") {
      ret += "coriza; ";
    }
    if(quadro.tosse == "TRUE") {
      ret += "tosse; ";
    }
    if(quadro.diarreia == "TRUE") {
      ret += "diarreia; ";
    }
    if(quadro.espirro == "TRUE") {
      ret += "espirro; ";
    }
    return ret;
  }

  void _showDialog(Text conteudo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("PROTOCOLO"),
          content: conteudo,
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protocolos"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
        child: Center(
          child: ListView.builder(
            itemCount: _itens.length,
            itemBuilder: (context, indice) {
              return ListTile (
                title: Text(_itens[indice]["id"]),
                subtitle: Text(
                    _itens[indice]["sintomas"]
                ),
                contentPadding: EdgeInsets.all(9),
                onTap: () {
                  _showDialog(
                    new Text(
                    _itens[indice]["sintomas"]
                        +"\nTemperatura: "+ _itens[indice]["temperatura"]
                        +"\nDescrição: "+ _itens[indice]["descricao"]
                        +"\nPressão: "+ _itens[indice]["pressao"]
                    )
                  );
                },
              );
            }
          ),
        ),
      ),
    );
  }
}
