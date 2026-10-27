

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../sqflite_db/punch_db.dart';

class AttachmentService {
  // Step 1: Create a static private instance
  static final AttachmentService _instance = AttachmentService._internal();

  // Step 2: Private constructor
  AttachmentService._internal();

  // Step 3: Factory constructor that returns the same instance
  factory AttachmentService() {
    return _instance;
  }

  ValueNotifier<List<String>> selectedFiles = ValueNotifier([]);

  void addFile(String filePath) {
    selectedFiles.value = [...selectedFiles.value, filePath];
  }
  void singleFileAdd(String filePath) {
    selectedFiles.value = [filePath];
  }

  void removeFile(String filePath) {
    selectedFiles.value = selectedFiles.value.where((f) => f != filePath).toList();
  }

  void clearFiles() {
    selectedFiles.value = [];
  }

  static Future<String?> saveFaceImage({required DateTime punchDate, required File? image}) async {
    try {
      Directory imageDir = await getApplicationDocumentsDirectory();

      imageDir = Directory('${imageDir.path}/FacePunch');

      if(!(await imageDir.exists())) {
        await imageDir.create(recursive: true);
      }

      String? filePath = "${imageDir.path}/${punchDate.millisecondsSinceEpoch}.jpg";

      try {
        await image?.copy(filePath);
      } catch (e) {
        debugPrint("Error copying file: $e");
      }

      if(!(await File(filePath).exists())) {
        filePath = null;
      }

      return filePath;
    } catch(e) {
      return null;
    }
  }

  static Future<void> deleteFaceImage({String? filePath}) async {
    // try {
    //   Directory appDir = await getApplicationDocumentsDirectory();
    //   Directory faceDir = Directory('${appDir.path}/Loyaltri/FacePunch');
    //
    //   if (await faceDir.exists()) {
    //     await faceDir.delete(recursive: true);
    //   }
    // } catch (e) {
    //   debugPrint("Error deleting FacePunch directory: $e");
    // }
    try {
      Directory imageDir = await getApplicationDocumentsDirectory();
      imageDir = Directory('${imageDir.path}/FacePunch');

      if(filePath != null) {
        File file = File(filePath);

        if (await file.exists()) {
          await file.delete();
        }
      }

      int count = await PunchDatabase.instance.getUnSyncedPunchCount();

      if(count == 0) {
        if (await imageDir.exists()) {
          await for (var entity in imageDir.list()) {
            if (entity is File) {
              if (await entity.exists()) {
                await entity.delete();
              }
            }
          }
        }
      }
    } catch(e) {
      debugPrint("Delete error: $e");
    }
  }

  static Future<int> getFaceImageCount() async {
    Directory imageDir = await getApplicationDocumentsDirectory();
    imageDir = Directory('${imageDir.path}/FacePunch');

    if (!(await imageDir.exists())) return 0;

    int count = 0;

    await for (var entity in imageDir.list()) {
      if (entity is File) {
        count++;
      }
    }

    return count;
  }
}