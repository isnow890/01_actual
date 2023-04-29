import 'package:actual/common/const/colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../model/rating_model.dart';

class RatingCard extends StatelessWidget {
  //NetworkImage
  //AssetImage
  //CircleAvatar  프로바이더 사용시 ImageProvider 사용
  final ImageProvider avartarImage;

  // 리스트로 위젯 이미지를 보여줄때
  final List<Image> images;

  // 별점
  final int rating;
  final String email;

  //리뷰내용
  final String content;

  const RatingCard({Key? key,
    required this.avartarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content})
      : super(key: key);

  factory RatingCard.fromModel({
    required RatingModel model
  }){
    return RatingCard(avartarImage: NetworkImage(
      model.user.imageUrl,
    ),
        images: model.imgUrls.map((e) => Image.network(e)).toList(),
        rating: model.rating,
        email: model.user.username,
        content: model.content);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avartarImage: avartarImage,
          rating: rating,
          email: email,
        ),
        const SizedBox(
          height: 8.0,
        ),
        _Body(
          content: content,
        ),
        if (images.length > 0)
          Padding(
            padding: const EdgeInsets.only(top : 8.0),
            child: SizedBox(
              height: 100,
              child: _Images(
                images: images,
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avartarImage;
  final int rating;
  final String email;

  const _Header({Key? key,
    required this.avartarImage,
    required this.rating,
    required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avartarImage,
          radius: 12.0,
        ),
        const SizedBox(
          width: 8.0,
        ),

        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
              (index) =>
              Icon(
                index < rating ? Icons.star : Icons.star_border_outlined,
                color: PRIMARY_COLOR,
              ),
        ),
        // List.generate(5, (index) => Icon((Icons.star)))
        // Icon(Icons.star),
        // Icon(Icons.star),
        // Icon(Icons.star),
        // Icon(Icons.star),
        // Icon(Icons.star),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      //map 인덱스 받을수 있음.
      children: images
          .mapIndexed(
            (index, e) =>
            Padding(
              padding: EdgeInsets.only(
                  right: index == images.length - 1 ? 0.0 : 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: e,
              ),
            ),
      )
          .toList(),
    );
  }
}
