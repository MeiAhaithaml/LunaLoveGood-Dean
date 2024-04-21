import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lunalovegood/model/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:lunalovegood/saudangnhap/Product_Page/best_sell_page.dart';
import '../api_connection/api_connection.dart';
import '../model/introduce_model.dart';
import '../search/search_page.dart';
import 'Cart/cart_page.dart';
import 'Product Detail/product_detail.dart';
import 'Product_Page/best_page.dart';
import 'Product_Page/favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF6F6F6)),
      home:  Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                const SingleChildScrollView(
                  child: _IntroduceWidget(),
                ),
                Positioned(top: 0, right: 0, left: 0, child: appbar())
              ],
            ),
          ),
        ),
      );
  }

  Widget appbar() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFE0BABA),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/Menu.svg"),
            const Text(
              "LUNALOVEGOOD",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
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
            ),

          ],
        ),
      ),
    );
  }
}

class _IntroduceWidget extends StatefulWidget {
  const _IntroduceWidget({Key? key}) : super(key: key);

  @override
  State<_IntroduceWidget> createState() => _IntroduceWidgetState();
}

class _IntroduceWidgetState extends State<_IntroduceWidget> {
  List<IntroduceModel> intro = [
    IntroduceModel(image: 'assets/5.jpg', status: 'Chào mừng đến với LunaLove'),
    IntroduceModel(
        image: 'assets/2.jpg',
        status: 'Hoa xinh cho đời thêm yêu',
        introduce: ''),
    IntroduceModel(
        image: 'assets/3.jpg',
        status: '',
        introduce: ''),
    IntroduceModel(image: 'assets/4.jpg', status: ''),
  ];
  int selectedindex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  bool _isUserScrolling = false;
  @override
  void initState() {
    super.initState();
    _pageController.addListener(_handlePageScroll);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!_isUserScrolling) {
        int nextPage = selectedindex + 1;
        if (nextPage >= intro.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(seconds: 10),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageScroll);
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _handlePageScroll() {
    if (_pageController.page == _pageController.page?.round()) {
      setState(() {
        selectedindex = _pageController.page?.round() ?? 0;
      });
    }
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
  Future<List<ProductModel>> getForYouFlowerItems() async {
    List<ProductModel> listForYou = [];
    try {
      var res = await http.post(Uri.parse(API.forYouFlowerItems));
      if (res.statusCode == 200) {
        var responseBodyOfForYouFlower = jsonDecode(res.body);
        if (responseBodyOfForYouFlower["success"] == true) {
          (responseBodyOfForYouFlower["flowerData"] as List).forEach((eachRecord){
            listForYou.add(ProductModel.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Status code is not 200");
      }
    } catch (e) {
      print("Error:: $e");
    }
    return listForYou;
  }




  Future<List<ProductModel>> getNewFlowerItems() async{
    List<ProductModel> listNewItems = [];
    try{
      var res = await http.post(Uri.parse(API.newFlowerItems)

      );
      if(res.statusCode == 200){
        var responseBodyOfNewFlower =  jsonDecode(res.body);
        if(responseBodyOfNewFlower["success"] == true){
          (responseBodyOfNewFlower["flowerData"] as List).forEach((eachRecord){
            listNewItems.add(ProductModel.fromJson(eachRecord));
   });}
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
  Future<List<ProductModel>> getBestSellFlowerItems() async{
    List<ProductModel> listBestSellItems = [];
    try{
      var res = await http.post(Uri.parse(API.newFlowerItems)

      );
      if(res.statusCode == 200){
        var responseBodyOfBestSellFlower =  jsonDecode(res.body);
        if(responseBodyOfBestSellFlower["success"] == true){
          (responseBodyOfBestSellFlower["flowerData"] as List).forEach((eachRecord){
            listBestSellItems.add(ProductModel.fromJson(eachRecord));
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
    return listBestSellItems;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 445,
          width: 448.84,
          child: NotificationListener<ScrollStartNotification>(
            onNotification: (_) {
              setState(() {
                _isUserScrolling = true;
              });
              return false;
            },
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (_) {
                setState(() {
                  _isUserScrolling = false;
                });
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                itemCount: intro.length,
                itemBuilder: (ctx, idx) {
                  var x = intro[idx];
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          x.image,
                          fit: BoxFit.cover,
                          height: 300,
                          width: 250,
                        ),
                      ),

                      SizedBox(
                        width: 450,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              x.status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              x.introduce ?? " ",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          top: 418,
                          left: 325,
                          child: Container(
                              width: 44,
                              height: 26,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFD56A6A),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                  child: Text(
                                '${(idx + 1)}/${intro.length}',
                                style: const TextStyle(color: Colors.white),
                              )))),
                      Positioned(
                        top: 426,
                        left: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            intro.length,
                            (index) => Container(
                              width: 24,
                              height: selectedindex == index ? 3 : 1,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                color: selectedindex == index
                                    ? Colors.white
                                    : Colors.white38,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        newWidget(context),
        const SizedBox(
          height: 10,
        ),
        bestWidget(context),
        const SizedBox(
          height: 10,
        ),
        bestSellProductWidget()
      ],
    );

    //   typeWidget(),
  }

  Widget bestWidget(context) {
    return FutureBuilder(future: getForYouFlowerItems(),
        builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
            {
             return const Center(
               child: CircularProgressIndicator(),
             );
            }
          if(dataSnapShot.data == null){
            return const Center(
              child: Text("Khong co san pham nao danh cho ban"),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "SẢN PHẨM DÀNH CHO BẠN ",
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
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.6,
                            children: List.generate(min(dataSnapShot.data!.length, 8), (idx) {
                               ProductModel y = dataSnapShot.data![idx];
                              return InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>  ProductPageBest(forYouProduct: dataSnapShot.data![idx],),
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
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      if (dataSnapShot.data!.length > 8)
                        Container(
                          width: 339,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(1)),
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const FavoritePage(),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Explore More",style: TextStyle(fontSize: 16),),
                                    SvgPicture.asset("assets/next.svg")
                                  ],
                                ),
                              )
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return const Center(
              child: Text("Emty, no data"),
            );
          }
        });
  }

  Widget newWidget(context) {
    return FutureBuilder(future:  getNewFlowerItems(),
        builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null){
            return const Center(
              child: Text("Khong co san pham nao moi"),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "SẢN PHẨM MỚI NHẤT ",
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
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.6,
                            children: List.generate(min(dataSnapShot.data!.length, 8), (idx) {
                              var y = dataSnapShot.data![idx];
                              return InkResponse(
        onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>  ProductPageBest(forYouProduct: dataSnapShot.data![idx],),
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
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      if (dataSnapShot.data!.length > 8)
                        Container(
                          width: 339,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(1)),
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const BestPage(),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Explore More",style: TextStyle(fontSize: 16),),
                                    SvgPicture.asset("assets/next.svg")
                                  ],
                                ),
                              )
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return const Center(
              child: Text("Emty, no data"),
            );
          }
        });


  }

  Widget bestSellProductWidget() {
    return FutureBuilder(future: getBestSellFlowerItems(),
        builder: (context, AsyncSnapshot<List<ProductModel>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null){
            return const Center(
              child: Text("Khong co san pham nao ban chay"),
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
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "SẢN PHẨM BÁN CHẠY NHẤT ",
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
                          GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.6,
                            children: List.generate(min(dataSnapShot.data!.length, 8), (idx) {
                              var y = dataSnapShot.data![idx];
                              return InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) =>  ProductPageBest(forYouProduct: y,),
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
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                      if (dataSnapShot.data!.length > 8)
                        Container(
                          width: 339,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(1)),
                            border: Border.all(
                              color: const Color(0xFFE8E8E8),
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: InkResponse(
                                onTap: () {
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (ctx) => const BestSellPage(),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Explore More",style: TextStyle(fontSize: 16),),
                                    SvgPicture.asset("assets/next.svg")
                                  ],
                                ),
                              )
                          ),
                        ),

                    ],
                  ),
                ),
              ),
            );
          }
          else{
            return const Center(
              child: Text("Emty, no data"),
            );
          }
        });
  }
}

