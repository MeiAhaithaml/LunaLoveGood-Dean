import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/saudangnhap/Account/setting_profile_page.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';
import 'package:lunalovegood/user_preferences/user_preferences.dart';

import '../../model/Brand_follow_model.dart';
import '../../model/best_sell_product_model.dart';
import '../../model/favorite_model.dart';
import '../../search/search_page.dart';
import '../../truocdangnhap/home_page_first.dart';
import '../Cart/cart_page.dart';
import '../purchase/history_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
  var resultResponse =  await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text("Đăng xuất"),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(3)),
                        border: Border.all(
                            width: 1, color: const Color(0xFFDCDCDC))),
                    child: const Center(
                        child: Text(
                      'Huỷ',
                      style: TextStyle(fontSize: 15, color: Color(0xFF595D5F)),
                    ))),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  Get.back(result: "DangXuat");
                },
                child: Container(
                    height: 40,
                    decoration: const BoxDecoration(
                        color: Color(0xFFFF8B8B),
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: const Center(
                        child: Text(
                      'Đồng ý',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ))),
              ),
            ),
          ],
        ),
      ],
    ));

  if(resultResponse == "DangXuat"){
    RememberUserPrefs.readUserInfo().then((value){
      Get.off(const HomePageFirst());
    });
    
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
                customerWidget("assets/user.png", _currentUser.user.user_name,
                    _currentUser.user.user_address),
                const SizedBox(
                  height: 16,
                ),
                const DiaryWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customerWidget(String image, String name, String email) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: ClipOval(
                  child: Image.asset(image, fit: BoxFit.fitWidth),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 215, child: Text(name)),
                  SizedBox(width: 215, child: Text(email)),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                child: InkResponse(
                  onTap: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SettingPageWidget(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFE8E8E8),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3))),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/setting.svg"),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("Cài đặt"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFE8E8E8),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(3))),
                  child: Center(
                    child:  InkWell(
                      onTap: (){
                        signOutUser();
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/log-off.svg"),
                            const SizedBox(
                              width: 8,
                            ),
                            const Text(
                              "Đăng xuất",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                    ),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/back.svg")),
            const SizedBox(
              width: 16,
            ),
            const Text(
              "Thông tin Account",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF595D5F),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            InkResponse(
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const SearchPage(),
                      ),
                    );
                  }
                },
                child: SvgPicture.asset('assets/Search.svg')),
            const SizedBox(width: 8,),
            InkResponse(
                onTap: () {
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const CartPage(),
                      ),
                    );
                  }
                },
                child: SvgPicture.asset('assets/shop_bag.svg')),
          ],
        )
      ]),
    );
  }
}

class DiaryWidget extends StatefulWidget {
  const DiaryWidget({Key? key}) : super(key: key);

  @override
  State<DiaryWidget> createState() => _DiaryWidgetState();
}

class _DiaryWidgetState extends State<DiaryWidget> {
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      child: InkResponse(
        onTap: () {
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) =>  HistoryScreen(),
              ),
            );
          }
        },
        child: Text(
          "Nhật ký mua hàng ",
          style: TextStyle(fontSize: 16, color: Color(0xFF5A5A5A)),
        ),
      ),
    );
  }
}

