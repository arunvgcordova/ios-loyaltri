import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loyaltri_minimal/View/ManagerView/Manager_Attendance/attendance_widgets_manager/common_widgets.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../main.dart';
import 'package:image/image.dart' as img;

import '../../Home_Page/home_widgets/permissionPopUp.dart';

class CameraViewLeave extends StatefulWidget {
  const CameraViewLeave({super.key});

  @override
  State<CameraViewLeave> createState() => _CameraViewLeaveState();
}

class _CameraViewLeaveState extends State<CameraViewLeave> {
  late CameraController _cameraController;
  bool isControllerInitialized = false;
  File? image;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      _cameraController = CameraController(
        cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();
      isControllerInitialized = true;
      await _cameraController.setFlashMode(FlashMode.off);

      setState(() {});
    } catch (e) {
      await permissionCheck();
    }
  }

  Future<void> permissionCheck() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      await initializeCamera();
      return;
    }

    final result = await Permission.camera.request();

    if (result.isGranted) {
      await initializeCamera();
      return;
    }

    final resp = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PermissionPopup(),
    );

    if (resp == true) {
      await openAppSettings().whenComplete(() {
        Navigator.of(context).pop();
      });
    } else {
      Navigator.of(context).pop();
    }
  }


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
              width: ScreenUtil().screenWidth,
              child:
                  isControllerInitialized
                      ? image == null
                          ? CameraPreview(_cameraController)
                          : Image.file(image!)
                      : Container(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:
                  image == null
                      ? Container(
                        width: ScreenUtil().screenWidth,
                        height: 130.w,
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.cameraswitch_outlined,
                                color: Colors.transparent,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (image == null) {
                                  try {
                                    XFile file =
                                        await _cameraController.takePicture();
                                    File imageFile = File(file.path);
                                    if (_cameraController
                                            .description
                                            .lensDirection ==
                                        CameraLensDirection.front) {
                                      img.Image originalImage =
                                          img.decodeImage(
                                            imageFile.readAsBytesSync(),
                                          )!;
                                      img.Image flippedImage = img
                                          .flipHorizontal(originalImage);
                                      imageFile.writeAsBytesSync(
                                        img.encodeJpg(flippedImage),
                                      );
                                    }
                                    setState(
                                      () => image = File(imageFile.path),
                                    );
                                  } catch (e) {
                                    AttendanceCommonWidgets().printF(
                                      "-----camera error---------${e.toString()}",
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: 60.w,
                                height: 60.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100).w,
                                  color: ColorUtils.textWhite,
                                ),
                                child: Center(
                                  child: Center(
                                    child: Container(
                                      width: 50.w,
                                      height: 50.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100).w,
                                        color: Colors.black,
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 48.w,
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100).w,
                                            color: ColorUtils.textWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                if (cameras!.length > 1) {
                                  if (_cameraController.description ==
                                      cameras![0]) {
                                    await _cameraController.setDescription(
                                      cameras![1],
                                    );
                                  } else {
                                    await _cameraController.setDescription(
                                      cameras![0],
                                    );
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.cameraswitch_outlined,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                      )
                      : GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          height: 130.w,
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    image = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _cameraController.dispose();
                                  Navigator.pop(context, image!.path);
                                },
                                icon: const Icon(
                                  Icons.done,
                                  color: ColorUtils.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: ScreenUtil().screenWidth,
                height: 80.w,
                color: Colors.black,
                child: Padding(
                  padding:
                      const EdgeInsets.only(
                        top: 8,
                        bottom: 8,
                        left: 10,
                        right: 20,
                      ).w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (_cameraController.value.flashMode ==
                              FlashMode.off) {
                            await _cameraController.setFlashMode(
                              FlashMode.torch,
                            );
                          } else {
                            await _cameraController.setFlashMode(FlashMode.off);
                          }
                        },
                        icon: SvgPicture.asset("assets/images/thunder.svg"),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            image = null;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.inter(
                            color: ColorUtils.textWhite,
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
