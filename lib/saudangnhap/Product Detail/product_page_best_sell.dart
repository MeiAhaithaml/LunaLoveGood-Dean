import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/model/best_sell_product_model.dart';
import 'package:lunalovegood/saudangnhap/Product%20Detail/evaluate_page/evaluate_page_best_sell.dart';

import '../../model/favorite_model.dart';
import '../../search/search_page.dart';
import '../Cart/cart_page.dart';

class ProductPageBestSell extends StatefulWidget {
  const ProductPageBestSell({Key? key, required this.bestSellProduct})
      : super(key: key);
  final BestSell bestSellProduct;

  @override
  State<ProductPageBestSell> createState() => _ProductPageBestSellState();
}

class _ProductPageBestSellState extends State<ProductPageBestSell> {
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
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
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

  Color _iconColor = Colors.grey;

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
                bestSellProductInformation: widget.bestSellProduct,
              ),
              BottomBarWidget(product: widget.bestSellProduct),
            ],
          ),
        ),
      ),
    );
  }

  Widget productWidget() {
    return Column(children: [
      SizedBox(
        height: 200,
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
              itemCount:
                  widget.bestSellProduct.categoryParentSlideImages?.length ?? 0,
              itemBuilder: (ctx, idx) {
                var x = widget.bestSellProduct.categoryParentSlideImages?[idx];
                return Image.asset(
                  x ?? '',
                  fit: BoxFit.cover,
                );
              },
              onPageChanged: (index) {
                setState(() {
                  selectedindex = index;
                });
              },
            ),
          ),
        ),
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
              widget.bestSellProduct.productName ?? '',
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
              Row(
                children: [
                  buildRatingStars(
                      widget.bestSellProduct.averageStar?.toInt() ?? 0),
                  Text(
                    ' (${widget.bestSellProduct.likeNumber} )',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF949494)),
                  ),
                ],
              ),
              const SizedBox(
                width: 4,
              ),
              RichText(
                text: TextSpan(
                  text: "${widget.bestSellProduct.buyCount} ",
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
                        text: '${widget.bestSellProduct.inventory}',
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
              IconButton(
                icon: const Icon(Icons.favorite),
                color: _iconColor,
                onPressed: () {
                  setState(() {
                    if (_iconColor == Colors.grey) {
                      _iconColor = Colors.red;
                    } else {
                      _iconColor = Colors.grey;
                    }
                  });
                },
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          SizedBox(
            width: 95,
            child: Text(
              '${widget.bestSellProduct.price} ',
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
}

class BottomBarWidget extends StatefulWidget {
  final BestSell product;

  const BottomBarWidget({Key? key, required this.product}) : super(key: key);

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  Color _iconColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
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
          Column(
            children: [
              SizedBox(
                height: 50,
                child: IconButton(
                  icon: const Icon(Icons.favorite),
                  color: _iconColor,
                  onPressed: () {
                    setState(() {
                      if (_iconColor == Colors.grey) {
                        _iconColor = Colors.red;
                      } else {
                        _iconColor = Colors.grey;
                      }
                    });
                  },
                ),
              ),
              Text(
                ' ${widget.product.likeNumber}',
                style: const TextStyle(fontSize: 16, color: Color(0xFF949494)),
              ),
            ],
          ),
          if (widget.product.inventory == 0) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                width: 283,
                height: 40,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  color: Color(0xFFFBE8E8),
                ),
                child: const Center(
                  child: Text(
                    "Sản phẩm đã hết hàng",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCE5A5A),
                    ),
                  ),
                ),
              ),
            )
          ] else ...[
            BottomSheetExample(
              nameProduct: widget.product.productName ?? "",
              priceProducts: widget.product.price,
            ),
          ],
        ],
      ),
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
                SvgPicture.asset('assets/shop_bag.svg'),
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
  const InformationWidget({Key? key, required this.bestSellProductInformation})
      : super(key: key);
  final BestSell bestSellProductInformation;

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: DefaultTabController(
        length: 2,
        child: SizedBox(
          height: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  InkResponse(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = 1;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => EvaluatePageBestSell(
                              product: widget.bestSellProductInformation,
                              selectedTabIndex: _selectedTabIndex),
                        ),
                      );
                    },
                    child: const Tab(
                      child: Text(
                        "Đánh giá ",
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
                    const ItemWidget(),
                    Container(
                      color: Colors.cyan,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tên sản phẩm: Bó hoa kẽm nhung màu xanh lam",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Mã sản phẩm: BHL001",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Chất liệu: Kẽm nhung",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Kích thước: Chiều cao 40cm, đường kính 25cm",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Màu sắc: Xanh lam",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Ý nghĩa: Tình yêu, sự quan tâm, sự trân trọng",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
          Text(
            "Công dụng: Trang trí nhà cửa, phòng làm việc, tặng quà",
            style: TextStyle(
              color: Color(0xFF595D5F),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class RelatedProduct extends StatefulWidget {
  const RelatedProduct({Key? key}) : super(key: key);

  @override
  State<RelatedProduct> createState() => _RelatedProductState();
}

class _RelatedProductState extends State<RelatedProduct> {
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sản phẩm liên quan",
                  style: TextStyle(color: Color(0xFF3A3D3E), fontSize: 16),
                ),
                Column(children: [
                  const SizedBox(height: 20),
                  ListView.separated(
                      separatorBuilder: (ctx, idx) {
                        return Container(
                          width: 18,
                        );
                      },
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: favorite.length,
                      itemBuilder: (ctx, idx) {
                        var y = favorite[idx];
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
                                    child: Image.asset(
                                      y.productImage ?? '',
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
                                          y.averageStar?.toInt() ?? 0),
                                      Text(
                                        ' (${y.likeNumber})',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF949494)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${y.commentCount} nhận xét',
                                    style: const TextStyle(
                                        fontSize: 10, color: Color(0xFF949494)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 140,
                                child: Text(
                                  y.productName ?? '',
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
                                            fontSize: 12,
                                            color: Color(0xFF2E2E2E),
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '${y.buyCount} đã bán',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8D8D8D)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ]),
              ],
            ),
          )),
    );
  }
}

class BottomSheetExample extends StatelessWidget {
  const BottomSheetExample(
      {super.key, required this.nameProduct, required this.priceProducts});

  final String nameProduct;
  final num priceProducts;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        child: SvgPicture.asset("assets/close.svg"),
                      ),
                    ),
                    SizeProduct(
                      name: nameProduct,
                      priceProduct: priceProducts,
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
    );
  }
}

class SizeProduct extends StatefulWidget {
  const SizeProduct({Key? key, required this.name, required this.priceProduct})
      : super(key: key);
  final String name;
  final num priceProduct;

  @override
  State<SizeProduct> createState() => _SizeProductState();
}

class _SizeProductState extends State<SizeProduct> {
  List<ProductChooses> productChoosesList = [];
  String selectedSize = "S";
  Color colorSize = const Color(0xFFFF8B8B);
  int totalPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildSizeButton("S"),
              const SizedBox(
                width: 16,
              ),
              buildSizeButton("M"),
              const SizedBox(
                width: 16,
              ),
              buildSizeButton("L"),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: productChoosesList,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(
                                width: 1, color: const Color(0xFFDCDCDC))),
                        child: const Center(
                            child: Text(
                          'Thêm Giỏ Hàng',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF595D5F)),
                        ))),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          productChoosesList.add(ProductChooses(
                            size: selectedSize,
                            text: widget.name,
                            price: widget.priceProduct,
                            onDelete: (deletedProduct) {
                              removeProductChooses(deletedProduct);
                            },
                            addToTotalPrice: (value) {
                              totalPrice += value;
                            },
                          ));
                        });
                      },
                      child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xFFFF8B8B)),
                          child: const Center(
                              child: Text(
                            'Chọn sản phẩm ',
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void removeProductChooses(ProductChooses product) {
    setState(() {
      productChoosesList.remove(product);
      totalPrice -= product.price.toInt();
    });
  }

  Widget buildSizeButton(String size) {
    Color backgroundColor = selectedSize == size
        ? const Color(0xFFFF8B8B)
        : const Color(0xFFF5F5F5);
    Color textColor = selectedSize == size ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: const Color(0xFFF5F5F5),
          ),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}


class QuantitySelector extends StatelessWidget {
  final int initialValue;
  final Function(int) onChanged;

  const QuantitySelector({
    Key? key,
    required this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int value = initialValue;

    void increment() {
      value++;
      onChanged(value);
    }

    void decrement() {
      if (value > 1) {
        value--;
        onChanged(value);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xFFE8E8E8))),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove),
            onPressed: decrement,
          ),
        ),
        Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: const Color(0xFFE8E8E8)),
            ),
            child: Center(child: Text('$value'))),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0xFFE8E8E8)),
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add,),
            onPressed: increment,
          ),
        ),
      ],
    );
  }
}

class ProductChooses extends StatefulWidget {
  const ProductChooses({
    Key? key,
    required this.text,
    required this.size,
    required this.onDelete,
    required this.addToTotalPrice,
    required this.price,
  }) : super(key: key);

  final String size;
  final Function(ProductChooses) onDelete;
  final String text;
  final Function(int) addToTotalPrice;
  final num price;

  @override
  _ProductChoosesState createState() => _ProductChoosesState();
}

class _ProductChoosesState extends State<ProductChooses> {
  num price = 120.000;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  num get getPrice => price;

  set setPrice(num newValue) => price = newValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Text(" ${widget.text} ${widget.size}"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.onDelete(widget);
                  },
                ),
              ],
            ),
            Row(
              children: [
                QuantitySelector(
                  initialValue: quantity,
                  onChanged: (value) {
                    setState(() {
                      quantity = value;
                      price = 120.000 * value;
                      widget.addToTotalPrice(price.toInt());
                    });
                  },
                ),
                Text("$price"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
