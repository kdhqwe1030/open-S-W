import 'dart:io';

import 'app_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraAfterMap extends StatefulWidget {
  const CameraAfterMap({super.key});

  @override
  State<CameraAfterMap> createState() => _CameraAfterMapState();
}

class _CameraAfterMapState extends State<CameraAfterMap> {
  File? image;

  @override
  void initState() {
    super.initState();
    pickImage(ImageSource.camera);
    Navigator.pop(context); // 카메라 화면 스택에서 제거 후 이전 화면으로 돌아감
  }

  pickImage(ImageSource source) {
    AppImagePicker(source: source).pick(onPick: (File? image) {
      setState(() {
        this.image = image;
        // 여기서 DB에 사진 넣기 (+날짜, 사용자 key 부분도 추후에 추가)
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  } // 아무것도 없지만 삭제하면 안됨
}
