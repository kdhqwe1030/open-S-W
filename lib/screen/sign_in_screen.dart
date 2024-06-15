// import 'package:flutter/material.dart';
//
// class SignInScreen extends StatefulWidget {
//   const SignInScreen({Key? key}) : super(key: key);
//
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }
//
// class _SignInScreenState extends State<SignInScreen> {
//   bool _showImage = false;
//   bool _showInputFields = false;
//
//   final idController = TextEditingController();
//   final passwordController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _showImage = true;
//       });
//     });
//
//     Future.delayed(Duration(seconds: 3), () {
//       setState(() {
//         _showInputFields = true;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       // backgroundColor: Colors.blueAccent,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 25),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AnimatedContainer(
//                   duration: Duration(seconds: 3),
//                   curve: Curves.easeOut,
//                   height: _showImage ? 350 : 0.0,
//                   child: Image.asset('asset/img/logo.png'),
//                 ),
//                 // SizedBox(height: 20),
//                 // ID와 password 입력창이 나타날 때만 표시되도록 설정
//                 AnimatedOpacity(
//                   opacity: _showInputFields ? 1.0 : 0.0,
//                   duration: Duration(seconds: 1),
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 60,
//                         child: TextField(
//                           controller: idController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15)),
//                               borderSide: BorderSide(color: Colors.blue),
//                             ),
//                             labelText: 'ID',
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 30),
//                       Container(
//                         height: 60,
//                         child: TextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15)),
//                               borderSide: BorderSide(color: Colors.blue),
//                             ),
//                             labelText: 'Password',
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 45),
//                       SizedBox(
//                         width: 100000,
//                         height: 45,
//                         child: OutlinedButton(
//                             onPressed: () {
//                               Navigator.of(context).pushNamed("/home");
//                             },
//                             style: OutlinedButton.styleFrom(
//                                 elevation: 10,
//                                 backgroundColor: Colors.blue,
//                                 side: BorderSide(
//                                   color: Colors.blue,
//                                 )),
//                             child: Text(
//                               "로그인",
//                               style: TextStyle(color: Colors.white),
//                             )),
//                       ),
//                       SizedBox(height: 15),
//                       SizedBox(
//                         width: 100000,
//                         height: 45,
//                         child: OutlinedButton(
//                             onPressed: () {
//                               Navigator.of(context).pushNamed("/signin/join");
//                             },
//                             style: OutlinedButton.styleFrom(
//                                 elevation: 10,
//                                 backgroundColor: Colors.blue,
//                                 side: BorderSide(
//                                   color: Colors.blue,
//                                 )),
//                             child: Text(
//                               "회원가입",
//                               style: TextStyle(color: Colors.white),
//                             )),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),
//
//                 // OutlinedButton(
//                 //   onPressed: () {
//                 //     Navigator.of(context).pop();
//                 //   },
//                 //   child: Text("이전 페이지로"),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showImage = false;
  bool _showInputFields = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _authentication = FirebaseAuth.instance;
  //final _authetication = FirebaseAuth.instance;
  var signinEmail = '';
  var signinPW = '';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showImage = true;
      });
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showInputFields = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 3),
                  curve: Curves.easeOut,
                  height: _showImage ? 350 : 0.0,
                  child: Image.asset('asset/img/logo.png'),
                ),
                AnimatedOpacity(
                  opacity: _showInputFields ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: 'email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '이메일을 입력하세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              signinEmail = value!;
                            },
                            onChanged: (value) {
                              signinEmail = value;
                            },
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 60,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '비밀번호를 입력하세요.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              signinPW = value!;
                            },
                            onChanged: (value) {
                              signinPW = value;
                            },
                          ),
                        ),
                        SizedBox(height: 45),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton(
                              onPressed: () async {
                                // _login();
                                try {
                                  final newUser = await _authentication
                                      .signInWithEmailAndPassword(
                                    email: signinEmail,
                                    password: signinPW,
                                  );

                                  if (newUser.user != null) {
                                    emailController.text = '';
                                    passwordController.text = '';

                                    Navigator.of(context).pushNamed("/home");
                                  }
                                } catch (e) {
                                  print('로그인 실패: $e'); // 오류 메시지를 보다 구체적으로 출력
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('로그인에 에러가 발생했습니다. 다시 시도해주세요.'),
                                      backgroundColor: Colors.deepOrange,
                                    ),
                                  );
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: Colors.blue,
                                  side: BorderSide(
                                    color: Colors.blue,
                                  )),
                              child: Text(
                                "로그인",
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("/signin/join");
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
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
