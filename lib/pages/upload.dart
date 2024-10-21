import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart'; // เพิ่ม import สำหรับ Get

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _deleteController = TextEditingController();

  Future<String> getNextFileName() async {
    final ListResult result = await storage.ref('uploads').listAll();
    int maxNumber = 0;

    for (var ref in result.items) {
      final name = ref.name;
      final match = RegExp(r'pic-(\d+)').firstMatch(name);
      if (match != null) {
        int number = int.parse(match.group(1)!);
        if (number > maxNumber) {
          maxNumber = number;
        }
      }
    }

    return 'pic-${maxNumber + 1}';
  }

  Future<void> uploadFile() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return; 

    try {
      String newFileName = await getNextFileName();
      await storage.ref('uploads/$newFileName').putFile(File(image.path));
      print('File uploaded successfully: $newFileName');

      // แจ้งเตือนชื่อไฟล์ที่อัปโหลด
      Get.snackbar("Upload Success", "File uploaded successfully: $newFileName");
    } catch (e) {
      print('Error occurred while uploading: $e');
      Get.snackbar("Error", "Failed to upload file: $e");
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await storage.ref('uploads/$fileName').delete();
      print('File deleted successfully: $fileName');
      Get.snackbar("Success", "File deleted successfully: $fileName");
    } catch (e) {
      print('Error occurred while deleting: $e');
      Get.snackbar("Error", "Failed to delete file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase Storage Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: uploadFile,
              child: Text('Upload Image'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _deleteController,
              decoration: InputDecoration(
                labelText: 'Enter file name to delete (e.g. pic-1)',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String fileName = _deleteController.text.trim();
                if (fileName.isNotEmpty) {
                  deleteFile(fileName);
                }
              },
              child: Text('Delete Image'),
            ),
          ],
        ),
      ),
    );
  }
}
