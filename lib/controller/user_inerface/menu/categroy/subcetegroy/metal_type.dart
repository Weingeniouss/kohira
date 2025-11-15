import 'package:flutter/material.dart';
import 'package:kohira/view/utils/app_color.dart';

class MyCustomContainer extends StatelessWidget {
  final Color? firstColor;
  final Color? secondColor;
  final double size;
  const MyCustomContainer({this.firstColor, this.secondColor, required this.size, super.key,});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: firstColor),
              child: Container(
                decoration: BoxDecoration(
                  color: firstColor,
                  border: Border.all(color: AppColor.white_color,width: 1),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(color: secondColor),
              child: Container(
                decoration: BoxDecoration(
                  color: secondColor,
                  border: Border.all(color: AppColor.white_color,width: 1),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SinglContainer extends StatelessWidget {
  final double size;
  final Color? singlcolor;
  const SinglContainer({super.key, required this.size, this.singlcolor});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, width: size,
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(color: singlcolor),
        child: Container(
          decoration: BoxDecoration(
            color: singlcolor,
            border: Border.all(color: AppColor.white_color,width: 2),
          ),
        ),
      ),
    );
  }
}