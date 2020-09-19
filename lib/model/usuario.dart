class Usuario {
  String _idUsuario;
  String _nome;
  String _cpf;
  String _rg;
  String _sus;
  String _dtnascimento;
  String _cep;
  String _endereco;
  String _cidade;
  String _estado;
  String _urlImage;
  String _email;
  String _senha;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "cpf": this.cpf,
      "rg": this.rg,
      "sus": this.sus,
      "dtnascimento": this.dtnascimento,
      "cep": this.cep,
      "endereco": this.endereco,
      "cidade": this.cidade,
      "estado": this.estado,
      "urlImage": this.urlImage,
      "email": this.email,
      "senha": this.senha,
      "urlImage": this.urlImage
    };

    return map;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get rg => _rg;

  set rg(String value) {
    _rg = value;
  }

  String get sus => _sus;

  set sus(String value) {
    _sus = value;
  }

  String get dtnascimento => _dtnascimento;

  set dtnascimento(String value) {
    _dtnascimento = value;
  }

  String get cep => _cep;

  set cep(String value) {
    _cep = value;
  }

  String get endereco => _endereco;

  set endereco(String value) {
    _endereco = value;
  }

  String get cidade => _cidade;

  set cidade(String value) {
    _cidade = value;
  }

  String get estado => _estado;

  set estado(String value) {
    _estado = value;
  }

  String get urlImage => _urlImage;

  set urlImage(String value) {
    _urlImage = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }
}
