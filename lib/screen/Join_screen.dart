// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class JoinScreen extends StatefulWidget {
//   JoinScreen({Key? key}) : super(key: key);
//
//   @override
//   State<JoinScreen> createState() => _JoinScreenState();
// }
//
// class _JoinScreenState extends State<JoinScreen> {
//   final formKey = GlobalKey<FormState>();
//   String id = "";
//   String pw = "";
//   String pw_check = "";
//   String ph_num = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true, // 자판이 올라왔을 때 화면이 스크롤 되도록 설정
//       appBar: AppBar(
//         title: Text(
//           "회원가입",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           child: Form(
//             key: formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 20),
//                 Text(
//                   "이메일",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 18),
//                 TextFormField(
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (!(value!.contains('@') && value.contains('.'))) {
//                       return '이메일 아이디 형식이 잘못되었습니다.';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     id = value!;
//                   },
//                 ),
//                 SizedBox(height: 25),
//                 Text(
//                   "비밀번호",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 TextFormField(
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value!.length < 8) {
//                       return '비밀번호를 8자리 이상 입력해주세요.';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     pw = value;
//                   },
//                   onSaved: (value) {
//                     pw = value!;
//                   },
//                 ),
//                 SizedBox(height: 25),
//                 Text(
//                   "비밀번호 확인",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 TextFormField(
//                   obscureText: true,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value != pw) {
//                       return '비밀번호가 일치하지 않습니다.';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     pw_check = value;
//                   },
//                   onSaved: (value) {
//                     pw_check = value!;
//                   },
//                 ),
//                 SizedBox(height: 25),
//                 Text(
//                   "전화번호",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 15),
//                 TextFormField(
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value!.length != 11) {
//                       return '핸드폰 번호를 잘못 입력했습니다.';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) {
//                     ph_num = value!;
//                   },
//                 ),
//                 SizedBox(height: 30),
//                 SizedBox(
//                   width: double.infinity, // 버튼을 화면 가로 전체에 맞춤
//                   height: 45,
//                   child: OutlinedButton(
//                     onPressed: () {
//                       if (formKey.currentState!.validate()) {
//                         formKey.currentState!.save();
//
//                         showDialog(
//                           context: context,
//                           builder: (context) {
//                             return AlertDialog(
//                               title: Text("id: ${id} \npw: ${pw}"),
//                               actions: [
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                   child: Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }
//
//                       /// 홈화면으로 이동
//                       /// Navigator.of(context).pushNamed("/home");
//                     },
//                     style: OutlinedButton.styleFrom(
//                       elevation: 10,
//                       backgroundColor: Colors.blue,
//                       side: BorderSide(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     child: Text(
//                       "회원가입",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'models/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service/databaseSvc.dart';
import 'sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryModel {
  final String id;
  final String pw;
  final String ph_num;

  DiaryModel({
    required this.id,
    required this.pw,
    required this.ph_num,
  });

  DiaryModel.fromJson({
    required Map<String, dynamic> json,
  })  : id = json['id'],
        pw = json['pw'],
        ph_num = json['ph_num'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pw': pw,
      'ph_num': ph_num,
    };
  }
}

class JoinScreen extends StatefulWidget {
  JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _authetication = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String pw = "";
  String pw_check = "";
  String ph_num = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "회원가입",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60),
                  Text(
                    "강아지 산책을 \n기록해 볼까요?",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 100),
                  Text(
                    "이름",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '이름을 입력 해주세요.',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return '이름을 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(height: 25),
                  Text(
                    "이메일",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: '이메일을 입력 해주세요.',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      // if (!(value!.contains('@') && value!.contains('.'))) {
                      //   return '이메일 아이디 형식이 잘못되었습니다.';
                      // }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  SizedBox(height: 25),
                  Text(
                    "비밀번호",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력 해주세요.',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length < 8) {
                        return '비밀번호를 8자리 이상 입력해주세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      pw = value!;
                    },
                    onChanged: (value) {
                      pw = value;
                    },
                  ),
                  SizedBox(height: 25),
                  Text(
                    "비밀번호 확인",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 한번 더 입력 해주세요.',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      // if (pw != pw_check) {
                      //   return '비밀번호가 일치하지 않습니다.';
                      // }
                      return null;
                    },
                    onSaved: (value) {
                      pw = value!;
                    },
                  ),
                  SizedBox(height: 25),
                  Text(
                    "전화번호",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: '전화번호를 입력 해주세요.',
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length != 11) {
                        return '핸드폰 번호를 잘못 입력했습니다.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      ph_num = value!;
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 100000,
                    height: 45,
                    child: OutlinedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            try {
                              final newUser = await _authetication
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: pw,
                              );

                              if (newUser.user != null) {
                                final User? user = _authetication.currentUser;
                                var userkey = user
                                    ?.uid; // 사용자 키를 난수로 생성, 추후 사용자 정보 검색 시 사용

                                DatabaseSvc databaseSvc = DatabaseSvc();
                                databaseSvc.writeDB(
                                    userkey!, name, email, pw, ph_num);

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          "name: ${name}\nemail: ${email}\npw: ${pw}"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pop(); // 두번 팝해서 시작화면으로 돌아감, 다른 방법이 있을 것 같은데

                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(builder: (context){
                                            //     return _SignInScreenState();
                                            //   }),
                                            // );

                                            /// 홈화면으로 이동
                                            /// Navigator.of(context).pushNamed("/home");
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              print(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('회원가입에 에러가 발생했습니다. 다시 시도해주세요.'),
                                  backgroundColor: Colors.deepOrange,
                                ),
                              );
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.blue,
                            side: BorderSide(
                              color: Colors.blue,
                            )),
                        child: Text(
                          "회원가입",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
