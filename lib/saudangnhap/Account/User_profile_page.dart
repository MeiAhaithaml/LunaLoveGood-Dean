import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/sign_in.dart';
import '../../api_connection/api_connection.dart';
import '../../model/customer_model.dart';
import '../../user_preferences/current_user.dart';
import 'package:http/http.dart' as http;
class UserProfilePageWidget extends StatefulWidget {
  const UserProfilePageWidget({Key? key,required this.customer}) : super(key: key);
  final CustomerModel customer;
  @override
  State<UserProfilePageWidget> createState() => _UserProfilePageWidgetState();
}

class _UserProfilePageWidgetState extends State<UserProfilePageWidget> {
  CurrentUser currentUserController = Get.find<CurrentUser>();


  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = currentUserController.user.user_name;
    phoneController.text = currentUserController.user.user_phone;
    addController.text = currentUserController.user.user_address;
  }
  Future<void> updateUserInfo(int userID, String userName, String userPhone, String userAddress) async {
    try {
      var res = await http.post(
        Uri.parse(API.updateUser),
        body: {
          "user_id": userID.toString(),
          "user_name": userName,
          "user_phone": userPhone,
          "user_address": userAddress,
        },
      );
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);
        if (resBody['success'] == true) {
          Fluttertoast.showToast(msg: "Thông tin đã được cập nhật thành công");
          Future.delayed(const Duration(microseconds: 2000), () {
            Get.to(const SignInPage());
          });
        } else {
          Fluttertoast.showToast(msg: "Lỗi: Không thể cập nhật thông tin");
        }
      } else {
        Fluttertoast.showToast(msg: "Lỗi: Không thể kết nối đến máy chủ");
      }
    } catch (e) {
      print('Lỗi: $e');
      Fluttertoast.showToast(msg: "Lỗi: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            children: [
              const AppBarWidget(),
              customer(),
              bottomBar()
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget customer(){
    return  Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _inputField(nameController, "Tên hiển thị *"),
          _inputField(phoneController, "Số điện thoại"),
          const SizedBox(height: 16.0),
          _inputField(addController, "Địa chỉ"),
          const SizedBox(height: 16.0),

        ],
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller,
      String name,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,style: const TextStyle(fontSize: 16,color: Color(0xFF595D5F)),),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextField(
                  style: const TextStyle(color: Color(0XFF262626)),
                  controller: controller,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black12,
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget bottomBar() {
    return InkResponse(
      onTap: () {
        int userID = currentUserController.user.user_id;
        String userName = nameController.text;
        String userPhone = phoneController.text;
        String userAddress = addController.text;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Xác nhận lưu thông tin"),
              content: Text("Bạn có muốn lưu thông tin đã chỉnh sửa không?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Hủy"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    updateUserInfo(userID, userName, userPhone, userAddress);
                  },
                  child: Text("Đồng ý"),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(3)),
            color: Color(0xFFFF8B8B),
          ),
          child: Center(
            child: Text(
              "Lưu lại",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
      child: Row(
        children: [
          InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset("assets/back.svg")),
          const SizedBox(width: 16,),
          const Text(
            "Thông tin cá nhân",
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF595D5F),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
