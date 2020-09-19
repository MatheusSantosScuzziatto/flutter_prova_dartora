class QuadroSintoma {
  String _idQuadroSintoma;
  String _protocolo;
  String _febre;
  String _diarreia;
  String _coriza;
  String _tosse;
  String _espirro;
  String _temperatura;
  String _pressao;
  String _descricao;

  QuadroSintoma();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "protocolo": this.protocolo,
      "febre": this.febre,
      "diarreia": this.diarreia,
      "coriza": this.coriza,
      "tosse": this.tosse,
      "espirro": this.espirro,
      "temperatura": this.temperatura,
      "pressao": this.pressao,
      "descricao": this.descricao,
    };

    return map;
  }

  String get idQuadroSintoma => _idQuadroSintoma;

  set idQuadroSintoma(String value) {
    _idQuadroSintoma = value;
  }

  String get protocolo => _protocolo;

  set protocolo(String value) {
    _protocolo = value;
  }

  String get febre => _febre;

  set febre(String value) {
    _febre = value;
  }

  String get diarreia => _diarreia;

  set diarreia(String value) {
    _diarreia = value;
  }

  String get coriza => _coriza;

  set coriza(String value) {
    _coriza = value;
  }

  String get tosse => _tosse;

  set tosse(String value) {
    _tosse = value;
  }

  String get espirro => _espirro;

  set espirro(String value) {
    _espirro = value;
  }

  String get temperatura => _temperatura;

  set temperatura(String value) {
    _temperatura = value;
  }

  String get pressao => _pressao;

  set pressao(String value) {
    _pressao = value;
  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }
}
