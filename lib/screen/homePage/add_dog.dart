import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:with_pet/screen/service/databaseSvc.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  String? _gender = '여';
  File? _imageFile; // To store the selected image file
  final TextEditingController _dateController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _loading = false;

  Future<void> _addDog() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Upload image file to Firebase Storage and get download URL
          String? photoURL;
          if (_imageFile != null) {
            photoURL = await _uploadImageFile(_imageFile!, user.uid);
          }

          // Dogs 컬렉션에 강아지 정보 추가
          DocumentReference docRef = await _firestore.collection('Dogs').add({
            'userId': user.uid,
            'name': _nameController.text,
            'age': int.parse(_ageController.text),
            'breed': _breedController.text,
            'gender': _gender,
            'photoURL': photoURL, // Save photo URL in Firestore
            'timestamp': FieldValue.serverTimestamp(),
            'dogSince': _dateController.text,
            'distance': 0,
          });

          // Realtime Database에 강아지 ID 추가
          DatabaseReference userRef = _database.ref('Join/${user.uid}');
          await userRef.update({
            'dogId': docRef.id,
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('강아지 정보가 추가되었습니다.')));
          _nameController.clear();
          _ageController.clear();
          _breedController.clear();
          setState(() {
            _gender = null;
            _imageFile = null; // Clear selected image file after upload
            _loading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('강아지 정보를 추가하는데 실패했습니다.')));
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<String?> _uploadImageFile(File imageFile, String userId) async {
    try {
      String fileName = imageFile.path.split('/').last;

      var ref = _storage.ref().child('dog_images/$fileName');
      var uploadTask = ref.putFile(imageFile);

      await uploadTask.whenComplete(() => {});

      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('강아지 정보 추가')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 50),
              Text(
                "강아지 이름",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: '강아지 이름를 입력 해주세요.',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Text(
                "나이",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: '나이를 입력 해주세요.',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '나이를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Text(
                "강아지와 함께한 날짜",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: '날짜를 선택 해주세요.',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      _selectDate(context);
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '날짜를 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Text(
                "견종",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  hintText: '견종을 입력 해주세요.',
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '품종을 입력하세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "성별 ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 180, // 원하는 너비로 설정
                      child: ToggleSwitch(
                        minWidth: 180.0,
                        initialLabelIndex:
                            _gender == '남' ? 0 : (_gender == '여' ? 1 : null),
                        cornerRadius: 20.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        labels: ['수컷', '암컷'],
                        icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                        activeBgColors: [
                          [Colors.blue],
                          [Colors.pink]
                        ],
                        onToggle: (index) {
                          setState(() {
                            _gender = index == 0 ? '남' : '여';
                          });
                          print('switched to: $index');
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Button to pick image from gallery
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('강아지 사진 선택'),
              ),
              SizedBox(height: 20),
              // Display selected image
              _imageFile == null
                  ? Container()
                  : Image.file(
                      _imageFile!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: _addDog,
                style: OutlinedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.blue,
                    side: BorderSide(
                      color: Colors.blue,
                    )),
                child: Text(
                  "강아지 정보 추가",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
