import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text("WebView Page"),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Flexible(
                flex: 1,
                child: Container(
                  child: LinearProgressIndicator(
                    value: _progress,
                  ),
                )),
            Expanded(
              flex: 10,
              child: WebView(
                initialUrl: '1app.com.ng',
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (int progress) {
                  final progressIndouble = double.parse(progress.toString());

                  setState(() {
                    _progress = progressIndouble / 100;
                  });

                  print("WebView is loading (progress : $progress%)");
                },
                navigationDelegate: (NavigationRequest request) {
                  //the logic to redirect can be here to

                  if (request.url.contains("/login")) {
                    print('blocking navigation to $request}');
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }

                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  // https://accounts.1app.online/login
                  print('Page started loading: $url');

//it can also be here to
                  if (url.contains("/login")) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
