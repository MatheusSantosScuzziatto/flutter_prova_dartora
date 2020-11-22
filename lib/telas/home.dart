import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_prova1/model/quadrosintoma.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _position = CameraPosition(target: LatLng(-24.720739, -53.713464), zoom: 10);
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  TextEditingController _controllerDssintomas = TextEditingController();
  TextEditingController _controllerPressao = TextEditingController();

  bool _febre = false;
  bool _diarreia = false;
  bool _coriza = false;
  bool _tosse = false;
  bool _espirro = false;

  String _label = "0";
  double _temperatura = 0;
  String _mensagemErro = "";

  String _idUsuarioLogado;
  List<File> _imagens = new List<File>();
  bool _subindoImagem = false;
  String _labelimagens = "Adicione imagens para upload";

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    _recuperarLocalizacao();
  }

  _onMapCreate(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _recuperarLocalizacao() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final Marker marker = Marker(
      markerId: MarkerId("marker"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Posicao: '+position.latitude.toString() +' - '+ position.longitude.toString()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    setState(() {
      _position = CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 10);
      markers[MarkerId("marker")] = marker;
    });
  }

  _validaCampos() async {
    String _dssintomas = _controllerDssintomas.text.toString();
    String _pressao = _controllerPressao.text.toString();

    if(_febre || _diarreia || _coriza || _tosse || _espirro) {
      if(_temperatura > 0.00) {
        setState(() {
          _mensagemErro = "";
        });
        QuadroSintoma quadro = QuadroSintoma();
        quadro.protocolo = _idUsuarioLogado.toString() + "_" + DateTime.now().toString();
        quadro.febre = _febre ? "TRUE" : "FALSE";
        quadro.diarreia = _diarreia ? "TRUE" : "FALSE";
        quadro.coriza = _coriza ? "TRUE" : "FALSE";
        quadro.tosse = _tosse ? "TRUE" : "FALSE";
        quadro.espirro = _espirro ? "TRUE" : "FALSE";
        quadro.temperatura = _temperatura.toString();
        quadro.pressao = _pressao;
        quadro.descricao = _dssintomas;
        await _cadastrarQuadroSintoma(quadro);
        setState(() {
          _mensagemErro = "Protocolo Enviado!";
        });
      } else {
        setState(() {
          _mensagemErro = "Informe a Temperatura!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Informe um Sintôma!";
      });
    }
  }

  _cadastrarQuadroSintoma(QuadroSintoma quadro) async {
    Firestore db = Firestore.instance;
    db.collection("quadros").add({
      "protocolo": quadro.protocolo,
      "febre": quadro.febre,
      "diarreia": quadro.diarreia,
      "coriza": quadro.coriza,
      "tosse": quadro.tosse,
      "espirro": quadro.espirro,
      "temperatura": quadro.temperatura,
      "pressao": quadro.pressao,
      "descricao": quadro.descricao,
    });
    await _uploadImagem();
  }

  Future _capturarImagem(String origemImagem) async {
    File imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        break;
    }

    if (imagemSelecionada != null) {
      _imagens.add(imagemSelecionada);
    }

    setState(() {
      _labelimagens = _imagens.length.toString() + " Imagens para upload";
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    int id_imagem = 1;

    _imagens.forEach((_imagem) {
      StorageReference arquivo = storage.ref().child("quadros").child("imagens").child(_idUsuarioLogado + "_" + id_imagem.toString() + ".jpg");
      id_imagem++;

      //Upload da imagem
      StorageUploadTask task = arquivo.putFile(_imagem);

      //Controlar progresso do upload
      task.events.listen((StorageTaskEvent storageEvent) {
        if (storageEvent.type == StorageTaskEventType.progress) {
          setState(() {
            _subindoImagem = true;
          });
        } else if (storageEvent.type == StorageTaskEventType.success) {
          setState(() {
            _subindoImagem = false;
          });
        }
      });
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();

    _idUsuarioLogado = usuarioLogado.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
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
                  padding: EdgeInsets.all(20),
                  child: Text("Sintômas", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                CheckboxListTile(
                    title: Text("Febre"),
                    activeColor: Colors.red,
                    secondary: Icon(Icons.add_box, color: Colors.black,),
                    value: _febre,
                    onChanged: (bool valor) {
                      setState(() {
                        _febre = valor;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Diarreia"),
                    activeColor: Colors.red,
                    secondary: Icon(Icons.add_box, color: Colors.black,),
                    value: _diarreia,
                    onChanged: (bool valor) {
                      setState(() {
                        _diarreia = valor;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Coriza"),
                    activeColor: Colors.red,
                    secondary: Icon(Icons.add_box, color: Colors.black,),
                    value: _coriza,
                    onChanged: (bool valor) {
                      setState(() {
                        _coriza = valor;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Tosse"),
                    activeColor: Colors.red,
                    secondary: Icon(Icons.add_box, color: Colors.black,),
                    value: _tosse,
                    onChanged: (bool valor) {
                      setState(() {
                        _tosse = valor;
                      });
                    }),
                CheckboxListTile(
                    title: Text("Espirro"),
                    activeColor: Colors.red,
                    secondary: Icon(Icons.add_box, color: Colors.black,),
                    value: _espirro,
                    onChanged: (bool valor) {
                      setState(() {
                        _espirro = valor;
                      });
                    }),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Temperatura", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Slider(
                    value: _temperatura,
                    min: 0,
                    max: 50,
                    label: _label,
                    divisions: 100,
                    activeColor: Colors.red,
                    inactiveColor: Colors.black,
                    onChanged: (double novoValor){
                      setState(() {
                        _temperatura = novoValor;
                        _label = novoValor.toString();
                      });
                    }),

                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerPressao,
                    autofocus: false,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Pressão Arterial",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    controller: _controllerDssintomas,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        hintText: "Descreva o que sente",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Localização Atual", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  height: 300,
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _position,
                      onMapCreated: _onMapCreate,
                      markers: Set<Marker>.of(markers.values)
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(_labelimagens, textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        _capturarImagem("camera");
                      },
                      child: Text("Câmera"),
                    ),
                    FlatButton(
                      onPressed: () {
                        _capturarImagem("galeria");
                      },
                      child: Text("Galeria"),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 16),
                  child: RaisedButton(
                      child: Text(
                        "Enviar",
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

                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 16),
                  child: RaisedButton(
                      child: Text(
                        "Conversar com o Médico",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/mensagens");
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 16),
                  child: RaisedButton(
                      child: Text(
                        "Consultar Protocolos",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: Colors.red,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/lista");
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
