import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5/'];

class WebView extends StatefulWidget{
  final String url;
  final String? statusBarColor;
  final String? title;
  final bool? hideAppBar;
  final bool backForbid;

  WebView({required this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid=false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView>{
  final webviewReference = FlutterWebviewPlugin();
  late StreamSubscription<String> _onUrlChanged;
  late StreamSubscription<WebViewStateChanged> _onStateChanged;
  late StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;//没有可返回界面

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url){});
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state){
      switch (state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {//页面已设为禁止返回
              webviewReference.launch(widget.url);//重新加载
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error){
      print(error);
    });
  }

  _isToMain(String url){
    bool contain = false;
    for(final value in CATCH_URLS) {
      if (url.endsWith(value)) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();//页面销毁， 这个方法之前执行上面的几个方法
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
print(statusBarColorStr);
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(
                color: Colors.white,
                child: Center(
                  child: Text('Waiting...'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor){
    if (widget.hideAppBar != null) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(//充满屏幕宽度
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close, color:backgroundColor, size:26),
              ),
            ),
            Positioned(
              left:0,
              right:0,
              child: Center(
                child: Text(widget.title??'Title', style: TextStyle(
                  color: backgroundColor,
                  fontSize: 20,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}