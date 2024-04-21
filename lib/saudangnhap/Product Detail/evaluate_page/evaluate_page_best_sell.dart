import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/saudangnhap/Cart/cart_page.dart';
import 'package:lunalovegood/saudangnhap/Product%20Detail/product_page_best_sell.dart';

import '../../../../model/evaluate_model.dart';
import '../../../../search/search_page.dart';
import '../../../model/best_sell_product_model.dart';
import '../image_page.dart';

class EvaluatePageBestSell extends StatefulWidget {
  const  EvaluatePageBestSell({Key? key, required this.product, required this.selectedTabIndex}) : super(key: key);
  final BestSell product;
  final int selectedTabIndex;
  @override
  State< EvaluatePageBestSell> createState() => _EvaluatePageBestSellFavoriteState();
}

class _EvaluatePageBestSellFavoriteState extends State< EvaluatePageBestSell> {
  Color _iconColor = Colors.white;
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
              InformationWidget(select: widget.selectedTabIndex),


            ],
          ),

        ),
      ),
      bottomNavigationBar: BottomBarWidget(product: widget.product,),
    );
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
                    color: Color(0xFFFBE8E8)
                ),
                child: const Center(child: Text("Sản phẩm đã hết hàng",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Color(0xFFCE5A5A)),)),
              ),
            )
          ] else ...[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const CartPage(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  width: 283,
                  height: 40,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      color: Color(0xFFFF8B8B)
                  ),
                  child: const Center(child: Text("Chọn Sản Phẩm",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.white),)),
                ),
              ),
            )
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
    return  Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkResponse(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset('assets/back.svg')),
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
class InformationWidget extends StatefulWidget {
  const InformationWidget({Key? key, required this.select}) : super(key: key);
  final int select;

  @override
  State<InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<InformationWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.select;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2000,
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
                tabs: const [
                  Tab(
                    child: Text(
                      "Thông tin sản phẩm",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Đánh giá ",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
                controller: _tabController,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const ItemWidget(),
                    evaluateWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Evaluate> type = [
    Evaluate(
        customerName: "Ngo Ngoc Han",
        commentDate: "15/2/2024",
        averageStar: 2.5,
        customerImage: "assets/6.jpg",
        categoryParentSlideImages: [
          "assets/1.jpg",
          "assets/2.jpg",
          "assets/3.jpg",
        ]),
    Evaluate(
        customerName: "Nguyen  Van B",
        commentDate: "7/6/2023",
        averageStar: 4.5,
        customerImage: "assets/7.jpg",
        categoryParentSlideImages: ['assets/1.jpg'],
        comment:
        "Mình đánh giá cao chất lượng sản phẩm của LunaLoveGood. Bó hoa được làm rất tỉ mỉ và cẩn thận. Hoa được làm bằng chất liệu kẽm nhung cao cấp, có độ bền cao. Bó hoa được đóng gói cẩn thận, nên khi nhận được sản phẩm, hoa vẫn giữ được vẻ đẹp nguyên vẹn."),
    Evaluate(
        customerName: "Nguyen  Van C",
        commentDate: "1/6/2023",
        averageStar: 5,
        customerImage: "assets/6.jpg",
        categoryParentSlideImages: ['assets/2.jpg'],
        comment:
        "Mình sẽ tiếp tục ủng hộ LunaLoveGood trong tương lai. Nếu bạn đang tìm kiếm một món quà ý nghĩa cho người thân yêu, mình khuyên bạn nên tham khảo sản phẩm của cửa hàng này."),
    Evaluate(
        customerName: "Ngo Ngoc Han D",
        commentDate: "15/6/2022",
        averageStar: 3,
        customerImage: "assets/7.jpg",
        categoryParentSlideImages: [
          "assets/1.jpg",
          "assets/2.jpg",
          "assets/3.jpg",
        ]),Evaluate(
        customerName: "Ngo Ngoc Han",
        commentDate: "15/2/2024",
        averageStar: 2.5,
        customerImage: "assets/6.jpg",
        categoryParentSlideImages: [
          "assets/1.jpg",
          "assets/2.jpg",
          "assets/3.jpg",
        ]),
    Evaluate(
        customerName: "Nguyen  Van B",
        commentDate: "7/6/2023",
        averageStar: 4.5,
        customerImage: "assets/7.jpg",
        categoryParentSlideImages: ['assets/1.jpg'],
        comment:
        "Mình đánh giá cao chất lượng sản phẩm của LunaLoveGood. Bó hoa được làm rất tỉ mỉ và cẩn thận. Hoa được làm bằng chất liệu kẽm nhung cao cấp, có độ bền cao. Bó hoa được đóng gói cẩn thận, nên khi nhận được sản phẩm, hoa vẫn giữ được vẻ đẹp nguyên vẹn."),
    Evaluate(
        customerName: "Nguyen  Van C",
        commentDate: "1/6/2023",
        averageStar: 5,
        customerImage: "assets/6.jpg",
        categoryParentSlideImages: ['assets/2.jpg'],
        comment:
        "Mình sẽ tiếp tục ủng hộ LunaLoveGood trong tương lai. Nếu bạn đang tìm kiếm một món quà ý nghĩa cho người thân yêu, mình khuyên bạn nên tham khảo sản phẩm của cửa hàng này."),

  ];

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

  evaluateWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            separatorBuilder: (ctx, idx) {
              return Container(
                width: 18,
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: type.length,
            itemBuilder: (ctx, idx) {
              var y = type[idx];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(20),
                            child: Image.asset(
                              y.customerImage ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16,),
                        Text(
                          y.customerName ?? "",
                          style: const TextStyle(
                            color: Color(0xFF595D5F),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        buildRatingStars(y.averageStar?.toInt() ?? 0),
                        const SizedBox(width: 8),
                        Text(
                          y.commentDate ?? '',
                          style: const TextStyle(
                            color: Color(0xFF595D5F),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    InkResponse(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                ImagePage(imageBest: type[idx]),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 250,
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          alignment: WrapAlignment.start,
                          children: List.generate(
                            y.categoryParentSlideImages!.length,
                                (idx) {
                              final post =
                              y.categoryParentSlideImages![idx];
                              return SizedBox(
                                width: 75,
                                height: 80,
                                child: Image.asset(
                                  post,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      y.comment ?? "",
                      style: const TextStyle(
                        color: Color(0xFF595D5F),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
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
          Text("Tên sản phẩm: Bó hoa kẽm nhung màu xanh lam",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Mã sản phẩm: BHL001",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Chất liệu: Kẽm nhung",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Kích thước: Chiều cao 40cm, đường kính 25cm",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Màu sắc: Xanh lam",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Ý nghĩa: Tình yêu, sự quan tâm, sự trân trọng",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),
          Text("Công dụng: Trang trí nhà cửa, phòng làm việc, tặng quà",style: TextStyle(color: Color(0xFF595D5F),fontSize: 14,),),

        ],
      ),
    );
  }
}

