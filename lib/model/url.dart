class Url {
//Atributos

  int id = -1;
  String nome;
  int tempo;

//Construtor

  Url(this.id, this.nome, this.tempo);
  Url.nome(this.nome, this.tempo);

  // Urls.teste(this.nome, this.tempo) {
  //   id = 0;
  // }

//Metodo

  Map<String, dynamic> toMap() {
    var dados = Map<String, dynamic>();
    dados['id'] = id;
    dados['nome'] = nome;
    dados['tempo'] = tempo;

    return dados;
  }

  deMapParaModel(Map<String, dynamic> dados) {
    this.id = dados['id'];
    this.nome = dados['nome'];
    this.tempo = dados['tempo'];
  }

  static Url fromMap(Map<String, dynamic> map) {
    var u = Url(map['id'], map['nome'], map['tempo']);
    return u;
  }
}
