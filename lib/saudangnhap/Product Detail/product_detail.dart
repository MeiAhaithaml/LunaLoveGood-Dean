import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lunalovegood/model/product_model.dart';
import 'package:lunalovegood/saudangnhap/Product%20Detail/evaluate_page/evaluate_page_best.dart';
import 'package:lunalovegood/user_preferences/current_user.dart';

import '../../api_connection/api_connection.dart';
import '../../search/search_page.dart';
import '../Cart/cart_page.dart';
import 'Controllers/product_details_controller.dart';
import 'package:http/http.dart' as http;

class ProductPageBest extends StatefulWidget {
  const ProductPageBest({Key? key, required this.forYouProduct})
      : super(key: key);
  final ProductModel? forYouProduct;

  @override
  State<ProductPageBest> createState() => _ProductPageBestState();
}

class _ProductPageBestState extends State<ProductPageBest> {
  Row buildRatingStars(int rating) {
    List<Widget> stars = [];
    for (int i = 0; i < 5; i++) {
      if (i < rating) {
        stars.add(const Icon(
          Icons.star,
          color: Color(0xFFFF8159),
          size: 12,
        ));
      } else {
        stars.add(const Icon(
          Icons.star,
          color: Colors.grey,
          size: 12,
        ));
      }
    }
    return Row(children: stars);
  }

  @override
  void initState() {
    super.initState();
    validateFavorite();

  }


  validateFavorite() async {
    try {
      var res = await http.post(
        Uri.parse(API.validateFavoriteProduct),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.forYouProduct!.item_id.toString(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfValidateFavorite = jsonDecode(res.body);
        if (resBodyOfValidateFavorite['favoriteFound'] == true) {
          productDetailsController.setIsFavoriteProduct(true);
        } else {
          productDetailsController.setIsFavoriteProduct(false);
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "erro" + e.toString());
    }
  }

  addFavorite() async {
    try {
      var res = await http.post(
        Uri.parse(API.addFavoriteProduct),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.forYouProduct!.item_id.toString(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfAddFavorite = jsonDecode(res.body);
        if (resBodyOfAddFavorite['success'] == true) {
          Fluttertoast.showToast(
              msg: 'Them vao danh sach yeu thich thanh cong');
          validateFavorite();
        } else {
          Fluttertoast.showToast(
              msg: "Them vao danh sach yeu thich khong thanh cong");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "erro" + e.toString());
    }
  }

  deleteFavorite() async {
    try {
      var res = await http.post(
        Uri.parse(API.deleteFavoriteProduct),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.forYouProduct!.item_id.toString(),
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfDeleteFavorite = jsonDecode(res.body);
        if (resBodyOfDeleteFavorite['success'] == true) {
          Fluttertoast.showToast(msg: 'Xoa danh sach yeu thich thanh cong');
          validateFavorite();
        } else {
          Fluttertoast.showToast(
              msg: "Xoa danh sach yeu thich khong thanh cong");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "erro" + e.toString());
    }
  }


  Future<List<ProductModel>> getForYouFlowerItems() async {
    List<ProductModel> listTag = [];
    try {
      var res = await http.post(Uri.parse(API.tagFlowerItems), body: {
        "tag_name": widget.forYouProduct!.tag!.join(", "), // Chuyển danh sách thành chuỗi bằng cách nối các phần tử bằng dấu phẩy và khoảng trắng
      });
      if (res.statusCode == 200) {
        var responseBodyOfForYouFlower = jsonDecode(res.body);
        if (responseBodyOfForYouFlower["success"] == true) {
          (responseBodyOfForYouFlower["flowerData"] as List).forEach((eachRecord){
            listTag.add(ProductModel.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      print("Error:: $e");
    }
    return listTag;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBarWidget(),
              const SizedBox(
                height: 26,
              ),
              productWidget(),
              Container(
                color: const Color(0xFFF6F6F6),
                height: 16,
                width: MediaQuery.of(context).size.width,
              ),
              informationProductWidget(),
              const SaleWidget(),
              InformationWidget(
                newProductInformation: widget.forYouProduct,
              ),
              related(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomBarWidget(),
    );
  }

  Widget productWidget() {
    return Column(children: [
      SizedBox(
        height: 200,
        child: Image.network("${widget.forYouProduct!.image}"),
      ),
    ]);
  }

  Widget informationProductWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              widget.forYouProduct!.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E2E2E)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildRatingStars(widget.forYouProduct!.average?.toInt() ?? 0),
              const SizedBox(
                width: 4,
              ),
              RichText(
                text: TextSpan(
                  text: "${widget.forYouProduct!.countBuy} ",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFF76288)),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'đã bán',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFF949494))),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Còn ",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF949494)),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${widget.forYouProduct!.inventory}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFFF76288))),
                    const TextSpan(
                        text: ' sản phẩm',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: Color(0xFF949494))),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Obx(() => IconButton(
                    onPressed: () {
                      if (productDetailsController.isFavorite == true) {
                        // delete
                        deleteFavorite();
                      } else {
                        // add
                        addFavorite();
                      }
                    },
                    icon: Icon(
                      productDetailsController.isFavorite
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      color: Colors.redAccent,
                    ))),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 95,
            child: Text(
              '${widget.forYouProduct!.price} ',
              style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF595D5F),
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

  }

  final productDetailsController = Get.put(ProductDetailController());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart() async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "user_id": currentOnlineUser.user.user_id.toString(),
          "item_id": widget.forYouProduct!.item_id.toString(),
          "quantity": productDetailsController.quantity.toString(),
          "size": widget.forYouProduct!.sizes![productDetailsController.size],
        },
      );
      if (res.statusCode == 200) {
        var resBodyOfAddCart = jsonDecode(res.body);
        if (resBodyOfAddCart['success'] == true) {
          Fluttertoast.showToast(msg: 'Them vao gio hang thanh cong');
        } else {
          Fluttertoast.showToast(msg: "Them vao gio hang khong thanh cong");
        }
      } else {
        Fluttertoast.showToast(msg: "Khong hien status 200");
      }
    } catch (e) {
      print("erro" + e.toString());
    }
  }

  Widget bottomBarWidget() {
    return Container(
      height: 76,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 50,
            child: Obx(() => IconButton(
                onPressed: () {
                  if (productDetailsController.isFavorite) {
                    // delete
                  } else {
                    // add
                  }
                },
                icon: Icon(
                  productDetailsController.isFavorite
                      ? Icons.bookmark
                      : Icons.bookmark_border_outlined,
                  color: Colors.redAccent,
                ))),
          ),
          if (widget.forYouProduct!.inventory == 0) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 283,
                height: 40,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Color(0xFFFBE8E8)),
                child: const Center(
                    child: Text(
                  "Sản phẩm đã hết hàng",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCE5A5A)),
                )),
              ),
            )
          ] else ...[
            Container(
              width: 280,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color(0xFFFF8B8B),
              ),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: const Color(0xFFF4F4F4),
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset("assets/close.svg",width: 30,height: 30,),
                              ),
                            ),
                            sizeProduct(),
                            SizedBox(height: 16,),
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      if (productDetailsController.quantity > 1) {
                                        productDetailsController.setQuantityProduct(productDetailsController.quantity - 1);
                                      }
                                    });},
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  )
                              ),

                                Text(
                                  productDetailsController.quantity.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black
                                  ),
                                ),

                                IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      setState(() {
                                        productDetailsController.setQuantityProduct(productDetailsController.quantity + 1);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    )
                                )
                              ],
                            ),
                            SizedBox(height: 16,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        addItemToCart();
                                      },
                                      child: Container(
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: Color(0xFFFF8B8B)),
                                          child: const Center(
                                              child: Text(
                                            'Thêm Giỏ Hàng',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ))),
                                    ),
                                  ),]
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: const Center(
                  child: Text(
                    "Chọn Sản Phẩm",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  Widget sizeProduct() {
    return Row(
      children: [
        Wrap(
          runSpacing: 0,
          spacing: 0,
          children: List.generate(widget.forYouProduct!.sizes!.length, (idx) {
            return Obx(() => GestureDetector(
                  onTap: () {
                    productDetailsController.setSizeProduct(idx);
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: productDetailsController.size == idx
                          ? const Color(0xFFFF8B8B)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFF5F5F5),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.forYouProduct!.sizes![idx]
                            .replaceAll("[", "")
                            .replaceAll("]", ""),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: productDetailsController.size == idx
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ));
          }),
        )
      ],
    );
  }
  Widget relatedProduct(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              "Sản phẩm liên quan",
              style: TextStyle(
                  color: Color(0xFF3A3D3E),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          related()
        ],
      ),
    );
  }
  Widget related() {
    return FutureBuilder(
      future: getForYouFlowerItems(),
      builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapShot.data == null || dataSnapShot.data!.length ==1) {
          return Center(child: Text("Không có sản phẩm liên quan"));
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(dataSnapShot.data!.length, (idx) {
                        ProductModel y = dataSnapShot.data![idx];
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
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      buildRatingStars(y.average?.toInt() ?? 0),
                                      const SizedBox(width: 4),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 140,
                                child: Text(
                                  y.name ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2E2E2E),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 160,
                                child: SizedBox(
                                  width: 95,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${y.price} ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2E2E2E),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        '${y.countBuy} đã bán',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF8D8D8D),
                                        ),
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFE0BABA),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 16, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset('assets/back.svg')),
            const Text(
              'LUNALOVEGOOD',
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
            ),
          ],
        ),
      ),
    );
  }
}

class SaleWidget extends StatelessWidget {
  const SaleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xFFE6E6E6),
          height: 10,
          width: MediaQuery.of(context).size.width,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(25), //Image radius
                  child: Image.asset("assets/hoa.jpg", fit: BoxFit.cover),
                ),
              ),
              SvgPicture.asset("assets/next.svg")
            ],
          ),
        ),
      ],
    );
  }
}

class InformationWidget extends StatefulWidget {
  const InformationWidget({Key? key, required this.newProductInformation})
      : super(key: key);
  final ProductModel? newProductInformation;

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  @override
  Widget build(BuildContext context) {
    int selectedTabIndex = 0;
    return SizedBox(
      height: 450,
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: 30,
          child: Column(
            children: [
              TabBar(
                indicatorColor: const Color(0xFFF76288),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
                labelColor: const Color(0xFF56707A),
                unselectedLabelColor: const Color(0xFF9CAAAF),
                tabs: [
                  const Tab(
                    child: Text(
                      "Thông tin sản phẩm",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: InkResponse(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = 1;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => EvaluatePage(
                              product: widget.newProductInformation!,
                              selectedTabIndex: selectedTabIndex,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Đánh giá",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    itemWidget(),
                    Container(
                      color: Colors.cyan,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tên sản phẩm: ${widget.newProductInformation!.name}",
            style: const TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Mã sản phẩm: ${widget.newProductInformation!.item_id}",
            style: const TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "${widget.newProductInformation!.tag}",
            style: const TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "${widget.newProductInformation!.description}",
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            style: const TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          )
        ],
      ),
    );
  }
}



