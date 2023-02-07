// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:splash_screen/Controller/services/service.my_service.dart';
import 'package:splash_screen/Controller/utils/util.custom_text.dart';
import 'package:splash_screen/consts/const.colors.dart';
import 'package:splash_screen/consts/const.data.bn.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsDialog extends StatefulWidget {
  const AboutUsDialog({Key? key}) : super(key: key);

  @override
  State<AboutUsDialog> createState() => _AboutUsDialogState();
}

class _AboutUsDialogState extends State<AboutUsDialog> {
  // final String url = 'https://AGAMiLabs.com';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: MyColors.pink1,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: 'About Us',
                  fontcolor: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontsize: 18,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: 'AGAMiLabs',
                      fontcolor: MyColors.pink1,
                      fontWeight: FontWeight.bold,
                      fontsize: 18,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.8,
                      color: Colors.black26,
                    ),
                    SizedBox(height: 16),
                    CustomText(
                      text: "Email: info@agamilabs.com",
                      fontcolor: MyColors.pink1,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Official Site:",
                          fontcolor: MyColors.pink1,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {

                            // _launchUrl();
                            MyServices.mLaunchUrl(MaaData.agami_web);
                          },
                          child: CustomText(
                            text: "AGAMiLabs.com",
                            fontcolor: MyColors.pink1,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Divider(
                      height: 0.5,
                      thickness: 0.8,
                      color: Colors.black26,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: MyColors.pink1,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: CustomText(
                            text: "বন্ধ করুন",
                            fontWeight: FontWeight.bold,
                            fontcolor: Colors.white))
                  ]),
            ),
          )
        ],
      ),
    );
  }

/*   void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  } */
}
