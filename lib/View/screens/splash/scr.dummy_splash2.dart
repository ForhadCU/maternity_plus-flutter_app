import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splash_screen/Controller/utils/util.my_scr_size.dart';
import 'package:splash_screen/View/screens/sign%20in/scr.sign_in.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class SecondSplashScreen extends StatelessWidget {
  const SecondSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.pink2,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: MyColors.pink2,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: MyColors.pink2,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light)),
      body: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const SignInScreen();
                }));
              },
              style: ElevatedButton.styleFrom(
                elevation: 4,
                backgroundColor: MyColors.pink2,
              ),
              child: Row(
                children: const [
                  Text(
                    "শুরু করুন",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.textOnPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "lib/assets/images/firstscreenlogo.png",
                    height: MyScreenSize.mGetHeight(context, 36),
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  const Text(MaaData.welcome,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: MyColors.textOnPrimary))
                ],
              ),
            ),
          ),

          // child: ,
        ],
      ),
    );
  }
}
