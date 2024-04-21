import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:lunalovegood/sign_in.dart';
import 'api_connection/api_connection.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _AppBarWidget(),
              Text(
                'LunaLoveGood',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                'Đăng ký',
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
  bool isPhoneNumberValid(String input) {
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    return phoneRegExp.hasMatch(input);
  }
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var addressController = TextEditingController();
  var isObsecure = true.obs;
  validateEmail() async {
    try {

      var res = await http.post(Uri.parse(API.validateEmail), body: {
        'user_phone': phoneController.text.trim(),
      });
      print('API response: $res');
      print('API : ${res.body}');
      print('API : ${res.toString()}');


      if (res.statusCode == 200)
          {
        var resBody = jsonDecode(res.body);
        print('Response body: $resBody');

        if (resBody['emailFound'] == true) {
          Fluttertoast.showToast(
              msg:
              "So dien thoai da duoc su dung. Vui long su dung so dien thoai khac de dang ky");
        } else {
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print('Error in validateEmail: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel = User(
        1,
        nameController.text.trim(),
        phoneController.text.trim(),
        addressController.text.trim(),
        passwordController.text.trim());
    try{
      var res = await http.post(Uri.parse(API.signUp),
        body: userModel.toJson(),
      );
      print('API response for registration: $res');

      if(res.statusCode ==  200){
        var resBodyOfSignUp = jsonDecode(res.body);
        print('Response body for registration: $resBodyOfSignUp');

        if(resBodyOfSignUp['success']== true)
        {
          Fluttertoast.showToast(msg: 'Dang ky thanh cong');
          setState(() {
            nameController.clear();
            phoneController.clear();
            passwordController.clear();
            addressController.clear();
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Dang ky khong thanh cong");
        }
      }
      else{
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    }
    catch(e){
      print( e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [

                    //name
                    TextFormField(
                      controller: nameController,
                      validator: (val) =>
                      val == ""
                          ? "Vui lòng điền tên"
                          : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                        hintText: "Tên...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 18,),

                    //email
                    TextFormField(
                      controller: phoneController,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Vui lòng điền số điện thoại";
                        }
                        final phoneRegExp = RegExp(r'^[0-9]{10}$');
                        if (!phoneRegExp.hasMatch(val)) {
                          return "Số điện thoại không hợp lệ";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.black,
                        ),
                        hintText: "0123456789",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),


                    const SizedBox(height: 18,),

                    const SizedBox(height: 18,),

                    //password
                    Obx(
                          () =>
                          TextFormField(
                            controller: passwordController,
                            obscureText: isObsecure.value,
                            validator: (val) =>
                            val == ""
                                ? "Vui lòng điền mật khẩu"
                                : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.vpn_key_sharp,
                                color: Colors.black,
                              ),
                              suffixIcon: Obx(
                                    () =>
                                    GestureDetector(
                                      onTap: () {
                                        isObsecure.value =
                                        !isObsecure.value;
                                      },
                                      child: Icon(
                                        isObsecure.value ? Icons
                                            .visibility_off : Icons
                                            .visibility,
                                        color: Colors.black,
                                      ),
                                    ),
                              ),
                              hintText: "Mật khẩu...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                    ),

                    const SizedBox(height: 18,),
                    TextFormField(
                      controller: addressController,
                      validator: (val) =>
                      val == ""
                          ? "Vui lòng điền địa chỉ "
                          : null,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.map,
                          color: Colors.black,
                        ),
                        hintText: "Địa chỉ...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white60,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 18,),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFF37474),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            validateEmail();
                          }
                        },
                        borderRadius: BorderRadius.circular(15),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 28,
                          ),
                          child: Center(
                            child: Text(
                              "Đăng ký",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      "Đã có tài khoản?",style: const TextStyle(fontSize: 16,color: Color(0xFF555454)),
                  ),
                  InkResponse(
                    onTap: () {
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const SignInPage(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      " Đăng nhập",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }
  }


