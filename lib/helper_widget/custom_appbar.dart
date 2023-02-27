import 'package:flutter/material.dart';

import '../constants/color_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leading,
      required this.title,
      this.textStyle,
      this.iconSize,
      this.icon,
      this.borderRadius,
      this.action});

  final String title;
  final Widget? leading;
  final TextStyle? textStyle;
  final double? iconSize;
  final IconData? icon;
  final BorderRadiusGeometry? borderRadius;
  final List<Widget>? action;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          AppBar(
            actions: action,
            elevation: 0,
            backgroundColor: isDark ? Color(0xFF2e2e2e) : whiteColor,
            leading: leading,
            title: Text(
              title,
              style: textStyle,
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.blue : primaryColor,
                borderRadius: borderRadius,
              ),
            ),
          ),
          Positioned(
              top: 80.0,
              left: 0.0,
              right: 0.0,
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 120);
}
