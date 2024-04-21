import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentPage extends StatelessWidget {
  const CommentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                AppBarWidget(),
                SizedBox(height: 16,),
                RatingBarWidget(),
                SizedBox(height: 16,),
                CommentWidget(),
                SizedBox(height: 16,),
                SendWidget()
              ],
            ),
          ),
        ),
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
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkResponse(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset("assets/back.svg")),
            const Text(
              "Gửi đánh giá sản phẩm",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF595D5F),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        const Text(
            "Cảm ơn bạn đã thích sản phẩm, xin cho mình thêm vời lời nhận xét nhé !")
      ],
    );
  }
}

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
          border: Border.all(width: 1, color: const Color(0xFFFF8B8B))),
      child: TextFormField(
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Write your review here...',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}

class SendWidget extends StatelessWidget {
  const SendWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
                border: Border.all(width: 1, color: const Color(0xFFFF8B8B))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets.camera.svg"),
              const Text("Thêm ảnh",style: TextStyle(fontSize: 14,color: Color(0xFFFF8D8D)),)],
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: const Color(0xFFFF8B8B),
                ),
            child: const Center(child: Text("Gửi đánh giá",style: TextStyle(fontSize: 14,color: Colors.white),)),
          ),
        ),
      ],
    );
  }
}
