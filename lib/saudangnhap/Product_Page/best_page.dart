import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../api_connection/api_connection.dart';
import '../../model/best_sell_product_model.dart';
import '../../model/favorite_model.dart';
import '../../model/product_model.dart';
import '../../search/search_page.dart';
import '../Product Detail/product_detail.dart';
import '../Product Detail/product_page_favorite.dart';
import 'package:http/http.dart' as http;
class BestPage extends StatefulWidget {
  const BestPage({Key? key}) : super(key: key);

  @override
  State<BestPage> createState() => _BestPageState();
}

class _BestPageState extends State<BestPage> {

  Future<List<ProductModel>> getNewFlowerItems() async{
    List<ProductModel> listNewItems = [];
    try{
      var res = await http.post(Uri.parse(API.newFlowerItems)

      );
      if(res.statusCode == 200){
        var responseBodyOfNewFlower =  jsonDecode(res.body);
        if(responseBodyOfNewFlower["success"] == true){
          (responseBodyOfNewFlower["flowerData"] as List).forEach((eachRecord)
          {
            listNewItems.add(ProductModel.fromJson(eachRecord));
          });
        }
      }
      else{
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    }
    catch(e){
      print("Error::" + e.toString());
    }
    return listNewItems;
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
  List<BestSell> favorite = [
    BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ), BestSell(
      productName: 'Hoa hồng xanh ',
      productImage: 'assets/1.jpg',
      price: 120.000,
      buyCount: 50,
      averageStar: 4.5,
      likeNumber: 100,
      commentCount: 30,
    ),

  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNewFlowerItems(),
      builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null) {
          return const Center(
            child: Text("Không có sản phẩm moi"),
          );
        }
        if (dataSnapShot.data!.isNotEmpty) {
          return  Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            color: const Color(0xFFE0BABA),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkResponse(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: SvgPicture.asset('assets/back.svg')),
                                  const Text('LUNALOVEGOOD',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w600),),
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
                                      SvgPicture.asset('assets/shop_bag.svg'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "SẢN PHẨM MỚI NHẤT",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF000000),
                                      fontWeight: FontWeight.w600),
                                ),
                                SvgPicture.asset("assets/3.svg")
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 8,
                              childAspectRatio: 0.6,
                              children: List.generate(dataSnapShot.data!.length, (idx) {
                                var y = dataSnapShot.data![idx];
                                return InkResponse(
                                  onTap: () {
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>  ProductPageBest( forYouProduct: dataSnapShot.data![idx],),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
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
                                                Text(
                                                  ' (${y.average})',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF949494)),
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
                                                  '${y.price} ',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF2E2E2E),
                                                      fontWeight: FontWeight.w800),
                                                ),
                                                Text(
                                                  '${y.countBuy} đã bán',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF8D8D8D)),
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Rỗng, không có dữ liệu"),
          );
        }
      },
    );
  }
}
