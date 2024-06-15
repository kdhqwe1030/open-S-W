// import 'dart:io';
//
// import 'app_image_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class CameraAfterMap extends StatefulWidget {
//   const CameraAfterMap({super.key});
//
//   @override
//   State<CameraAfterMap> createState() => _CameraAfterMapState();
// }
//
// class _CameraAfterMapState extends State<CameraAfterMap> {
//   File? image;
//
//   @override
//   void initState() {
//     super.initState();
//     pickImage(ImageSource.camera);
//     Navigator.pop(context); // 카메라 화면 스택에서 제거 후 이전 화면으로 돌아감
//   }
//
//   pickImage(ImageSource source) {
//     AppImagePicker(source: source).pick(onPick: (File? image) {
//       setState(() {
//         this.image = image;
//         // 여기서 DB에 사진 넣기 (+날짜, 사용자 key 부분도 추후에 추가)
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   } // 아무것도 없지만 삭제하면 안됨
// }
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'app_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAfterMap extends StatefulWidget {
  const CameraAfterMap({super.key});

  @override
  State<CameraAfterMap> createState() => _CameraAfterMapState();
}

class _CameraAfterMapState extends State<CameraAfterMap> {
  File? _image;

  final FirebaseStorage storage =
      FirebaseStorage.instance; // Firebase Storage 인스턴스 생성
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance; // Cloud Firestore 인스턴스 생성

  final FirebaseAuth _auth =
      FirebaseAuth.instance; // Firebase Auth 인스턴스 생성, 회원 구분해서 db에 넣을 때 사용

  @override
  void initState() {
    super.initState();
    pickImage(ImageSource.camera);
    Navigator.pop(context); // 카메라 화면 스택에서 제거 후 이전 화면으로 돌아감
  }

  pickImage(ImageSource source) {
    AppImagePicker(source: source).pick(onPick: (File? image) {
      _image = image;

      _uploadImage();
    });
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    try {
      String fileName = _image!.path.split('/').last;

      var ref = storage.ref().child('uploads/$fileName');
      ref.putFile(_image!);

      var uploadTask = ref.putFile(_image!);

      final snapshot = await uploadTask.whenComplete(() => {});
      final url = await snapshot.ref.getDownloadURL();

      // 현재 로그인한 사용자의 UID 가져오기
      User? user = _auth.currentUser;
      String? uid = user?.uid;

      // 현재 시간을 업로드 날짜로 설정
      DateTime now = DateTime.now();

      // Firestore에 이미지 정보 저장
      await firestore.collection('Images').add({
        'url': url,
        'userId': uid,
        'uploadTime': now,
      });

      print('Uploaded successfully');
    } catch (e) {
      print('Failed to upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  } // 아무것도 없지만 삭제하면 안됨
}
