import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_dapoer/pages/login.dart';
import 'package:warung_dapoer/utils/api_url.dart';

import '../widget/bezierContainer.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _emailCon = TextEditingController(text: "");
  TextEditingController _passCon = TextEditingController(text: "");
  TextEditingController _namaCon = TextEditingController(text: "");

  void register(String nama, email, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // cek inputan kosong apa tidak
    if (email != '' && password != '') {
      if (email.contains("@")) {
        final body = {
          'email': email,
          'password': password,
          'name': nama,
        };
        var url = "$base_url/auth/register";
        final header = {"Accept": "application/json"};
        http.Response response = await http.post(Uri.parse(url),
            body: body, headers: header, encoding: Encoding.getByName("utf-8"));
        // print(response.body);
        if (response.statusCode == 200) {
          Get.to(const Login());
        }
        // LoginUserProvider().loginUser(email, password).then((value) {
        //   // validasi response berhasil apa tidak
        //   // isLoading = false;
        //   if (value.statusCode == 200) {
        //     // simpan ke sharedPreferences
        //     prefs.setString('uuid', '${value.body['data']['user']['uuid']}');
        //     prefs.setString('nama', '${value.body['data']['user']['nama']}');
        //     prefs.setString('no_hp', '${value.body['data']['user']['no_hp']}');
        //     prefs.setString('email', '${value.body['data']['user']['email']}');
        //     prefs.setString(
        //         'role_id', '${value.body['data']['user']['role_id']}');
        //     prefs.setString('token', '${value.body['data']['token']}');
        //     if (value.body['data']['user']['role_id'] == 1) {
        //       // isLoading = true;
        //       Get.offAll(const HomePage());
        //       // SnackBarWidget().snackBarSuccess("CUSTOMER");
        //     } else {
        //       Get.offAll(const HomeServiceAdvisor());
        //       // SnackBarWidget().snackBarSuccess("SERVICE ADVISOR");
        //     }
        //   }
        //   print(value.body);
        // });
      }
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Get.off(Login());
      },
      child: Container(
        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
        child: Icon(CupertinoIcons.left_chevron, color: Colors.black),
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
      child: Text(
        'Register',
        style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('atau'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'd',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xffe46b10)),
          children: [
            TextSpan(
              text: 'ev',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'rnz',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(height: 50),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nama',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _namaCon,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _emailCon,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                            controller: _passCon,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      register(_namaCon.text, _emailCon.text, _passCon.text);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xfffbb448), Color(0xfff7892b)])),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }
}
