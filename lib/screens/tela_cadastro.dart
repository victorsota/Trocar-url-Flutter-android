import 'package:flutter/material.dart';
import 'package:telasapp/model/url.dart';
import 'package:telasapp/screens/listaurl.dart';
import 'package:telasapp/screens/webview_screen.dart';
import 'package:telasapp/util/UrlHelpers.dart';

class TelaCadastro extends StatefulWidget {
  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
  Url? url;

  TelaCadastro({this.url});
}

class _TelaCadastroState extends State<TelaCadastro> {
  TextEditingController txtnome = TextEditingController();
  TextEditingController txttempo = TextEditingController();

  UrlHelpers db = UrlHelpers();

  late int idurl;

  void salvarUrl({Url? url}) async {
    int resultado;
    if (url == null) {
      //1 criar objeto model
      Url obj = Url.nome(txtnome.text, int.parse(txttempo.text));
      resultado = await db.cadastrarUrl(obj);

      if (resultado != null) {
        print("cadastrado com sucesso");
      }
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => webview())));
    } else {
      url.nome = txtnome.text;
      url.id = idurl;
      url.tempo = int.parse(txttempo.text);

      resultado = await db.alterarurl(url);
      Navigator.push(
          context, MaterialPageRoute(builder: ((context) => webview())));
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.url != null) {
      txtnome.text = widget.url!.nome;
      txttempo.text = widget.url!.tempo.toString();

      idurl = widget.url!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar url'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  controller: txtnome,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "url"),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: txttempo,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: "Tempo"),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("Salvar"),
                      onPressed: () {
                        salvarUrl(url: widget.url);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                    ))
              ],
            )),
      )),
    );
  }
}
