import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/model/best_sell_product_model.dart';
import 'package:lunalovegood/model/favorite_model.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';

import '../../api_connection/api_connection.dart';
import '../../model/favorite_logic.dart';
import '../../model/whishlist_model.dart';
import '../../search/search_page.dart';
import '../home_page_second.dart';
import 'package:http/http.dart'as http;

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
final currentOnlineUser = Get.put(CurrentUser());
Future<List<FavoriteProductModel>> getCurrentUserFavoriteList() async {
  List<FavoriteProductModel> favoriteListOfCurrentUser = [];
  try {
    var res = await http.post(Uri.parse(API.readFavoriteProduct), body: {
      "user_id": currentOnlineUser.user.user_id.toString()
    });
    if (res.statusCode == 200) {
      print(res.toString());
      var resBodyOfGetCurrentUserFavoriteProduct = jsonDecode(res.body);
      if (resBodyOfGetCurrentUserFavoriteProduct['success'] == true) {
        (resBodyOfGetCurrentUserFavoriteProduct['currentUserFavoriteData'] as List)
            .forEach((eachCurrent) {
          favoriteListOfCurrentUser.add(FavoriteProductModel.fromJson(eachCurrent));
        });
      }
    } else {
      Fluttertoast.showToast(msg: "Khong hien status 200");
    }
  } catch (e) {
    print("Error: $e");
    Fluttertoast.showToast(msg: "Có lỗi xảy ra khi tải danh sách yêu thích");
  }
  return favoriteListOfCurrentUser;
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
              favoriteListWidget(context),

            ],
          ),
        ),
      ),
    );
  }
Row buildRatingStars(int rating) {
  List<Widget> stars = [];
  for (int i = 0; i < 5; i++) {
    if (i < rating) {
      stars.add(const Icon(
        Icons.star,
        color: Color(0xFFFF8159),
        size: 10,
      ));
    } else {
      stars.add(const Icon(
        Icons.star,
        color: Colors.grey,
        size: 10,
      ));
    }
  }
  return Row(children: stars);
}
Widget favoriteListWidget(context) {
  return FutureBuilder(future: getCurrentUserFavoriteList(),
      builder: (context, AsyncSnapshot<List<FavoriteProductModel>> dataSnapShot)
      {
        if(dataSnapShot.connectionState == ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapShot.data == null){
          return const Center(
            child: NoProduct(),
          );
        }
        if(dataSnapShot.data!.isNotEmpty){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        GridView.count(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.6,
                          children: List.generate(dataSnapShot.data!.length, (idx) {
                            FavoriteProductModel y = dataSnapShot.data![idx];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 160,
                                      height: 190,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: Image.network(
                                          y.image ?? '',
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          buildRatingStars(
                                              y.average?.toInt() ?? 0),
                                          const SizedBox(width: 4,),
                                          Text("(${y.average})" ,style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF2E2E2E)),),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      y.name ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2E2E2E)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: SizedBox(
                                      width: 95,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${y.price} ',
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: Color(0xFF2E2E2E),
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else{
          return const Center(
            child: NoProduct(),
          );
        }
      });
}
}
class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(102, 32, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Danh sách yêu thích',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600),
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
              const SizedBox(
                width: 8,
              ),
              SvgPicture.asset('assets/shop_bag.svg'),
            ],
          ),
        ],
      ),
    );
  }
}
class NoProduct extends StatelessWidget {
  const NoProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/Cart.png"),
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Chưa có sản phẩm nào !",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF595D5F)),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "LunaLoveGood còn rất nhiều sản phẩm dành cho bạn,hãy dành thêm thời gian để chọn sản phẩm nhé",
            style: TextStyle(fontSize: 14, color: Color(0xFF595D5F)),
          ),
          const SizedBox(
            height: 20,
          ),
          InkResponse(
            onTap: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const HomePage(),
                  ),
                );
              }
            },
            child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFFFF8B8B)),
              child: const Center(
                child: Text(
                  "Tiếp tục mua sắm",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}