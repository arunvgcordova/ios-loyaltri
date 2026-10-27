
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:loyaltri_minimal/View/CWidgets/cwidgets.dart';
import 'package:loyaltri_minimal/View/CWidgets/error_dialog.dart';
import 'package:loyaltri_minimal/View/Home_Page/home_widgets/locationPermissionDialogue.dart';
import 'package:loyaltri_minimal/View/field/features/tracking/tracker_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:loyaltri_minimal/View/Work_Entry/work_entry_widgets/alert_dialogue.dart';
import 'package:loyaltri_minimal/controller/attendanceUploadController.dart';
import 'package:loyaltri_minimal/controller/locationFetchController.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';
import 'package:loyaltri_minimal/models/checkIn_model.dart';
import 'package:loyaltri_minimal/utils/color_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;
import '../../controller/network_controller.dart';
import '../../controller/ui_controller/home_controller.dart';
import '../../controller/userAuthentication.dart';
import '../../main.dart';
import '../../models/user_profile_api_model.dart';
import '../../services/attachment_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/flutter_secure_storage.dart';
import '../menu_page.dart';

class CameraCheckInView extends StatefulWidget {
  final String whichCheck;
  final bool isCheckIn;
  final bool showTimer;
  const CameraCheckInView({super.key, required this.whichCheck, required this.isCheckIn, required this.showTimer});

  @override
  State<CameraCheckInView> createState() => _CameraCheckInViewState();
}

class _CameraCheckInViewState extends State<CameraCheckInView> with WidgetsBindingObserver {
  AttendanceUploadController attendanceUploadController =
      Get.find<AttendanceUploadController>();
  UserAuthController userAuthController = Get.find<UserAuthController>();
  LocationFetchController locationFetchController = Get.find<LocationFetchController>();
  CameraController? _cameraController;
  ValueNotifier<File?> image = ValueNotifier(null);
  ValueNotifier<bool> isControllerInitialized = ValueNotifier(false);
  ValueNotifier<bool> loader = ValueNotifier(false);
  ValueNotifier<String> faceMessage = ValueNotifier("");
  ValueNotifier<Color> faceMessageColor = ValueNotifier(const Color(0xFF3F3F3F).withOpacity(0.5));
  ValueNotifier<int> seconds = ValueNotifier(0);
  static const int startSeconds = 60; // 1 minute
  ValueNotifier<int> remainingSeconds = ValueNotifier(startSeconds);
  Timer? timer;
  bool _isPermissionDialogOpen = false;
  // ValueNotifier<List<Face>> allFaces = ValueNotifier([]);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    if (cameras != null && cameras!.isNotEmpty) {
      CameraDescription selectedCamera = cameras!.first;
      for (var camera in cameras!) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }
      _cameraController = CameraController(selectedCamera, ResolutionPreset.high,
          enableAudio: false);
      initializeCamera();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPermissionDialogue(mainContext: context, title: "Camera not available", subTitle: "No camera hardware detected or camera list is empty.");
      });
    }
    if(widget.showTimer) {
      startTimer();
    }
    super.initState();
  }

  void startTimer() {
    timer?.cancel(); // cancel any existing timer
    remainingSeconds.value = startSeconds;

    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          t.cancel();
          doTask(); // Call your task here when time is zero
        }
      });
    });
  }

  void doTask() {
    _cameraController?.dispose();
    Navigator.of(context).pushAndRemoveUntil(
      newSlideNavigation(const MenuPage(afterCheck: true)),
            (route) => false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _restoreBrightness();
    timer?.cancel();
    super.dispose();
  }

  void _restoreBrightness() {
    Future.microtask(() async {
      await locationFetchController.restoreBrightness();
    });
  }

  Future initializeCamera() async {
    if (_cameraController == null) return;
    try {
      await _cameraController!.initialize();
      isControllerInitialized.value = true;
      await _cameraController!.setFlashMode(FlashMode.off);
    } on CameraException catch(e) {
      if(!mounted) return;
      _isPermissionDialogOpen = true;
      await showPermissionDialogue(mainContext: context, title: "Camera permission required.", subTitle: "Please enable camera permission.");
      _isPermissionDialogOpen = false;
    }
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (isControllerInitialized.value == false) {
        bool granted = await Permission.camera.isGranted;
        if (granted) {
          if (_isPermissionDialogOpen) {
            Navigator.of(context).pop(); // Dismiss the dialog
          }
          await initializeCamera();
        }
      }
    }
  }


  Future<File> flipImageHorizontallyIfNeeded(XFile xfile, bool isFrontCamera) async {
    if (!isFrontCamera) return File(xfile.path);

    final bytes = await xfile.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return File(xfile.path); // fallback

    final flipped = img.flipHorizontal(originalImage);
    final flippedFile = File(xfile.path)..writeAsBytesSync(img.encodeJpg(flipped));
    return flippedFile;
  }

  // InputImageRotation rotationIntToImageRotation(int rotation) {
  //   switch (rotation) {
  //     case 90:
  //       return InputImageRotation.rotation90deg;
  //     case 180:
  //       return InputImageRotation.rotation180deg;
  //     case 270:
  //       return InputImageRotation.rotation270deg;
  //     default:
  //       return InputImageRotation.rotation0deg;
  //   }
  // }

  // Future<dynamic> faceDetectionFromFile({required CameraImage cameraImage}) async {
  //   InputImageMetadata _firebaseImageMetadata = InputImageMetadata(
  //     size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
  //     rotation: rotationIntToImageRotation(
  //         _cameraController.description.sensorOrientation),
  //     format: InputImageFormat.bgra8888,
  //     bytesPerRow: cameraImage.planes.first.bytesPerRow,
  //   );
  //
  //   final WriteBuffer allBytes = WriteBuffer();
  //   for (final Plane plane in cameraImage.planes) {
  //     allBytes.putUint8List(plane.bytes);
  //   }
  //   final bytes = allBytes.done().buffer.asUint8List();
  //
  //   final inputImage = InputImage.fromBytes(bytes: bytes, metadata: _firebaseImageMetadata);
  //   // final inputImage = InputImage.fromFile(File(cameraImage));
  //
  //   final faceDetector = FaceDetector(
  //     options: FaceDetectorOptions(
  //       performanceMode: FaceDetectorMode.accurate,
  //     ),
  //   );
  //
  //   try {
  //     allFaces.value = await faceDetector.processImage(inputImage);
  //     if(allFaces.value.isEmpty) {
  //       faceMessage.value = "Face not fount";
  //       faceMessageColor.value = Colors.red;
  //     }
  //     print('-----------------boundingBox----center--distance-------${allFaces.value.first.boundingBox.center.distance.w}');
  //     print('-----------------boundingBox----center-----dx--------${allFaces.value.first.boundingBox.center.dx.w}');
  //     print('-----------------boundingBox----center-----dy--------${allFaces.value.first.boundingBox.center.dy.w}');
  //     if(allFaces.value.first.boundingBox.center.distance > 550.w && allFaces.value.first.boundingBox.center.distance < 900.w &&
  //         allFaces.value.first.boundingBox.center.dx > 250.w && allFaces.value.first.boundingBox.center.dx < 500.w &&
  //         allFaces.value.first.boundingBox.center.dy > 500.w && allFaces.value.first.boundingBox.center.dy < 750.w) {
  //       if(allFaces.value.first.headEulerAngleZ != null) {
  //         if(allFaces.value.first.headEulerAngleZ! < 10.w) {
  //           if (image.value == null) {
  //             faceMessage.value = "Capturing face";
  //             faceMessageColor.value = Colors.green;
  //           }
  //           seconds.value++;
  //           // return faces;
  //           await Future.delayed(const Duration(seconds: 1));
  //           // if(seconds.value > 20 && seconds.value < 30) {
  //             if (image.value == null) {
  //               XFile imageFile = await _cameraController.takePicture();
  //               image.value = File(imageFile.path);
  //               if (allFaces.value.length == 1) {
  //                 faceMessage.value = "Processing...";
  //                 Directory? directory = await getDownloadsDirectory();
  //                 String imagePath = '${directory!.path}/faceImg.jpg';
  //                 final prossImg = InputImage.fromFile(File(imageFile.path));
  //                 List<Face> faces = await faceDetector.processImage(prossImg);
  //                 if(faces.length == 1) {
  //                   if(faces.first.boundingBox.center.distance > 550.w && faces.first.boundingBox.center.distance < 900.w &&
  //                       faces.first.boundingBox.center.dx > 250.w && faces.first.boundingBox.center.dx < 500.w &&
  //                       faces.first.boundingBox.center.dy > 500.w && faces.first.boundingBox.center.dy < 750.w) {
  //                     await image.value!.copy(imagePath);
  //                     await SharedPrefs().setFace(imagePath);
  //                     bottomSheetShow(context, faces);
  //                   } else {
  //                     image.value = null;
  //                   }
  //                 } else {
  //                   image.value = null;
  //                 }
  //               } else {
  //                 image.value = null;
  //               }
  //             }
  //           // } else if(seconds.value > 31) {
  //           //   seconds.value = 0;
  //           // }
  //         }
  //       } else {
  //         if (image.value == null) {
  //           faceMessage.value = "Capturing face";
  //           faceMessageColor.value = Colors.green;
  //         }
  //         seconds.value++;
  //         // return faces;
  //         await Future.delayed(const Duration(seconds: 1));
  //         // if(seconds.value > 20 && seconds.value < 30) {
  //           if (image.value == null) {
  //             XFile imageFile = await _cameraController.takePicture();
  //             image.value = File(imageFile.path);
  //             if (allFaces.value.length == 1) {
  //               faceMessage.value = "Processing...";
  //               Directory? directory = await getDownloadsDirectory();
  //               String imagePath = '${directory!.path}/faceImg.jpg';
  //               final prossImg = InputImage.fromFile(File(imageFile.path));
  //               List<Face> faces = await faceDetector.processImage(prossImg);
  //               if(faces.length == 1) {
  //                 if(faces.first.boundingBox.center.distance > 550.w && faces.first.boundingBox.center.distance < 900.w &&
  //                     faces.first.boundingBox.center.dx > 250.w && faces.first.boundingBox.center.dx < 500.w &&
  //                     faces.first.boundingBox.center.dy > 500.w && faces.first.boundingBox.center.dy < 750.w) {
  //                   await image.value!.copy(imagePath);
  //                   await SharedPrefs().setFace(imagePath);
  //                   bottomSheetShow(context, faces);
  //                 } else {
  //                   image.value = null;
  //                 }
  //               } else {
  //                 image.value = null;
  //               }
  //             } else {
  //               image.value = null;
  //             }
  //           }
  //         // } else if(seconds.value > 31) {
  //         //   seconds.value = 0;
  //         // }
  //         // return faces;
  //       }
  //     } else {
  //       seconds.value = 0;
  //     }
  //     if (image.value == null) {
  //       if(allFaces.value.isEmpty) {
  //         faceMessage.value = "Face not fount";
  //         faceMessageColor.value = Colors.red;
  //       } else if(allFaces.value.isNotEmpty && allFaces.value.length > 1) {
  //         faceMessage.value = "Multiple faces fount";
  //         faceMessageColor.value = Colors.red;
  //       } else {
  //         if(allFaces.value.first.boundingBox.center.dx > 250.w && allFaces.value.first.boundingBox.center.dx < 500.w) {
  //           faceMessage.value = "Keep face inside the ellipse";
  //           faceMessageColor.value = Colors.red;
  //         } else if(allFaces.value.first.boundingBox.center.dy > 500.w && allFaces.value.first.boundingBox.center.dy < 750.w) {
  //           faceMessage.value = "Keep face inside the ellipse";
  //           faceMessageColor.value = Colors.red;
  //         }
  //         if(allFaces.value.first.headEulerAngleZ != null) {
  //           if(allFaces.value.first.headEulerAngleZ! > 10.w) {
  //             faceMessage.value = "Please keep proper straight face";
  //             faceMessageColor.value = Colors.red;
  //           }
  //         }
  //       }
  //     }
  //     // return faces;
  //   } catch (e) {
  //     print("Error during face detection: $e");
  //     return [];
  //   } finally {
  //     isCompleted.value = true;
  //     faceDetector.close();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // transparent status bar
        statusBarIconBrightness: Brightness.light, // dark icons
        statusBarBrightness: Brightness.light, // iOS
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              SizedBox(
                width: ScreenUtil().screenWidth,
                child: ValueListenableBuilder(
                  valueListenable: image,
                  builder: (BuildContext context, value, Widget? child) {
                    if (value == null) {
                      return ValueListenableBuilder(
                        valueListenable: isControllerInitialized,
                        builder: (BuildContext context, value, Widget? child) {
                          if (value) {
                            return CameraPreview(_cameraController!);
                          } else {
                            return Container();
                          }
                        },
                      );
                    } else {
                      return Image.file(value);
                    }
                  },
                ),
              ),
              // ValueListenableBuilder(
              //   valueListenable: isControllerInitialized,
              //   builder: (BuildContext context, value, Widget? child) {
              //     if (value) {
              //       return ValueListenableBuilder(
              //         valueListenable: image,
              //         builder: (BuildContext context, value, Widget? child) {
              //           if (value == null) {
              //             return Align(
              //               alignment: Alignment.center,
              //               child: ColorFiltered(
              //                 colorFilter: ColorFilter.mode(
              //                     const Color(0xFF3F3F3F).withValues(alpha: 0.5),
              //                     BlendMode
              //                         .srcOut), // This one will create the magic
              //                 child: Stack(
              //                   fit: StackFit.expand,
              //                   children: [
              //                     Container(
              //                       decoration: const BoxDecoration(
              //                           color: Colors.black,
              //                           backgroundBlendMode: BlendMode
              //                               .dstOut), // This one will handle background + difference out
              //                     ),
              //                     Positioned(
              //                       top: ScreenUtil().screenHeight / 6,
              //                       left: 0.h,
              //                       right: 0.h,
              //                       child: Center(
              //                         child: Container(
              //                           width: 280.w,
              //                           height: 350.h,
              //                           decoration: BoxDecoration(
              //                             color: Colors.blue, // Background color of the ellipse
              //                             shape: BoxShape.rectangle,
              //                             borderRadius: BorderRadius.all(Radius.elliptical(140.w, 175.h)), // Adjust the radius to control the ellipse shape
              //                           ),
              //                         ),
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             );
              //           } else {
              //             return Container();
              //           }
              //         },
              //       );
              //     } else {
              //       return Container();
              //     }
              //   },
              // ),
              ValueListenableBuilder(
                valueListenable: isControllerInitialized,
                builder: (BuildContext context, value, Widget? child) {
                  if (value) {
                    return ValueListenableBuilder(
                      valueListenable: image,
                      builder: (BuildContext context, value, Widget? child) {
                        if (value == null) {
                          return Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: ScreenUtil().screenWidth,
                              height: ScreenUtil().screenHeight,
                              child: CustomPaint(
                                painter: CameraEllipse(),
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    if (image.value == null) {
                      XFile imageFile = await _cameraController!.takePicture();
                      bool isFront = _cameraController!.description.lensDirection == CameraLensDirection.front;

                      File finalImage = await flipImageHorizontallyIfNeeded(imageFile, isFront);
                      image.value = finalImage;
                      // List<Face> faces =
                      //     await faceDetectionFromFile(cameraImage: imageFile.path);
                      // if (faces.length == 1) {
                      //   Directory? directory = await getDownloadsDirectory();
                      //   String imagePath = '${directory!.path}/faceImg.jpg';
                      //   await image.value!.copy(imagePath);
                      //   await SharedPrefs().setFace(imagePath);
                      // }
                      await bottomSheetShow(context);
                      image.value = null;
                    }
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: 130.w,
                    color: Colors.black,
                    // child: Center(
                    //   child: ValueListenableBuilder(
                    //     valueListenable: faceMessage,
                    //     builder: (BuildContext context, String value, Widget? child) {
                    //       return Text(
                    //         value,
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.inter(
                    //           color: ColorUtils.textWhite,
                    //           fontWeight: FontWeight.w800,
                    //           fontSize: 18.sp,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 60.w,
                          height: 60.w,
                          color: Colors.transparent,
                        ),
                        Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100).w,
                            color: ColorUtils.textWhite,
                          ),
                          child: Center(
                            child: Container(
                              width: 50.w,
                              height: 50.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100).w,
                                color: Colors.black,
                              ),
                              child: Center(
                                child: Container(
                                  width: 48.w,
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100).w,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 60.w,
                          height: 60.w,
                          color: Colors.transparent,
                          child: widget.showTimer
                              ? Center(
                                child: ValueListenableBuilder(
                                valueListenable: remainingSeconds,
                                builder: (context, value, child) {
                                  return Text(
                                    value.toString(),
                                    style: GoogleFonts.inter(
                                      color: ColorUtils.textWhite,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                    ),
                                  );
                                },
                                                          ),
                              )
                              : SizedBox(),
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
                    padding: const EdgeInsets.only(
                            top: 8, bottom: 8, left: 10, right: 20)
                        .w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () async {
                            if(locationFetchController.isBrightnessIncreased) {
                              await locationFetchController.restoreBrightness();
                            } else {
                              await locationFetchController.increaseBrightnessTemporarily();
                            }
                          },
                          icon: SvgPicture.asset("assets/images/thunder.svg"),
                        ),
                        TextButton(
                          onPressed: () {
                            isControllerInitialized.value = false;
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
      ),
    );
  }

  Future<void> bottomSheetShow(context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      // barrierColor: ColorUtils.workEntryHead.withOpacity(0.81),
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 15).h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // if (faces.length == 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // allFaces.value = [];
                        image.value = null;
                      },
                      child: Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: ColorUtils.workEntryHead.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16).w,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/images/ArrowClockwise.svg",
                              ),
                              Text(
                                "Retake",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.sp,
                                  color: ColorUtils.textWhite.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: ScreenUtil().screenWidth,
                  // height: 200.w,
                  decoration: BoxDecoration(
                    color: ColorUtils.backgroundBlack,
                    borderRadius: BorderRadius.circular(20).w,
                    border: Border.all(
                      width: 1.w,
                      color: const Color(0xFF404040),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Flexible(flex: 1, child: Container()),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 10, bottom: 10)
                            .w,
                        child: Row(
                          children: [
                            Text(
                              "Mark ${widget.whichCheck}",
                              style: GoogleFonts.poppins(
                                color: ColorUtils.textWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Flexible(flex: 2, child: Container()),
                      GetX<LocationFetchController>(
                        builder: (LocationFetchController controller) {
                          if(controller.locName.value != null && (controller.locName.value?.isNotEmpty ?? false)) {
                            return Padding(
                              padding:
                              const EdgeInsets.only(left: 15, right: 15, top: 8)
                                  .w,
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/images/4dots.svg"),
                                  const Spacer(),
                                  SizedBox(
                                    width: ScreenUtil().screenWidth * 0.6,
                                    child: Text(
                                      "${controller.locName.value}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        color: ColorUtils.textWhite,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  const Spacer(flex: 4),
                                  Image.asset(
                                    "assets/images/navigation-3d.webp",
                                    width: 25.w,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 5)
                            .w,
                        child: GetX<UserProfileController>(
                          builder: (UserProfileController controller) {
                            List<ShiftData>? shift = controller
                                .userData.value.result.employeeShift;
                            if (shift != null) {
                              return Row(
                                children: [
                                  Text(
                                    shift.isNotEmpty
                                        ? shift.first.shift
                                        : "No Shift",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.sp,
                                      color: ColorUtils.textWhite
                                          .withOpacity(0.6),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Container(
                                    // height: 22.w,
                                    decoration: BoxDecoration(
                                        color: ColorUtils.textWhite
                                            .withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(38).w),
                                    padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                        top: 3,
                                        bottom: 3)
                                        .w,
                                    child: Text(
                                      shift.isNotEmpty
                                          ? shift.first.shiftTimeRemarks ?? "----"
                                          : "----",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp,
                                        color: ColorUtils.textWhite,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15).w,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/calendar2-3d.webp",
                              width: 20.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat('dd MMM yyyy')
                                  .format(DateTime.now()),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Image.asset(
                              "assets/images/attendance-3d.webp",
                              width: 20.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "Time",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite.withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              DateFormat('hh:mm a').format(DateTime.now()),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                                color: ColorUtils.textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0).w,
                        child: ValueListenableBuilder(
                          valueListenable: loader,
                          builder: (BuildContext context, bool value, Widget? child) {
                            if(value) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0).w,
                                child: Container(
                                  width: 46.w,
                                  height: 46.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100).w,
                                    color: ColorUtils.textWhite,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0).w,
                                    child: const CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            } else {
                              return SwipeButton(
                                elevationThumb: 2,
                                elevationTrack: 2,
                                activeThumbColor: ColorUtils.textWhite,
                                activeTrackColor: const Color(0xFF6434ED),
                                thumbPadding: const EdgeInsets.all(3).w,
                                thumb: Container(
                                  padding: const EdgeInsets.all(10).w,
                                  child: SvgPicture.asset(
                                    "assets/images/finger_print.svg",
                                    width: 20.w,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                child: Text(
                                  "Swipe to ${widget.whichCheck}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    color: ColorUtils.textWhite,
                                  ),
                                ),
                                onSwipe: () async {
                                  loader.value = true;
                                  DateTime punchDate = DateTime.now();
                                  final SecureStorageUtils prefs = SecureStorageUtils();
                                  // await locationFetchController.fetchLocationData();
                                  // bool value = await attendanceUploadController
                                  //     .sendFaceData();
                                  // bool connection = await ConnectivityService().check();
                                  // if(!connection) {
                                  //   Navigator.of(context).pop();
                                  //   await ErrorDialog().internetWarn(
                                  //     context: context,
                                  //     title: "No Internet Connection",
                                  //     subTitle: "Please check if your connection is stable.",
                                  //   );
                                  // } else {
                                  if (image.value != null) {
                                    String? latitude = locationFetchController.position.value?.latitude.toString();
                                    String? longitude = locationFetchController.position.value?.longitude.toString();
                                    String? locName = locationFetchController.locName.value;

                                    try {
                                      if((latitude == null || latitude == 'null') && (longitude == null || longitude == 'null')) {
                                        Position? position = await locationFetchController.fetchCurrentLocation();
                                        latitude = position?.latitude.toString();
                                        longitude = position?.longitude.toString();
                                      }

                                      if(locName == null) {
                                        String? locationName = await locationFetchController.fetchCurrentLocName(lat: latitude!, long: longitude!);
                                        locName = locationName;
                                      }
                                    } catch(e) {}

                                    // await locationFetch.fetchLocationData();
                                    if(latitude != null && longitude != null) {
                                      String? punchTime = await prefs.getString("punch");

                                      String? filePath = await AttachmentService.saveFaceImage(punchDate: punchDate, image: image.value);

                                      AttendanceCheckModel attData =
                                      AttendanceCheckModel(
                                        employeeId: userAuthController
                                            .userData.value.userData?.employeeId ?? '--',
                                        companyId: Get.find<UserProfileController>().userData.value.result.companyId?.toString() ?? '',
                                        punchDate: DateFormat('yyyy-MM-dd')
                                            .format(punchDate),
                                        punchTime:
                                        DateFormat('HH:mm:ss').format(punchDate),
                                        latitude: latitude,
                                        longitude: longitude,
                                        punchImage: filePath,
                                        locationName: locName,
                                        punchState: widget.isCheckIn ? "punchIn" : "punchOut",
                                      );
                                      await attendanceUploadController
                                          .sendAttendance(attendance: attData);
                                          final trackingCtr = Get.isRegistered<TrackingController>()
                                                        ? Get.find<TrackingController>()
                                                         : Get.put(TrackingController());
                                          final workStatus =await  trackingCtr.checkEmployeWorkStatus();
                                          if(workStatus){
                                            loader.value = false;
                                            return;
                                          }
                                      if (attendanceUploadController
                                          .errorMsg.value == null) {
                                        if(punchTime != null) {
                                          await prefs.remove('punch');
                                        }
                                        // await Get.find<HomeController>().getHomeData();
                                        if (punchTime != null) {
                                          // await prefs.remove("punch");
                                          await HapticFeedback.lightImpact();
                                          if (!mounted) return;
                                          ShowWarnDialog().showWarn(
                                              context: context,
                                              whichCheck: widget.whichCheck);
                                          Timer.periodic(const Duration(seconds: 3),
                                                  (timer) {
                                                timer.cancel();
                                                _cameraController?.dispose();
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    newSlideNavigation(const MenuPage(afterCheck: true)),
                                                        (route) => false);
                                              });
                                        } else {
                                          // await prefs.setString(
                                          //     "punch", "$punchDate");
                                          await HapticFeedback.lightImpact();
                                          if (!mounted) return;
                                          ShowWarnDialog().showWarn(
                                              context: context,
                                              whichCheck: widget.whichCheck);
                                          Timer.periodic(const Duration(seconds: 3),
                                                  (timer) {
                                                timer.cancel();
                                                _cameraController?.dispose();
                                                Navigator.of(context).pushAndRemoveUntil(
                                                    newSlideNavigation(const MenuPage(afterCheck: true)),
                                                        (route) => false);
                                              });
                                        }
                                      } else {
                                        await HapticFeedback.lightImpact();
                                        String? msg = Get.find<AttendanceUploadController>().errorMsg.value == 'msg' ? "${punchTime == null ? 'Check in' : 'Check out'} is not allowed within 3 minutes after ${punchTime == null ? 'checkout' : 'check in'}. Please try again later." : null;
                                        if (!mounted) return;
                                        ErrorDialog().showWarn(
                                            context: context,
                                            title: punchTime == null
                                                ? "Check In Failed!"
                                                : "Check Out Failed!",
                                            subTitle: msg ?? "Something went wrong");
                                      }
                                    } else {
                                      ErrorDialog().showWarn(context: context, title: "Failed", subTitle: "Location data not fetched.");
                                      await locationFetchController.initialize();
                                    }
                                  }
                                  // }
                                  loader.value = false;
                                },
                              );
                            }
                          },
                        ),
                      )
                      // Flexible(flex: 1, child: Container()),
                    ],
                  ),
                ),
                // if (faces.isEmpty)
                //   Padding(
                //     padding: EdgeInsets.only(
                //             left: 10,
                //             right: 10,
                //             bottom: 15,
                //             top: ScreenUtil().screenHeight * 0.6)
                //         .w,
                //     child: Container(
                //       width: ScreenUtil().screenWidth,
                //       height: 200.w,
                //       decoration: BoxDecoration(
                //         color: ColorUtils.backgroundBlack,
                //         borderRadius: BorderRadius.circular(20).w,
                //         border: Border.all(
                //           width: 1.w,
                //           color: const Color(0xFF404040),
                //         ),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Face not found",
                //           style: GoogleFonts.poppins(
                //             color: ColorUtils.textWhite,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 18.sp,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // if (faces.length > 1)
                //   Padding(
                //     padding: EdgeInsets.only(
                //             left: 10,
                //             right: 10,
                //             bottom: 15,
                //             top: ScreenUtil().screenHeight * 0.6)
                //         .w,
                //     child: Container(
                //       width: ScreenUtil().screenWidth,
                //       height: 200.w,
                //       decoration: BoxDecoration(
                //         color: ColorUtils.backgroundBlack,
                //         borderRadius: BorderRadius.circular(20).w,
                //         border: Border.all(
                //           width: 1.w,
                //           color: const Color(0xFF404040),
                //         ),
                //       ),
                //       child: Center(
                //         child: Text(
                //           "Multiple faces detected",
                //           style: GoogleFonts.poppins(
                //             color: ColorUtils.textWhite,
                //             fontWeight: FontWeight.w600,
                //             fontSize: 18.sp,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CameraEllipse extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final layer = canvas.saveLayer(
      Offset.zero & size,
      Paint(),
    );
    final overlayPaint = Paint()
      ..color = const Color(0xFF3F3F3F).withValues(alpha: 0.55);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      overlayPaint,
    );
    final clearPaint = Paint()
      ..blendMode = BlendMode.clear;
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height * 0.4), // CENTERED
      width: size.width * 0.70,
      height: size.height * 0.48,
    );
    canvas.drawOval(ovalRect, clearPaint);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
