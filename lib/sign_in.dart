import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/admin/login_admin_page.dart';
import 'package:lunalovegood/model/customer_model.dart';
import 'package:lunalovegood/saudangnhap/bottom_bar.dart';
import 'package:lunalovegood/saudangnhap/home_page_second.dart';
import 'package:lunalovegood/sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:lunalovegood/user_preferences/user_preferences.dart';

import 'api_connection/api_connection.dart';
import 'model/user_model.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEmailValid = false;
  bool isPasswordValid = false;

  loginUserNow() async {
    try{
      var res = await http.post(
        Uri.parse(API.signIn),
        body: {
          "user_phone": phoneController.text.trim(),
          "user_password": passwordController.text.trim()
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        print('Response body for registration: $resBodyOfLogin');
        print('Response body for registration: ${resBodyOfLogin.toString()}');


        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: 'Dang nhap thanh cong');
          User userInfo = User.fromJson(resBodyOfLogin["userData"]);
          await RememberUserPrefs.storeUserInfo(userInfo);

          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(const NavigationMenu());
          });
        } else {
          Fluttertoast.showToast(
              msg:
              "Dang nhap khong thanh cong.\n Vui long xem lai mat khau hoac email");
        }
      }
      else{
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    }
    catch(errorMsg){
      print("erro" + errorMsg.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {
        isEmailValid = phoneController.text.isNotEmpty;
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
    phoneController.dispose();
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
              _inputField('Số điện thoại', phoneController),
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
              InkWell(
                onTap: () {
                  loginUserNow();
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
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 0.5,
                      color: const Color(0xFF585858),
                    ),
                    const Text(
                      " hoặc ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    InkResponse(
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const SignInAdminPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 0.5,
                        color: const Color(0xFF585858),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              InkResponse(
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SignInAdminPage(),
                      ),
                    );
                  }
                },
                child: const Text("Đăng nhập với tư  cách Admin", style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 120,
                      height: 0.5,
                      color: const Color(0xFF585858),
                    ),
                    const Text(
                      " hoặc ",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    InkResponse(
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const SignInAdminPage(),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 0.5,
                        color: const Color(0xFF585858),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
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
            builder: (ctx) => const SignUpPage(),
          ),
        );
      },
      child: Center(
        child: RichText(
            text: TextSpan(
                text: "Chưa có Tài khoản?",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400),
                children: const <TextSpan>[
              TextSpan(
                  text: '  Đăng ký ngay',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500))
            ])),
      ),
    );
  }
}
