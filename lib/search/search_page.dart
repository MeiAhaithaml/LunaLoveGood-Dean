import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/model/cart_product_model.dart';
import 'package:lunalovegood/model/product_model.dart';
import 'package:http/http.dart' as http;
import '../api_connection/api_connection.dart';
import '../model/best_sell_product_model.dart';
import '../saudangnhap/Product Detail/product_detail.dart';
import '../saudangnhap/bottom_bar.dart';
import '../saudangnhap/home_page_second.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<List<ProductModel>> readSearchRecordFound() async {
    List<ProductModel> searchList = [];
    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(API.searchProduct), body: {
          "typeKeyWord": searchController.text,
        });
        if (res.statusCode == 200) {
          print(res.toString());
          var resBodyOfGetCurrentSearchProduct = jsonDecode(res.body);
          if (resBodyOfGetCurrentSearchProduct['success'] == true) {
            (resBodyOfGetCurrentSearchProduct['foundProductData'] as List)
                .forEach((eachProductData) {
              searchList.add(ProductModel.fromJson(eachProductData));
            });
          }
        } else {
          Fluttertoast.showToast(msg: "Khong hien status 200");
        }
      } catch (e) {
        print("Error: $e");
        Fluttertoast.showToast(
            msg: "Có lỗi xảy ra khi tải danh sách ");
      }
    }
    return searchList;
  }

  @override
  void initState() {
    super.initState();
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

  List<String> searchResults = [
    "Hoa hồng",
    "Phụ kiện ",
    "Hoa hướng dương ",
    "Hoa hồng xanh ",
  ];

  void removeItem(int index) {
    setState(() {
      searchResults.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkResponse(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset('assets/back.svg')),
                    const Text(
                      'Tìm kiếm ',
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
              ),
              showSearchBarWidget(),
              const SizedBox(
                height: 26,
              ),
              searchProductWidget(context),
              const SizedBox(
                height: 26,
              ),
              Container(
                color: const Color(0xFFF6F6F6),
                height: 16,
                width: MediaQuery.of(context).size.width,
              ),
           //   const BestKeyWord(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchProductWidget(context) {
    return FutureBuilder(
        future: readSearchRecordFound(),
        builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(child: NoProduct());
          }
          if (dataSnapShot.data!.isNotEmpty) {
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
                            children:
                                List.generate(dataSnapShot.data!.length, (idx) {
                              ProductModel y = dataSnapShot.data![idx];
                              return InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => ProductPageBest(
                                          forYouProduct:
                                              dataSnapShot.data![idx],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: 160,
                                          height: 190,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            child: Image.network(
                                              y.image ?? '',
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              buildRatingStars(
                                                  y.average?.toInt() ?? 0),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                "(${y.average})",
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF2E2E2E)),
                                              ),
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
                                                '${y.price}  VNĐ',
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xFF2E2E2E),
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
          } else {
            return const Center(
              child: NoProduct(),
            );
          }
        });
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {
              });
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          hintText: "Tim kiem...",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget historyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Lịch sử tìm kiếm",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF767676)),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(
                    searchResults[index],
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF595D5F)),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFFEE6464),
                    ),
                    onPressed: () {
                      removeItem(index);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Container(
                    color: const Color(0xFFEDEDED),
                    width: MediaQuery.of(context).size.width,
                    height: 0.5,
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

class KeyWordWidget extends StatelessWidget {
  const KeyWordWidget(
      {Key? key,
      required this.number,
      required this.keyword,
      required this.view})
      : super(key: key);
  final String number;
  final String keyword;
  final String view;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    number,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF595D5F),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Text(
                    keyword,
                    style:
                        const TextStyle(fontSize: 16, color: Color(0xFF595D5F)),
                  )
                ],
              ),
              Text(
                "($view)",
                style: const TextStyle(fontSize: 16, color: Color(0xFF595D5F)),
              )
            ],
          ),
          Container(
            color: const Color(0xFFEDEDED),
            width: MediaQuery.of(context).size.width,
            height: 0.5,
          )
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
                    builder: (ctx) => const NavigationMenu(),
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
