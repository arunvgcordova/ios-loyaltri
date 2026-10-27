
import 'package:flutter/material.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Assets/Assetsinfo.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Documents/Documents.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Personal_Info/Profile_Details.dart';
import 'package:loyaltri_minimal/View/Profile_Page/Work_Info/Work_info.dart';

class ProfileMenu {
  final String icon;
  final String title;
  final Widget page;
  const ProfileMenu({required this.page, required this.icon, required this.title});
}

List<ProfileMenu> profileMenu = [
  const ProfileMenu(icon: "assets/images/UserCircle.svg", title: "Personal Info", page: ProfileDetails()),
  const ProfileMenu(icon: "assets/images/Briefcase.svg", title: "Work Info", page: WorkInfo()),
  const ProfileMenu(icon: "assets/images/Envelope.svg", title: "Documents", page: Documents()),
  const ProfileMenu(icon: "assets/images/Coins.svg", title: "Assets", page: Assetinfo()),
];