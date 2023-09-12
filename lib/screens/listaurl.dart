import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:telasapp/model/url.dart';
import 'package:telasapp/screens/tela_cadastro.dart';
import 'package:telasapp/screens/webview_screen.dart';
import 'package:telasapp/screens/widgets/menu_drawer.dart';
import 'package:telasapp/util/UrlHelpers.dart';
import 'package:url_launcher/url_launcher.dart';

class Listaurl extends StatefulWidget {
  //const Listaurl({super.key});

  @override
  State<Listaurl> createState() => _ListaurlState();
}

class _ListaurlState extends State<Listaurl> {
  List<Url> listaurl = [];

  UrlHelpers db = UrlHelpers();

  void recuperarUrls() async {
    List produtosRecuperados = await db.listarProdutos();
    // debugPrint('Urls cadastradas' + produtosRecuperados.toString());
    List<Url> listatemporaria = [];
    for (var item in produtosRecuperados) {
      Url obj = Url.fromMap(item);
      listatemporaria.add(obj);

      setState(() {
        listaurl = listatemporaria;
      });
    }
  }

  void _launchLink(String url) async {
    await launch(url, forceWebView: true, forceSafariVC: true);
  }

  Future delayedNumber() async {
    List produtosRecuperados = await db.listarProdutos();
    // debugPrint('Urls cadastradas' + produtosRecuperados.toString());
    List<Url> listatemporaria = [];
    for (var item in produtosRecuperados) {
      Url obj = Url.fromMap(item);
      listatemporaria.add(obj);

      setState(() {
        listaurl = listatemporaria;
      });
    }
    var i = 0;
    while (true) {
      for (var item in produtosRecuperados) {
        Url obj = Url.fromMap(item);
        listaurl.add(obj);
        final Url u = listaurl[i];
        _launchLink(u.nome);
        await Future.delayed(Duration(seconds: u.tempo))
            .then((value) => {i++, closeWebView()});
      }
    }
  }

//remover url
  void removerUrl(int id) async {
    int resultado = await db.excluirurl(id);
    recuperarUrls();
  }

  void exibirtelaconfirma(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Excluir Url"),
            content: Text("Você tem certeza que deseja excluir esta url?"),
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                child: Text("SIM"),
                onPressed: () {
                  print("Voce apertou sim");
                  removerUrl(id);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.redAccent),
              ),
              TextButton(
                child: Text("Não"),
                onPressed: () {
                  print("Voce apertou nao");
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                    primary: Colors.white, backgroundColor: Colors.blueGrey),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    recuperarUrls();
  }

  @override
  Widget build(BuildContext context) {
    recuperarUrls();
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de url'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemCount: listaurl.length,
            itemBuilder: (context, index) {
              final Url u = listaurl[index];
              return Card(
                child: ListTile(
                  title: Text(
                    u.nome,
                  ),
                  subtitle: Text(u.tempo.toString() + " Minutos",
                      style: TextStyle(color: Colors.red)),
                  trailing: Wrap(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TelaCadastro(url: u)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(Icons.edit, color: Colors.blueGrey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          exibirtelaconfirma(u.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Icon(Icons.delete, color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
