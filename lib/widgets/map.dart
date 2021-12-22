import 'package:courier_app/providers/functionality.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const type = 'navigation';
    final courierId =
        Provider.of<Functionality>(context, listen: false).courierId;

    final Future<String> token =
        Provider.of<Functionality>(context, listen: false).mapToken;

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      color: Colors.teal,
      child: SafeArea(
        child: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useOnDownloadStart: true,
              javaScriptCanOpenWindowsAutomatically: true,
              javaScriptEnabled: true,
              useShouldOverrideUrlLoading: true,
            ),
            ios: IOSInAppWebViewOptions(
              sharedCookiesEnabled: true,
            ),
          ),
          initialFile: 'assets/map_view/index.html',
          onWebViewCreated: (InAppWebViewController controller) {
            controller.addJavaScriptHandler(
                handlerName: 'navigationHandler',
                callback: (args) async {
                  final tokenVal = await token;
                  return {
                    "type": type,
                    "id": courierId,
                    "isLocalDev": kDebugMode,
                    "token": tokenVal
                  };
                });
          },
          onConsoleMessage: (controller, message) {
            // ignore: avoid_print
            print(message);
          },
          onDownloadStart: (controller, string) {},
        ),
      ),
    );
  }
}
