import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TearmsLogin extends StatefulWidget {
  var tearmsData;
  TearmsLogin({this.tearmsData});

  @override
  _TearmsLoginState createState() => _TearmsLoginState();
}

class _TearmsLoginState extends State<TearmsLogin> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Tearms & Condition",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: WebView(
          initialUrl: "${widget.tearmsData}",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webviewController) {
            _controller.complete(webviewController);
          }),
    );
  }
}
