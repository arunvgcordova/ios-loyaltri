import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
import 'package:loyaltri_minimal/services/api_services.dart';
import 'package:loyaltri_minimal/controller/userProfileController.dart';

class AttachmentFile {
  final File file;
  final String name;
  final bool isImage;
  final bool isVideo;
  bool isUploading;
  String? serverPath;
  String? error;

  AttachmentFile({
    required this.file,
    required this.name,
    required this.isImage,
    this.isVideo = false,
    this.isUploading = false,
    this.serverPath,
    this.error,
  });
}

class CustomAttachmentWidget extends StatefulWidget {
  const CustomAttachmentWidget({
    super.key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.icon,
    required this.type,
    this.onPathsChanged,
    this.onUploadingStateChanged,
  });

  final String title;
  final String subtitle1;
  final String subtitle2;
  final String icon;
  final String type; // 'file', 'image', 'video'
  final ValueChanged<List<String>>? onPathsChanged;
  final ValueChanged<bool>? onUploadingStateChanged;

  @override
  State<CustomAttachmentWidget> createState() => _CustomAttachmentWidgetState();
}

class _CustomAttachmentWidgetState extends State<CustomAttachmentWidget> {
  final List<AttachmentFile> _selectedFiles = [];

  String _getCompanyId() {
    try {
      final userProfileController = Get.find<UserProfileController>();
      return userProfileController.userData.value.result.companyId
              ?.toString() ??
          '';
    } catch (e) {
      debugPrint('Error getting companyId: $e');
      return '';
    }
  }

  String? _extractPathFromResponse(Map<String, dynamic> response) {
    return response['data']?['file']?['signed_url']?.toString();
  }

  // String? _extractPathFromResponse(Map<String, dynamic> response) {
  //   final data = response['data'] ?? response['result'] ?? response;
  //   if (data is Map<String, dynamic>) {
  //     final pathVal =
  //         data['path'] ?? data['url'] ?? data['file'] ?? data['filePath'];
  //     if (pathVal != null) return pathVal.toString();
  //   }
  //   if (response['path'] != null) return response['path'].toString();
  //   if (response['url'] != null) return response['url'].toString();

  //   for (var entry in response.entries) {
  //     if (entry.value is String) {
  //       final val = entry.value as String;
  //       if (val.startsWith('http') || val.contains('/') || val.contains('\\')) {
  //         return val;
  //       }
  //     }
  //   }
  //   return null;
  // }

  bool _isImageFile(String path) {
    final mimeType = path.toLowerCase();
    return mimeType.endsWith('.jpg') ||
        mimeType.endsWith('.jpeg') ||
        mimeType.endsWith('.png') ||
        mimeType.endsWith('.gif') ||
        mimeType.endsWith('.webp') ||
        mimeType.endsWith('.bmp');
  }

  bool _isVideoFile(String path) {
    final mimeType = path.toLowerCase();
    return mimeType.endsWith('.mp4') ||
        mimeType.endsWith('.mov') ||
        mimeType.endsWith('.avi') ||
        mimeType.endsWith('.mkv') ||
        mimeType.endsWith('.webm') ||
        mimeType.endsWith('.3gp') ||
        mimeType.endsWith('.m4v');
  }

  void _notifyChanges() {
    if (widget.onPathsChanged != null) {
      final uploadedPaths = _selectedFiles
          .where((f) => f.serverPath != null && !f.isUploading)
          .map((f) => f.serverPath!)
          .toList();
      widget.onPathsChanged!(uploadedPaths);
    }
  }

  void _notifyUploadingState() {
    if (widget.onUploadingStateChanged != null) {
      final isUploading = _selectedFiles.any((f) => f.isUploading);
      widget.onUploadingStateChanged!(isUploading);
    }
  }

  Future<void> _addAndUploadFile(File file) async {
    try {
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
      if (fileSizeInMB > 10) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'File "${file.path.split(Platform.pathSeparator).last}" exceeds the 10 MB limit.',
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return;
      }
    } catch (e) {
      debugPrint('Error checking file size: $e');
    }

    final name = file.path.split(Platform.pathSeparator).last;
    final isImage = _isImageFile(file.path);
    final isVideo = _isVideoFile(file.path);

    if (widget.type == 'image' && !isImage) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only image files are allowed.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    if (widget.type == 'video' && !isVideo) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Only video files are allowed.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    final attachment = AttachmentFile(
      file: file,
      name: name,
      isImage: isImage,
      isVideo: isVideo,
      isUploading: true,
    );

    setState(() {
      _selectedFiles.add(attachment);
    });
    _notifyUploadingState();

    _uploadFile(attachment);
  }

  Future<void> _uploadFile(AttachmentFile attachment) async {
    try {
      final compId = _getCompanyId();
      if (compId.isEmpty) {
        throw Exception('Company ID is not available');
      }
      final response = await ApiServices.uploadfile(
        companyId: compId,
        filePath: attachment.file.path,
      );

      final serverPath = _extractPathFromResponse(response);
      if (serverPath != null) {
        setState(() {
          attachment.isUploading = false;
          attachment.serverPath = serverPath;
        });
        _notifyChanges();
        _notifyUploadingState();
      } else {
        setState(() {
          attachment.isUploading = false;
          attachment.error = 'Upload succeeded but no file path was returned.';
        });
        _notifyUploadingState();
      }
    } catch (e) {
      setState(() {
        attachment.isUploading = false;
        attachment.error = e.toString().replaceAll('Exception:', '').trim();
      });
      _notifyUploadingState();
    }
  }

  void _retryUpload(AttachmentFile attachment) {
    setState(() {
      attachment.isUploading = true;
      attachment.error = null;
    });
    _notifyUploadingState();
    _uploadFile(attachment);
  }

  void _removeFile(AttachmentFile attachment) {
    setState(() {
      _selectedFiles.remove(attachment);
    });
    _notifyChanges();
    _notifyUploadingState();
  }

  void _showSourcePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColourUtils.bgColour2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (widget.type != 'video')
                ListTile(
                  leading: Icon(Icons.camera_alt, color: ColourUtils.textWhite),
                  title: Text(
                    'Take Photo',
                    style: GoogleFonts.inter(color: ColourUtils.textWhite,fontSize: 16.h,
                    fontWeight: FontWeight.w500,),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickCameraImage();
                  },
                ),
              if (widget.type == 'video')
                ListTile(
                  leading: Icon(Icons.videocam, color: ColourUtils.textWhite),
                  title: Text(
                    'Record Video',
                    style: GoogleFonts.inter(color: ColourUtils.textWhite,fontSize: 16.h,
                    fontWeight: FontWeight.w500,),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickCameraVideo();
                  },
                ),
              ListTile(
                leading: Icon(
                  widget.type == 'image'
                      ? Icons.photo_library
                      : widget.type == 'video'
                      ? Icons.video_library
                      : Icons.photo_library,
                  color: ColourUtils.textWhite,
                ),
                title: Text(
                  widget.type == 'image'
                      ? 'Upload Images'
                      : widget.type == 'video'
                      ? 'Upload Videos'
                      : 'Upload Files',
                  style: GoogleFonts.inter(color: ColourUtils.textWhite,fontSize: 16.h,
                    fontWeight: FontWeight.w500,),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleFiles();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickCameraImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        _addAndUploadFile(File(image.path));
      }
    } catch (e) {
      debugPrint('Error picking camera image: $e');
    }
  }

  Future<void> _pickCameraVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        _addAndUploadFile(File(video.path));
      }
    } catch (e) {
      debugPrint('Error picking camera video: $e');
    }
  }

  Future<void> _pickMultipleFiles() async {
    try {
      FileType pickerType = FileType.any;
      if (widget.type == 'image') {
        pickerType = FileType.image;
      } else if (widget.type == 'video') {
        pickerType = FileType.video;
      }

      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: pickerType,
      );
      if (result != null) {
        for (final path in result.paths) {
          if (path != null) {
            _addAndUploadFile(File(path));
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking multiple files: $e');
    }
  }

  Widget _buildPreviewList() {
    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedFiles.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final item = _selectedFiles[index];
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80.h,
                height: 80.h,
                decoration: BoxDecoration(
                  color: ColourUtils.textWhite.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: ColourUtils.textWhite.withValues(alpha: 0.1),
                    width: 1.h,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: item.isImage
                      ? Image.file(
                          item.file,
                          fit: BoxFit.cover,
                          width: 80.h,
                          height: 80.h,
                        )
                      : item.isVideo
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              color: ColourUtils.textWhite.withValues(
                                alpha: 0.6,
                              ),
                              size: 28.h,
                            ),
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                item.name,
                                style: GoogleFonts.inter(
                                  color: ColourUtils.textWhite.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 10.h,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              color: ColourUtils.textWhite.withValues(
                                alpha: 0.6,
                              ),
                              size: 28.h,
                            ),
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
                              child: Text(
                                item.name,
                                style: GoogleFonts.inter(
                                  color: ColourUtils.textWhite.withValues(
                                    alpha: 0.6,
                                  ),
                                  fontSize: 10.h,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              if (item.isUploading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: SizedBox(
                        width: 20.h,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.h,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColourUtils.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (item.error != null)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () => _retryUpload(item),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 20.h,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Tap to retry',
                            style: GoogleFonts.inter(
                              color: Colors.redAccent,
                              fontSize: 8.h,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: -5.h,
                right: -5.h,
                child: GestureDetector(
                  onTap: () => _removeFile(item),
                  child: Container(
                    padding: EdgeInsets.all(5.h),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 12.h),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: ColourUtils.bgColour2,
        borderRadius: BorderRadius.all(Radius.circular(15.h)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.inter(
                color: ColourUtils.textWhite,
                fontSize: 14.h,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              // height: 150.h,
              decoration: BoxDecoration(
                color: ColourUtils.textWhite.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColourUtils.textWhite.withValues(alpha: 0.05),
                  width: 1.h,
                  style: BorderStyle.solid,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showSourcePicker(context);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 25.h),
                      SizedBox(
                        height: 35.h,
                        width: 35.h,
                        child: SvgPicture.asset(
                          AssetUtils.svg(widget.icon),
                          color: ColourUtils.textWhite.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.subtitle1,
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite.withValues(alpha: 0.6),
                          fontSize: 15.h,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        widget.subtitle2,
                        style: GoogleFonts.inter(
                          color: ColourUtils.textWhite.withValues(alpha: 0.4),
                          fontSize: 14.h,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (_selectedFiles.isNotEmpty) ...[
                        // SizedBox(height: 10.h),
                        Padding(
                          padding:  EdgeInsets.all(8.h),
                          child: _buildPreviewList(),
                        ),
                      ] else ...[
                        SizedBox(height: 10.h),
                      ],
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

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:get/get.dart';
// import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
// import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
// import 'package:loyaltri_minimal/services/api_services.dart';
// import 'package:loyaltri_minimal/controller/userProfileController.dart';

// class AttachmentFile {
//   final File file;
//   final String name;
//   final bool isImage;
//   bool isUploading;
//   String? serverPath;
//   String? error;

//   AttachmentFile({
//     required this.file,
//     required this.name,
//     required this.isImage,
//     this.isUploading = false,
//     this.serverPath,
//     this.error,
//   });
// }

// class CustomAttachmentWidget extends StatefulWidget {
//   const CustomAttachmentWidget({
//     super.key,
//     required this.title,
//     required this.subtitle1,
//     required this.subtitle2,
//     required this.icon,
//     this.onPathsChanged,
//     this.onUploadingStateChanged,
//   });

//   final String title;
//   final String subtitle1;
//   final String subtitle2;
//   final String icon;
//   final ValueChanged<List<String>>? onPathsChanged;
//   final ValueChanged<bool>? onUploadingStateChanged;

//   @override
//   State<CustomAttachmentWidget> createState() => _CustomAttachmentWidgetState();
// }

// class _CustomAttachmentWidgetState extends State<CustomAttachmentWidget> {
//   final List<AttachmentFile> _selectedFiles = [];

//   String _getCompanyId() {
//     try {
//       final userProfileController = Get.find<UserProfileController>();
//       return userProfileController.userData.value.result.companyId
//               ?.toString() ??
//           '';
//     } catch (e) {
//       debugPrint('Error getting companyId: $e');
//       return '';
//     }
//   }

//   String? _extractPathFromResponse(Map<String, dynamic> response) {
//   return response['data']?['file']?['signed_url']?.toString();
// }

//   // String? _extractPathFromResponse(Map<String, dynamic> response) {
//   //   final data = response['data'] ?? response['result'] ?? response;
//   //   if (data is Map<String, dynamic>) {
//   //     final pathVal =
//   //         data['path'] ?? data['url'] ?? data['file'] ?? data['filePath'];
//   //     if (pathVal != null) return pathVal.toString();
//   //   }
//   //   if (response['path'] != null) return response['path'].toString();
//   //   if (response['url'] != null) return response['url'].toString();

//   //   for (var entry in response.entries) {
//   //     if (entry.value is String) {
//   //       final val = entry.value as String;
//   //       if (val.startsWith('http') || val.contains('/') || val.contains('\\')) {
//   //         return val;
//   //       }
//   //     }
//   //   }
//   //   return null;
//   // }

//   bool _isImageFile(String path) {
//     final mimeType = path.toLowerCase();
//     return mimeType.endsWith('.jpg') ||
//         mimeType.endsWith('.jpeg') ||
//         mimeType.endsWith('.png') ||
//         mimeType.endsWith('.gif') ||
//         mimeType.endsWith('.webp') ||
//         mimeType.endsWith('.bmp');
//   }

//   void _notifyChanges() {
//     if (widget.onPathsChanged != null) {
//       final uploadedPaths = _selectedFiles
//           .where((f) => f.serverPath != null && !f.isUploading)
//           .map((f) => f.serverPath!)
//           .toList();
//       widget.onPathsChanged!(uploadedPaths);
//     }
//   }

//   void _notifyUploadingState() {
//     if (widget.onUploadingStateChanged != null) {
//       final isUploading = _selectedFiles.any((f) => f.isUploading);
//       widget.onUploadingStateChanged!(isUploading);
//     }
//   }

//   Future<void> _addAndUploadFile(File file) async {
//     try {
//       final fileSizeInBytes = await file.length();
//       final fileSizeInMB = fileSizeInBytes / (1024 * 1024);
//       if (fileSizeInMB > 10) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'File "${file.path.split(Platform.pathSeparator).last}" exceeds the 10 MB limit.',
//               ),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }
//         return;
//       }
//     } catch (e) {
//       debugPrint('Error checking file size: $e');
//     }

//     final name = file.path.split(Platform.pathSeparator).last;
//     final isImage = _isImageFile(file.path);
//     final attachment = AttachmentFile(
//       file: file,
//       name: name,
//       isImage: isImage,
//       isUploading: true,
//     );

//     setState(() {
//       _selectedFiles.add(attachment);
//     });
//     _notifyUploadingState();

//     _uploadFile(attachment);
//   }

//   Future<void> _uploadFile(AttachmentFile attachment) async {
//     try {
//       final compId = _getCompanyId();
//       if (compId.isEmpty) {
//         throw Exception('Company ID is not available');
//       }
//       final response = await ApiServices.uploadfile(
//         companyId: compId,
//         filePath: attachment.file.path,
//       );

//       final serverPath = _extractPathFromResponse(response);
//       if (serverPath != null) {
//         setState(() {
//           attachment.isUploading = false;
//           attachment.serverPath = serverPath;
//         });
//         _notifyChanges();
//         _notifyUploadingState();
//       } else {
//         setState(() {
//           attachment.isUploading = false;
//           attachment.error = 'Upload succeeded but no file path was returned.';
//         });
//         _notifyUploadingState();
//       }
//     } catch (e) {
//       setState(() {
//         attachment.isUploading = false;
//         attachment.error = e.toString().replaceAll('Exception:', '').trim();
//       });
//       _notifyUploadingState();
//     }
//   }

//   void _retryUpload(AttachmentFile attachment) {
//     setState(() {
//       attachment.isUploading = true;
//       attachment.error = null;
//     });
//     _notifyUploadingState();
//     _uploadFile(attachment);
//   }

//   void _removeFile(AttachmentFile attachment) {
//     setState(() {
//       _selectedFiles.remove(attachment);
//     });
//     _notifyChanges();
//     _notifyUploadingState();
//   }

//   void _showSourcePicker(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: ColourUtils.bgColour2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
//       ),
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Wrap(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.camera_alt, color: ColourUtils.textWhite),
//                 title: Text(
//                   'Take Photo',
//                   style: GoogleFonts.inter(color: ColourUtils.textWhite),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickCameraImage();
//                 },
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.photo_library,
//                   color: ColourUtils.textWhite,
//                 ),
//                 title: Text(
//                   'Upload Files',
//                   style: GoogleFonts.inter(color: ColourUtils.textWhite),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _pickMultipleFiles();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> _pickCameraImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 80,
//       );
//       if (image != null) {
//         _addAndUploadFile(File(image.path));
//       }
//     } catch (e) {
//       debugPrint('Error picking camera image: $e');
//     }
//   }

//   Future<void> _pickMultipleFiles() async {
//     try {
//       final FilePickerResult? result = await FilePicker.platform.pickFiles(
//         allowMultiple: true,
//         type: FileType.any,
//       );
//       if (result != null) {
//         for (final path in result.paths) {
//           if (path != null) {
//             _addAndUploadFile(File(path));
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint('Error picking multiple files: $e');
//     }
//   }

//   Widget _buildPreviewList() {
//     return SizedBox(
//       height: 80.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: _selectedFiles.length,
//         separatorBuilder: (context, index) => SizedBox(width: 10.w),
//         itemBuilder: (context, index) {
//           final item = _selectedFiles[index];
//           return Stack(
//             clipBehavior: Clip.none,
//             children: [
//               Container(
//                 width: 80.h,
//                 height: 80.h,
//                 decoration: BoxDecoration(
//                   color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(10.r),
//                   border: Border.all(
//                     color: ColourUtils.textWhite.withValues(alpha: 0.1),
//                     width: 1.h,
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(10.r),
//                   child: item.isImage
//                       ? Image.file(
//                           item.file,
//                           fit: BoxFit.cover,
//                           width: 80.h,
//                           height: 80.h,
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.insert_drive_file,
//                               color: ColourUtils.textWhite.withValues(
//                                 alpha: 0.6,
//                               ),
//                               size: 28.h,
//                             ),
//                             SizedBox(height: 4.h),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 4.w),
//                               child: Text(
//                                 item.name,
//                                 style: GoogleFonts.inter(
//                                   color: ColourUtils.textWhite.withValues(
//                                     alpha: 0.6,
//                                   ),
//                                   fontSize: 10.h,
//                                 ),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ],
//                         ),
//                 ),
//               ),
//               if (item.isUploading)
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.5),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Center(
//                       child: SizedBox(
//                         width: 20.h,
//                         height: 20.h,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.h,
//                           valueColor: AlwaysStoppedAnimation<Color>(
//                             ColourUtils.primary,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               if (item.error != null)
//                 Positioned.fill(
//                   child: GestureDetector(
//                     onTap: () => _retryUpload(item),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.black.withValues(alpha: 0.7),
//                         borderRadius: BorderRadius.circular(10.r),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.error_outline,
//                             color: Colors.redAccent,
//                             size: 20.h,
//                           ),
//                           SizedBox(height: 2.h),
//                           Text(
//                             'Tap to retry',
//                             style: GoogleFonts.inter(
//                               color: Colors.redAccent,
//                               fontSize: 8.h,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               Positioned(
//                 top: -5.h,
//                 right: -5.h,
//                 child: GestureDetector(
//                   onTap: () => _removeFile(item),
//                   child: Container(
//                     padding: EdgeInsets.all(3.h),
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.close, color: Colors.white, size: 12.h),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 10.h),
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour2,
//         borderRadius: BorderRadius.all(Radius.circular(15.h)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.title,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Container(
//               width: double.infinity,
//               // height: 150.h,
//               decoration: BoxDecoration(
//                 color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(
//                   color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                   width: 1.h,
//                   style: BorderStyle.solid,
//                 ),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     _showSourcePicker(context);
//                   },
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 25.h),
//                       SizedBox(
//                         height: 35.h,
//                         width: 35.h,
//                         child: SvgPicture.asset(
//                           AssetUtils.svg(widget.icon),
//                           color: ColourUtils.textWhite.withValues(alpha: 0.6),
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Text(
//                         widget.subtitle1,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textWhite.withValues(alpha: 0.6),
//                           fontSize: 15.h,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Text(
//                         widget.subtitle2,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                           fontSize: 14.h,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                       if (_selectedFiles.isNotEmpty) ...[
//                         SizedBox(height: 12.h),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: _buildPreviewList(),
//                         ),
//                       ] else ...[
//                         SizedBox(height: 30.h),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:loyaltri_minimal/View/CWidgets/file_selection_sheet.dart';
// import 'package:loyaltri_minimal/View/field/core/asset_utils.dart';
// import 'package:loyaltri_minimal/View/field/core/colour_utils.dart';
// import 'package:loyaltri_minimal/services/attachment_service.dart';
// import 'package:loyaltri_minimal/utils/color_utils.dart';

// class CustomAttachmentWidget extends StatelessWidget {
//   const CustomAttachmentWidget({
//     super.key,
//     required this.title,
//     required this.subtitle1,
//     required this.subtitle2,
//     required this.icon,
//   });

//   final String title;
//   final String subtitle1;
//   final String subtitle2;
//   final String icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColourUtils.bgColour2,
//         borderRadius: BorderRadius.all(Radius.circular(15.h)),
//       ),
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ATTACHMENTS DASHED CONTAINER
//             Text(
//               title,
//               style: GoogleFonts.inter(
//                 color: ColourUtils.textWhite,
//                 fontSize: 14.h,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             // Container(
//             //   width: double.infinity,
//             //   height: 150.h,
//             //   decoration: BoxDecoration(
//             //     color: ColourUtils.textWhite.withValues(alpha: 0.05),
//             //     borderRadius: BorderRadius.circular(12.r),
//             //     border: Border.all(
//             //       color: ColourUtils.textWhite.withValues(alpha: 0.05),
//             //       width: 1.h,
//             //       style: BorderStyle
//             //           .solid, // Note: standard dotted borders require a custom painter, solid is used here for styling.
//             //     ),
//             //   ),
//             //   child: Material(
//             //     color: Colors.transparent,
//             //     child: InkWell(
//             //       onTap: () {
//             //         attachBottomSheetShow(context);
//             //       },
//             //       borderRadius: BorderRadius.circular(12.r),
//             //       child: Column(
//             //         mainAxisAlignment: MainAxisAlignment.center,
//             //         children: [
//             //           SizedBox(
//             //             height: 35.h,
//             //             width: 35.h,
//             //             child: SvgPicture.asset(
//             //               AssetUtils.svg(icon),
//             //               color: ColourUtils.textWhite.withValues(alpha: 0.6),
//             //             ),
//             //           ),
//             //           SizedBox(height: 8.h),
//             //           Text(
//             //             // 'Tap to upload or browse',
//             //             subtitle1,
//             //             style: GoogleFonts.inter(
//             //               color: ColourUtils.textWhite.withValues(alpha: 0.6),
//             //               fontSize: 15.h,
//             //               fontWeight: FontWeight.w500,
//             //             ),
//             //           ),
//             //           SizedBox(height: 8.h),
//             //           Text(
//             //             // 'PDF, JPG, JPEG, up to 10MB',
//             //             subtitle2,
//             //             style: GoogleFonts.inter(
//             //               color: ColourUtils.textWhite.withValues(alpha: 0.4),
//             //               fontSize: 14.h,
//             //               fontWeight: FontWeight.w400,
//             //             ),
//             //           ),
//             //         ],
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             ValueListenableBuilder(
//           valueListenable: AttachmentService().selectedFiles,
//           builder: (context, value, child) {
//             return value.isEmpty ?Container(
//               width: double.infinity,
//               height: 150.h,
//               decoration: BoxDecoration(
//                 color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                 borderRadius: BorderRadius.circular(12.r),
//                 border: Border.all(
//                   color: ColourUtils.textWhite.withValues(alpha: 0.05),
//                   width: 1.h,
//                   style: BorderStyle
//                       .solid, // Note: standard dotted borders require a custom painter, solid is used here for styling.
//                 ),
//               ),
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   onTap: () {
//                     attachBottomSheetShow(context);
//                   },
//                   borderRadius: BorderRadius.circular(12.r),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(
//                         height: 35.h,
//                         width: 35.h,
//                         child: SvgPicture.asset(
//                           AssetUtils.svg(icon),
//                           color: ColourUtils.textWhite.withValues(alpha: 0.6),
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Text(
//                         // 'Tap to upload or browse',
//                         subtitle1,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textWhite.withValues(alpha: 0.6),
//                           fontSize: 15.h,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       SizedBox(height: 8.h),
//                       Text(
//                         // 'PDF, JPG, JPEG, up to 10MB',
//                         subtitle2,
//                         style: GoogleFonts.inter(
//                           color: ColourUtils.textWhite.withValues(alpha: 0.4),
//                           fontSize: 14.h,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ):  Column(
//               children: List.generate(value.length, (index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15).h,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 8,
//                         ).h,
//                     decoration: BoxDecoration(
//                       color: ColorUtils.foregroundBlack,
//                       borderRadius: BorderRadius.circular(12).r,
//                     ),
//                     child: Row(
//                       children: [
//                         Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 AttachmentService().removeFile(value[index]);
//                               },
//                               child: const Icon(
//                                 Icons.close,
//                                 color: ColorUtils.textWhite,
//                               ),
//                             ),
//                             SizedBox(width: 10.h),
//                             if(value[index].split('.').last == 'pdf')
//                               Image.asset(
//                                 "assets/images/manager_view/pdf_icon.png",
//                                 height: 35.h,
//                               )
//                             else
//                               Image.file(
//                                 File(value[index]),
//                                 height: 60.h,
//                                 width: 80.h,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Transform.rotate(
//                                     angle: 180,
//                                     child: Icon(
//                                       Icons.attach_file,
//                                       size: 28.h,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   );
//                                 },
//                               ),
//                           ],
//                         ),
//                         SizedBox(width: 10.h),
//                         Flexible(
//                           child: Text(
//                             value[index].split('/').last,
//                             overflow: TextOverflow.ellipsis,
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w500,
//                               fontSize: 12.h,
//                               color: ColorUtils.textWhite,
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10.h),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             );
//           },
//         ),
//           ],
//         ),
//       ),
//     );
//   }
// }
