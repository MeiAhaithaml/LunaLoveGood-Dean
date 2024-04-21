import 'package:flutter/material.dart';
import 'package:lunalovegood/welcome/welcome_page_2.dart';

class OnboardPage extends StatefulWidget {
  const OnboardPage({Key? key}) : super(key: key);

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
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
                  height: 26,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.asset('assets/welcome.png'),
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
                  color: Color(0xFF6E77F6)),
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
        Ink(
          child: InkWell(
            onTap: () {
              {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => const WelcomePage(),
                  ),
                );
              }
            },
            child: const Text(
              'Bỏ qua',
              style: TextStyle(
                color: Color(0xFF7E7272),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        )
      ],
    );
  }
}
