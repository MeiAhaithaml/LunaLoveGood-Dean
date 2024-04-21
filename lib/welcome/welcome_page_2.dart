import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lunalovegood/sign_in.dart';
import 'package:lunalovegood/sign_up.dart';
import 'package:lunalovegood/truocdangnhap/home_page_first.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _PictureWidget(),
                SizedBox(
                  height: 30,
                ),
                _StartWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PictureWidget extends StatelessWidget {
  const _PictureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 4,
          top: 8,
          child: InkResponse(
            onTap: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const HomePageFirst(),
                  ),
                );
              }
            },
            child: SvgPicture.asset(
              "assets/Exit.svg",
              width: 24,
              height: 24,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset('assets/welcome.png'),
            ),
            const SizedBox(height: 16,),
            const SizedBox(
              height: 26,
            ),
            const SizedBox(
              child: Text(
                'Chào mừng đến với LunaLoveGood ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF112835),
                    fontSize: 34,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );

  }
}

class _StartWidget extends StatefulWidget {
  const _StartWidget({Key? key}) : super(key: key);

  @override
  State<_StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<_StartWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF8B8B)),
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC6C3C3)),
            ),
            const SizedBox(
              width: 4,
            ),
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFC6C3C3)),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ink(
                child: InkWell(
                  onTap: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SignInPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 64,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF000000)),
                    child: const Center(
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Ink(
                child: InkWell(
                  onTap: () {
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const SignUpPage(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 64,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFE84545)),
                    child: const Center(
                      child: Text(
                        'Đăng ký ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
