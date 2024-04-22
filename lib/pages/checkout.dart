import 'package:dhile/controller/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckOutPage extends StatefulWidget {
  final String initialUrl;

  const CheckOutPage({super.key, required this.initialUrl});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  // late WebViewController _webViewController;
  BookController bookController = BookController();
  @override
  Widget build(BuildContext context) {
    WebViewController  controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('thankYou')) {
              // Get.offAllNamed('/confirm',arguments: [link.pathSegments[1]]);
              var link =Uri.parse(request.url).pathSegments[1];
              bool result = await bookController.confirmPay(link);
              if(result==true) {
                Get.offAllNamed("/thank");
              }
              return NavigationDecision.prevent;
            }else if(request.url.contains('payFail')){
              Get.offAllNamed('/fail');
              return NavigationDecision.prevent;
            }
           return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    
    return Scaffold(
      body:WebViewWidget(controller: controller,),
    );
  }
}
