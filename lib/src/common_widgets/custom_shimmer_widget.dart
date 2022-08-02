import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_sizes.dart';

class CustomShimmerWidget extends StatelessWidget {
  const CustomShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.red,
        highlightColor: Colors.yellow,
        child: Column(
          children: [
            Container(
              height: 10.0,
              color: Colors.red,
            ),
            gapH8,
            Container(
              height: 10.0,
              color: Colors.red,
            ),
            gapH8,
            Container(
              height: 10.0,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
