import 'package:flutter/material.dart';

class PageModel {
  final String title;
  final String appBarTitle;
  final String appBarTitleImage;
  final String selectedIcon;
  final String unselectIcon;
  final Widget page;

  PageModel({
    required this.title,
    required this.selectedIcon,
    required this.unselectIcon,
    required this.page,
    required this.appBarTitleImage,
    required this.appBarTitle,
  });
}
