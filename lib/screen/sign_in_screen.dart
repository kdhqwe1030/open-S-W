import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showImage = false;
  bool _showInputFields = false;

  final idController = TextEditingController();
  final passwordController = TextEditingController();

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
      // backgroundColor: Colors.blueAccent,
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
                // SizedBox(height: 20),
                // ID와 password 입력창이 나타날 때만 표시되도록 설정
                AnimatedOpacity(
                  opacity: _showInputFields ? 1.0 : 0.0,
                  duration: Duration(seconds: 1),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            labelText: 'ID',
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 60,
                        child: TextField(
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
                        ),
                      ),
                      SizedBox(height: 45),
                      SizedBox(
                        width: 100000,
                        height: 45,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed("/home");
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
                        width: 100000,
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
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // OutlinedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text("이전 페이지로"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
