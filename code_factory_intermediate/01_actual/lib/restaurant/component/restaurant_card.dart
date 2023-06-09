import 'package:actual/common/const/colors.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  //이미지
  final Widget image;

  //레스토랑 이름
  final String name;

  //레스토랑 태그
  final List<String> tags;

  // 평점 갯수
  final int ratingsCount;

  //배송걸리는 시간
  final int deliveryTime;

  //배송 비용
  final int deliveryFee;

  //평균 평점
  final double ratings;

  //상세 카드 여부
  final bool isDetail;

  //Hero 위젯 태그
  final String? herokey;

  //상세 내용
  final String? detail;

  const RestaurantCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.tags,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee,
      required this.ratings,
      this.isDetail = false,
      this.detail,
      this.herokey})
      : super(key: key);

  factory RestaurantCard.fromModel(
      {required RestaurantModel model, bool isDetail = false}) {
    return RestaurantCard(
      image: Image.network(model.thumbUrl, fit: BoxFit.cover),
      // image: Image.asset(
      //   'asset/img/food/ddeok_bok_gi.jpg'
      //   //As small as possible while still covering the entire target box
      //   ,
      //   fit: BoxFit.cover,
      // ),
      name: model.name,
      //List<String>.from으로 List<dynamic> 형태를 형변환 해줄 수 있음.
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
      herokey: model.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //테두리 깎음
        if (herokey != null)
          Hero(
            tag: ObjectKey(herokey),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
              child: image,
            ),
          ),
        const SizedBox(
          height: 16.0,
        ),
        if (herokey == null)
          ClipRRect(
            borderRadius: BorderRadius.circular(isDetail ? 0 : 12.0),
            child: image,
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              //C#의 string.Join과 똑같은 기능.
              Text(
                tags.join(' · '),
                style: TextStyle(
                    color: BODY_TEXT_COLOR,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 8.0,
              ),

              Row(
                children: [
                  _IconText(
                    icon: Icons.star,
                    label: ratings.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.receipt,
                    label: ratingsCount.toString(),
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.timelapse_outlined,
                    label: '${deliveryTime}분',
                  ),
                  renderDot(),
                  _IconText(
                    icon: Icons.monetization_on,
                    label:
                        deliveryFee == 0 ? '무료' : '${deliveryFee.toString()}원',
                  ),
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                ),
            ],
          ),
        ),
      ],
    );
  }

  //UTF-8 dot 표시
  renderDot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ' · ',
        style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _IconText extends StatelessWidget {
  //Icons.해서 가져오는 데이터
  final IconData icon;
  final String label;

  const _IconText({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: PRIMARY_COLOR,
          size: 14.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
