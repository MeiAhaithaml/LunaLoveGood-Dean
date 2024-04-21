import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/admin/admin_upload_item.dart';
import 'package:lunalovegood/sign_in.dart';
import 'package:lunalovegood/sign_up.dart';
import 'package:http/http.dart' as http;

import 'package:lunalovegood/api_connection/api_connection.dart';


class SignInAdminPage extends StatefulWidget {
  const SignInAdminPage({Key? key}) : super(key: key);

  @override
  State<SignInAdminPage> createState() => _SignInAdminPageState();
}

class _SignInAdminPageState extends State<SignInAdminPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _AppBarWidget(),
              Text(
                'LunaLoveGood ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Đăng nhập',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.w800),
              ),
              _LoginWidget(),
              SizedBox(
                height: 127,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset('assets/back.svg')),
        ],
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  const _LoginWidget({Key? key}) : super(key: key);

  @override
  State<_LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<_LoginWidget> {
  bool isLoading = false;
  final dio = Dio();
  Color loginBarColor = Colors.grey;
  bool canNavigate = false;
  String responseData = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEmailValid = false;
  bool isPasswordValid = false;

  loginAdminNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.adminSignIn),
        body: {
          "user_email": emailController.text.trim(),
          "user_password": passwordController.text.trim()
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print('Response body for registration: $resBodyOfLogin');

        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: 'Dang nhap thanh cong');

          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(AdminUploadItems());
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Dang nhap khong thanh cong.Vui long xem lai mat khau hoac email");
        }
      }
      else{
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    } catch (errorMsg) {
      print("erro" + errorMsg.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {
        isEmailValid = emailController.text.isNotEmpty;
      });
    });

    passwordController.addListener(() {
      setState(() {
        isPasswordValid = passwordController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _inputField('Email', emailController),
              const SizedBox(
                height: 20,
              ),
              _inputField('Mật khẩu', passwordController, isPassword: true),
              const SizedBox(
                height: 20,
              ),
              Text(
                responseData,
                style: const TextStyle(fontSize: 13, color: Color(0xFFE57070)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 16,
              ),
              InkResponse(
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const AdminUploadItems(),
                      ),
                    ); // nho doi thanh cai khac
                  }
                },
                child: Container(
                  width: 298,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    color: isEmailValid && isPasswordValid
                        ? const Color(0xFF000000)
                        : Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              _bottomBarWidget(),
            ],
          );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    return Container(
      width: 298,
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Color(0xFFCBD5E1),
          width: 1,
        )),
      ),
      child: TextField(
        style: const TextStyle(color: Color(0XFF262626)),
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black12,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                )
              : null,
        ),
        obscureText: isPassword ? obscurePassword : false,
      ),
    );
  }

  Widget _bottomBarWidget() {
    return InkResponse(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const SignInPage(),
          ),
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
              text: TextSpan(
                  text: "Bạn không phải Admin?",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400),
                  children: const <TextSpan>[
                TextSpan(
                    text: ' Đăng nhập hoặc với tư cách người dùng',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))
              ])),
        ),
      ),
    );
  }
}
