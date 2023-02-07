// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splash_screen/consts/const.data.bn.dart';

class SlideTile0 extends StatefulWidget {
  final FocusNode focusNode1;
  final FocusNode focusNode2;
  const SlideTile0(
      {Key? key, required this.focusNode1, required this.focusNode2})
      : super(key: key);

  @override
  State<SlideTile0> createState() => _SlideTile0State();
}

class _SlideTile0State extends State<SlideTile0> with TickerProviderStateMixin {
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  late TextEditingController _editingControllerEmail = TextEditingController();
  TextEditingController _editingControllerPhone = TextEditingController();
  String? userName;
  String? email;
  late final SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    // mShowDialog();
    _focusNode1 = widget.focusNode1;
    _focusNode2 = widget.focusNode2;

    mLoadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 48),
      // margin: EdgeInsets.only(top: 32),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // v: part 1
          Expanded(
              flex: 2,
              child: Container(
                // decoration: const BoxDecoration(color: Colors.blue),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        // v: Logo
                        Expanded(
                            child: Image(
                          image: AssetImage(
                              "lib/assets/images/firstscreenlogo.png"),
                          fit: BoxFit.cover,
                        ))
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // v: text 1
                        const Text(
                          MaaData.welcome,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 48,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // v: text 2
                        Text(
                          userName ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ],
                    ))
                  ],
                ),
              )),
          // v: part 2
          Expanded(
              flex: 3,
              child: Container(
                // decoration: const BoxDecoration(color: Colors.red),
                // padding: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // v: Email Edittext
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: _editingControllerEmail,
                                    focusNode: _focusNode1,
                                    /*  onFieldSubmitted: (value) {
                                      _focusNode2.requestFocus();
                                    }, */
                                    readOnly: true,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      // label: const Text("Email address"),
                                      labelText: "Email",
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ))
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              // v: Phone Edittext
                              Row(
                                children: [
                                  Expanded(
                                      child: TextFormField(
                                    controller: _editingControllerPhone,
                                    focusNode: _focusNode2,
                                    /*   onFieldSubmitted: (value) {
                                      _focusNode1.requestFocus();
                                    }, */
                                    onChanged: (value) {
                                      sharedPreferences.setString(
                                          "phone", value);
                                    },
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(

                                        // alignLabelWithHint: true,
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        prefixIcon: const Icon(
                                          Icons.phone,
                                          color: Colors.white,
                                        ),
                                        // label: const Text("Email address"),
                                        labelText: "Phone",
                                        labelStyle:
                                            const TextStyle(color: Colors.white)
                                        /* labelStyle: TextStyle(
                                          fontSize: _focusNode.hasFocus
                                              ? 24
                                              : 18.0, //I believe the size difference here is 6.0 to account padding
                                          color: _focusNode.hasFocus
                                              ? Colors.blue
                                              : Colors.white), */
                                        ),
                                  )),
                                ],
                              )
                            ],
                          ),
                        )

                        /* Expanded(
                            child: Container(
                          color: Colors.yellow,
                        )) */
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void mLoadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("username")!;
      email = sharedPreferences.getString("email")!;
      _editingControllerEmail = TextEditingController(text: email ?? "");
    });

    // setState(() {});
  }

  void mShowDialog() {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: const Center(
        child: Text(
          'Please sign in with google account',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      title: 'This is Ignored',
      desc: 'This is also Ignored',
      btnOkOnPress: () {},
    ).show();
  }
}
