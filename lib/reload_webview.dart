import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:math' as math;

class ReloadWebview extends StatefulWidget {
  @override
  _ReloadWebviewState createState() => _ReloadWebviewState();
}

class _ReloadWebviewState extends State<ReloadWebview>
    with TickerProviderStateMixin {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  AnimationController _animationController;

  static const List<IconData> icons = const [
    Icons.fullscreen,
    Icons.share,
    Icons.file_download,
    Icons.refresh
  ];

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
        appBar: AppBar(
          title: Text("Reload webview in flutter"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {},
            )
          ],
        ),
        body: WebView(
          initialUrl: 'https://www.dropbox.com/pt_BR/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
        floatingActionButton: FutureBuilder<WebViewController>(
            future: _controller.future,
            builder: (BuildContext context,
                AsyncSnapshot<WebViewController> controller) {
              if (controller.hasData) {
                return new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: new List.generate(icons.length, (int index) {
                    Widget child = new Container(
                      height: 70.0,
                      width: 56.0,
                      alignment: FractionalOffset.topCenter,
                      child: new ScaleTransition(
                        scale: new CurvedAnimation(
                          parent: _animationController,
                          curve: new Interval(
                              0.0, 1.0 - index / icons.length / 2.0,
                              curve: Curves.easeOut),
                        ),
                        child: new FloatingActionButton(
                          heroTag: null,
                          backgroundColor: backgroundColor,
                          mini: true,
                          child: new Icon(icons[index], color: foregroundColor),
                          onPressed: () async {
                            if (icons[index] == Icons.refresh) {
                              controller.data.reload();
                            }
                            _animationController.reverse();
                          },
                        ),
                      ),
                    );
                    return child;
                  }).toList()
                    ..add(
                      new FloatingActionButton(
                        heroTag: null,
                        child: new AnimatedBuilder(
                          animation: _animationController,
                          builder: (BuildContext context, Widget child) {
                            return new Transform(
                              transform: new Matrix4.rotationZ(
                                  _animationController.value * 0.5 * math.pi),
                              alignment: FractionalOffset.center,
                              child: new Icon(_animationController.isDismissed
                                  ? Icons.menu
                                  : Icons.close),
                            );
                          },
                        ),
                        onPressed: () {
                          if (_animationController.isDismissed) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }
                        },
                      ),
                    ),
                );
              }
              return Container();
            }));
  }
}
