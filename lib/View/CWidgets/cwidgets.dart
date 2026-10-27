import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/color_utils.dart';

Container gradientContainer1 = Container(
  height: ScreenUtil().screenHeight,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorUtils.lavenderPurple,
        ColorUtils.lavenderMist,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
      ],
    ),
  ),
);

LinearGradient managerViewGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    ColorUtils.lavenderPurple,
    ColorUtils.lavenderMist,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.textWhite,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
    ColorUtils.whiteSmoke,
  ],
);

Container gradientContainer2 = Container(
  height: ScreenUtil().screenHeight,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        ColorUtils.lavenderPurple,
        ColorUtils.lavenderMist,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.textWhite,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
        ColorUtils.whiteSmoke,
      ],
    ),
  ),
);

Color statusColor(String status) {
  switch (status.replaceAll(' ', '').toLowerCase()) {
    case "absent":
      return const Color(0xFFF84E4E);
    case "incomplete":
      return const Color(0xFFF8A24E);
    case "present":
      return const Color(0xFF229B63);
    case "overtime":
      return const Color(0xFF8B0FAE);
    case "offday":
      return const Color(0xFFC6C6C6);
    default:
      return ColorUtils.workEntryHead;
  }
}

Color requestStatusColor(String status) {
  switch(status.toLowerCase()) {
    case "pending": return const Color(0xFFF8A24E);
    case "pardon": return const Color(0xFF50BC61);
    case "approved": return const Color(0xFF50BC61);
    case "completed": return const Color(0xFF50BC61);
    case "fine": return const Color(0xFFD40000);
    case "rejected": return const Color(0xFFD40000);
    case "high": return ColorUtils.high;
    case "medium": return ColorUtils.medium;
    case "low": return ColorUtils.low;
    default: return Colors.grey;
  }
}

String employeeNameShortForm(String empName) {
  if (empName.trim().isEmpty) return '';

  final parts = empName
      .trim()
      .toUpperCase()
      .split(RegExp(r'\s+'));

  if (parts.length == 1) {
    return parts[0][0];
  }

  String out = '${parts[0][0]}${parts[1][0]}';

  return out.trim().isNotEmpty ? out : '';
}

SystemUiOverlayStyle systemUiOverlayStyleDark = SystemUiOverlayStyle(
  systemNavigationBarColor: ColorUtils.workEntryHead,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarIconBrightness: Brightness.light,
);

SystemUiOverlayStyle systemUiOverlayStyleLight = SystemUiOverlayStyle(
  systemNavigationBarColor: ColorUtils.textWhite,
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  systemStatusBarContrastEnforced: false,
  systemNavigationBarIconBrightness: Brightness.dark,
);

String getFullName({String? nickName, String? firstName, String? lastName}) {
  String name = '';
  if (nickName != null && nickName.isNotEmpty) {
    name = nickName.trim();
  } else if (firstName != null && firstName.isNotEmpty) {
    name = firstName.trim();
    if (lastName != null && lastName.isNotEmpty) {
      name += ' ${lastName.trim()}';
    }
  } else if (lastName != null && lastName.isNotEmpty) {
    name = lastName.trim();
  }
  return name;
}

PageRouteBuilder fadeNavigation(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (_, animation, __) => child,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

PageRouteBuilder newSlideNavigation(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

PageRouteBuilder newSlideFromBottomNavigation(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

PageRouteBuilder newSlideFromLeftNavigation(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
