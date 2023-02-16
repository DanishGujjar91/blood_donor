import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants/color_constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {super.key,
      this.leading = null,
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
    return SafeArea(
      top: false,
      bottom: false,
      child: Stack(
        children: [
          AppBar(
            actions: action,
            elevation: 0,
            backgroundColor: whiteColor,
            leading: leading,
            title: Text(
              title,
              style: textStyle,
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                color: primaryColor,
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
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 120);
}
