import 'package:blood_donor/constants/color_constant.dart';
import 'package:flutter/cupertino.dart';

class CustomDropDownButton extends StatelessWidget {
  final Widget child;
  const CustomDropDownButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 2,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
      decoration: BoxDecoration(
          color: lightGreyColor, borderRadius: BorderRadius.circular(18.0)),
      child: child,
    );
  }
}
