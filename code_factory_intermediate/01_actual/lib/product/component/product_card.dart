import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'asset/img/food/ddeok_bok_gi.jpg',
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '떡볶이',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('전통 떡볶이의 정석!\n맛있습니다.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: BODY_TEXT_COLOR, fontSize: 14.0)),
                Text(
                  '10000',
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}