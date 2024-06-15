// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class DogInfoScreen extends StatefulWidget {
//   @override
//   _DogInfoScreenState createState() => _DogInfoScreenState();
// }
//
// class _DogInfoScreenState extends State<DogInfoScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseDatabase _database = FirebaseDatabase.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String? _dogID;
//   Map<String, dynamic>? _dogInfo;
//   bool _loading = true;
//   String? _gender;
//   @override
//   void initState() {
//     super.initState();
//     _fetchUserData();
//   }
//
//   Future<void> _fetchUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DatabaseReference userRef = _database.ref().child('Join').child(user.uid);
//       DataSnapshot snapshot = await userRef.get();
//
//       if (snapshot.exists && snapshot.value != null) {
//         Map<String, dynamic> userData =
//             Map<String, dynamic>.from(snapshot.value as Map);
//         // setState(() {
//         //   _dogID = userData['dogID'];
//         // });
//
//         _dogID = userData['dogId'];
//         if (_dogID != null) {
//           _fetchDogInfo();
//         } else {
//           setState(() {
//             _loading = false;
//           });
//         }
//       } else {
//         setState(() {
//           _loading = false;
//         });
//       }
//     } else {
//       setState(() {
//         _loading = false;
//       });
//     }
//   }
//
//   Future<void> _fetchDogInfo() async {
//     if (_dogID != null) {
//       // String str = "asd";
//       String str = _dogID!;
//       DocumentSnapshot dogDoc =
//           await _firestore.collection('Dogs').doc(str).get();
//       if (dogDoc.exists) {
//         setState(() {
//           _dogInfo = dogDoc.data() as Map<String, dynamic>?;
//         });
//       }
//     }
//     setState(() {
//       _loading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _loading
//           ? Center(child: CircularProgressIndicator())
//           : _dogID == null
//               ? Center(child: Text('강아지 정보가 없습니다'))
//               : _dogInfo == null
//                   ? Center(child: Text('강아지 정보를 불러오는 중 오류가 발생했습니다'))
//                   : Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Center(
//                             child: SizedBox(
//                               width: 140, // 원하는 너비
//                               height: 140, // 원하는 높이
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(30),
//                                 child: Image.asset(
//                                   "asset/img/profile.jpg",
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('이름 ', style: TextStyle(fontSize: 20)),
//                               Text('${_dogInfo!['name']}${_dogInfo!['breed']}',
//                                   style: TextStyle(fontSize: 20)),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           // Text('Breed: ${_dogInfo!['breed']}',
//                           //     style: TextStyle(fontSize: 20)),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('나이', style: TextStyle(fontSize: 20)),
//                               Text('${_dogInfo!['age']}',
//                                   style: TextStyle(fontSize: 20)),
//                             ],
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text('성별', style: TextStyle(fontSize: 20)),
//                               Text(
//                                   '${_dogInfo!['gender'] == '남' ? '수컷' : '암컷'}',
//                                   style: TextStyle(fontSize: 20)),
//                             ],
//                           ),
//
//                           // Add more fields as needed
//                         ],
//                       ),
//                     ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DogInfoScreen extends StatefulWidget {
  @override
  _DogInfoScreenState createState() => _DogInfoScreenState();
}

class _DogInfoScreenState extends State<DogInfoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? _dogID;
  Map<String, dynamic>? _dogInfo;
  String? _photoURL;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference userRef = _database.ref().child('Join').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        _dogID = userData['dogId'];
        if (_dogID != null) {
          _fetchDogInfo();
        } else {
          setState(() {
            _loading = false;
          });
        }
      } else {
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _fetchDogInfo() async {
    if (_dogID != null) {
      String str = _dogID!;
      DocumentSnapshot dogDoc =
          await _firestore.collection('Dogs').doc(str).get();
      if (dogDoc.exists) {
        setState(() {
          _dogInfo = dogDoc.data() as Map<String, dynamic>?;
          _photoURL = _dogInfo!['photoURL'];
        });
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _loading
          ? Center(child: CircularProgressIndicator())
          : _dogID == null
              ? Center(child: Text('강아지 정보가 없습니다'))
              : _dogInfo == null
                  ? Center(child: Text('강아지 정보를 불러오는 중 오류가 발생했습니다'))
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _photoURL != null
                              ? Center(
                                  child: FutureBuilder(
                                    future: _fetchImage(_photoURL!),
                                    builder: (context,
                                        AsyncSnapshot<String?> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        if (snapshot.hasError ||
                                            !snapshot.hasData ||
                                            snapshot.data == null) {
                                          return Center(
                                              child: Text(
                                                  '사진을 불러오는 중 오류가 발생했습니다.'));
                                        } else {
                                          return CircleAvatar(
                                            radius: 80,
                                            backgroundImage:
                                                NetworkImage(snapshot.data!),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                )
                              : Center(child: Text('사진 없음')),

                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('이름 ', style: TextStyle(fontSize: 20)),
                              Text('${_dogInfo!['name']}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),

                          SizedBox(height: 10),
                          // Text('Breed: ${_dogInfo!['breed']}',
                          //     style: TextStyle(fontSize: 20)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('나이', style: TextStyle(fontSize: 20)),
                              Text('${_dogInfo!['age']}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('성별', style: TextStyle(fontSize: 20)),
                              Text(
                                  '${_dogInfo!['gender'] == '남' ? '수컷' : '암컷'}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),

                          // Add more fields as needed
                        ],
                      ),
                    ),
    );
  }

  Future<String?> _fetchImage(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        var ref = _storage.ref().child(imageUrl);
        // final url = await ref.getDownloadURL();
        return imageUrl;
      } else {
        return null;
      }
    } catch (e) {
      print('Failed to fetch image: $e');
      return null;
    }
  }
}
