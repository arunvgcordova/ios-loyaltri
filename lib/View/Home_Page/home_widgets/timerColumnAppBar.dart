import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/color_utils.dart';

class TimerColumnAppBar extends StatefulWidget {
  final String punchTime;
  const TimerColumnAppBar({super.key, required this.punchTime});

  @override
  State<TimerColumnAppBar> createState() => _TimerColumnAppBarState();
}

class _TimerColumnAppBarState extends State<TimerColumnAppBar> {
  Stream<String> secondTimeStream(String? punchTime) async* {
    DateTime time = DateTime.parse(punchTime!);

    while (true) {
      DateTime currentTime = DateTime.now();
      final timer = currentTime.difference(time);

      yield timer.toString().split('.').first.split(":").last;

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Stream<String> minuteTimeStream(String? punchTime) async* {
    DateTime time = DateTime.parse(punchTime!);

    while (true) {
      DateTime currentTime = DateTime.now();
      final timer = currentTime.difference(time);

      yield timer.toString().split('.').first.split(":")[1];

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Stream<String> hoursTimeStream(String? punchTime) async* {
    DateTime time = DateTime.parse(punchTime!);

    while (true) {
      DateTime currentTime = DateTime.now();
      final timer = currentTime.difference(time);

      if (timer.toString().split('.').first.split(":").first.length == 1) {
        yield "0${timer.toString().split('.').first.split(":").first}";
      } else {
        yield timer.toString().split('.').first.split(":").first;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5).w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6).w,
            child: Text(
              "Duration",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: ColorUtils.textWhite.withOpacity(0.6),
              ),
            ),
          ),
          Row(
            children: [
              StreamBuilder<String>(
                stream: hoursTimeStream(widget.punchTime),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  } else {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5).w,
                child: Text(
                  ":",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
              StreamBuilder<String>(
                stream: minuteTimeStream(widget.punchTime),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  } else {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5).w,
                child: Text(
                  ":",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    color: ColorUtils.textWhite,
                  ),
                ),
              ),
              StreamBuilder<String>(
                stream: secondTimeStream(widget.punchTime),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data!,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 17.sp,
                            color: ColorUtils.textWhite,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  } else {
                    return Container(
                      width: 32.82.w,
                      height: 23.35.w,
                      decoration: BoxDecoration(
                        color: ColorUtils.textWhite.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8).w,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
