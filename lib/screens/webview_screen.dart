import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:telasapp/model/url.dart';
import 'package:telasapp/screens/listaurl.dart';
import 'package:telasapp/screens/tela_cadastro.dart';
import 'package:telasapp/screens/widgets/menu_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../util/UrlHelpers.dart';

class webview extends StatefulWidget {
  const webview({super.key});

  @override
  State<webview> createState() => _webviewState();
}

class _webviewState extends State<webview> {
  List<Url> listaurl = [];

  UrlHelpers db = UrlHelpers();

  var url = "";

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

  var flag = 0;
  var x = 0;
  Future delayedNumber() async {
    flag = 1;
    var i = 0;
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
    for (var item in produtosRecuperados) {
      Url obj = Url.fromMap(item);
      listaurl.add(obj);
      while (true) {
        if (x == 1) {
          break;
        }
        for (var u in listaurl) {
          controller.loadRequest(Uri.parse(u.nome));
          await Future.delayed(Duration(seconds: u.tempo));
        }
        // print(url);
      }
    }
  }

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    );
  // late var url;

  var urlController = TextEditingController();

  PullToRefreshController? pullToRefreshController;

  @override
  Widget build(BuildContext context) {
    if (flag == 0) {
      delayedNumber();
    }
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('home'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.play_arrow,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         delayedNumber();
      //         //         // do something
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(
      //         Icons.add,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         delayedNumber();
      //         // do something
      //       },
      //     )
      //   ],
      // ),
      drawer: menuDrawer(context),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }

  Widget menuDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(40),
            width: double.infinity,
            height: 200,
            color: Colors.blue,
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                  ),
                  Text("Gerenciar",
                      style: TextStyle(fontSize: 38, color: Colors.white)),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add_box_outlined),
            title: Text("Adicionar"),
            onTap: () {
              x = 1;
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TelaCadastro()));
            },
          ),
          ListTile(
            leading: Icon(Icons.play_arrow),
            title: Text("Play"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => webview()));
              x = 0;
              delayedNumber();
            },
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information_outlined),
            title: Text("Listar urls"),
            onTap: () {
              x = 1;
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Listaurl()));
            },
          ),
          ListTile(
            leading: Icon(Icons.restart_alt),
            title: Text("Atualizar"),
            onTap: () {
              x = 0;
              delayedNumber();
            },
          )
        ],
      ),
    );
  }
}
