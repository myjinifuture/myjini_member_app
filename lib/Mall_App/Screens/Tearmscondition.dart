import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TearmsCon extends StatefulWidget {
  var tearmscondition, title;
  TearmsCon({this.tearmscondition, this.title});
  @override
  _TearmsConState createState() => _TearmsConState();
}

class _TearmsConState extends State<TearmsCon> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.title}",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: WebView(
          initialUrl: "${widget.tearmscondition}",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webviewController) {
            _controller.complete(webviewController);
          }),
    );
  }
}
