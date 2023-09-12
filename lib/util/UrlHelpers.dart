import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/url.dart';

class UrlHelpers {
//Atributos da classe
  static Database? _database;

//estrutura da tabela

  String nomeTabela = 'tb_url';

  String colunaId = 'id';
  String colunaNome = 'nome';
  String colunaTempo = 'tempo';

// 1 passo - Cria bd

  void _criarbanco(Database db, int version) async {
    String sql = """CREATE TABLE $nomeTabela(
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaNome text,
          $colunaTempo integer
    )
  """;
    await db.execute(sql);
  }

// 2 iniciar bd
  Future<Database> inicializaBanco() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String caminho = directory.path + 'bdurls.bd';

    var bancodedados =
        await openDatabase(caminho, version: 1, onCreate: _criarbanco);

    return bancodedados;
  }

// 3 verificar banco criado
  Future<Database> get database async => _database ??= await inicializaBanco();

  //crud

  Future<int> cadastrarUrl(Url obj) async {
    //1
    Database db = await this.database;
    var resposta =
        db.insert(nomeTabela, {'nome': obj.nome, 'tempo': obj.tempo});

    return resposta;
  }

  // metodo listar urls

  listarProdutos() async {
    Database db = await this.database;

    //comando sql
    String sql = "select * from $nomeTabela ";

    // criar lista para armazernar itens e executar comandos
    List lista = await db.rawQuery(sql);

    // retornar essa lista
    return lista;
  }

  // Método Excluir url
  Future<int> excluirurl(int id) async {
    //1
    Database db = await this.database;

    var resultado =
        await db.delete(nomeTabela, where: "id = ?", whereArgs: [id]);
    return resultado;
  }

  // Método Alterar url

  Future<int> alterarurl(Url obj) async {
    //1
    Database db = await database;

    var resultado = await db
        .update(nomeTabela, obj.toMap(), where: "id = ?", whereArgs: [obj.id]);

    return resultado;
  }
}
