import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lunalovegood/model/evaluate_model.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key, required this.imageBest}) : super(key: key);
  final Evaluate imageBest;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  int selectedindex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;
  final bool _isUserScrolling = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(84, 101, 103, 0.8),
        body: SafeArea(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        InkResponse(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset('assets/back_light.svg')),
        SizedBox(height: 24,),
        SizedBox(
          height: 445,
          width: 448.84,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageBest.categoryParentSlideImages?.length,
            itemBuilder: (ctx, idx) {
              var x = widget.imageBest.categoryParentSlideImages?[idx];
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      x ?? '',
                      fit: BoxFit.fitHeight,
                      height: 300,
                    ),
                  ),
                  Positioned(
                      top: 418,
                      left: 325,
                      child: Container(
                          width: 24,
                          height: 16,
                          decoration: const BoxDecoration(
                              color: Color(0xFFD56A6A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          child: Center(
                              child: Text(
                            '${(idx + 1)}/${widget.imageBest.categoryParentSlideImages?.length}',
                            style: const TextStyle(color: Colors.white),
                          )))),
                  Positioned(
                    top: 426,
                    left: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                        widget.imageBest.categoryParentSlideImages?.length ?? 0,
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
      ]),
    ));
  }
}
