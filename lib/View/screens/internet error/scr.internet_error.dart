import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen/View/widgets/dot_blink_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../Controller/services/service.my_service.dart';
import '../../../Controller/utils/util.custom_text.dart';
import '../../../consts/const.colors.dart';
import '../../../consts/const.data.bn.dart';

class InternetErrorScreen extends StatefulWidget {
  const InternetErrorScreen({Key? key}) : super(key: key);

  @override
  State<InternetErrorScreen> createState() => _InternetErrorScreenState();
}

class _InternetErrorScreenState extends State<InternetErrorScreen> {
  bool isChecking = true;
  bool isLoading = true;
  WebViewController? controller;
  @override
  void initState() {
    super.initState();
    mWebViewController();
    mCheckConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return isChecking && controller != null
        ? Scaffold(
            body: Stack(
              children: <Widget>[
                WebViewWidget(
                  controller: controller!,
                ),
                isLoading
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DotBlickLoader(),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Please wait...",
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        ),
                      )
                    : const Stack(),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: MyColors.pink2,
              title: const CustomText(
                text: "Connection Error",
                fontcolor: MyColors.textOnPrimary,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                fontsize: 24,
              ),
            ),
            body: vWarning(),
          );
  }

  void mCheckConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      setState(() {
        isChecking = false;
      });
    }
  }

  Widget vWarning() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            isChecking = true;
            isLoading = true;
          });

          mCheckConnectivity();
          mWebViewController();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            vCard(),
            const SizedBox(
              height: 16,
            ),
            vRetry(),
          ],
        ),
      ),
    );
  }

  Widget vCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: MyColors.pink4),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(1, 1), blurRadius: 5.0)
          ]),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 48,
            color: MyColors.pink4,
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "No Internet",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: MyColors.pink4),
          )
        ],
      ),
    );
  }

  Widget vRetry() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.refresh,
          size: 32,
          color: Colors.black54,
        ),
        SizedBox(
          width: 12,
        ),
        Text(
          "Retry",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45),
        )
      ],
    );
  }

  Widget vLoading() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DotBlickLoader(),
        SizedBox(
          height: 8,
        ),
        Text(
          "Please wait",
          style: TextStyle(color: Colors.black54),
        )
      ],
    );
  }

  void mWebViewController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            // const  DotBlickLoader();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          /*  onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            }, */
        ),
      )
      ..loadRequest(Uri.parse(MaaData.baby_shop));
  }
}
