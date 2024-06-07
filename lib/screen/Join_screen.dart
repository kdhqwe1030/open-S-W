import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinScreen extends StatefulWidget {
  JoinScreen({Key? key}) : super(key: key);

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final formKey = GlobalKey<FormState>();
  String id = "";
  String pw = "";
  String pw_check = "";
  String ph_num = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 자판이 올라왔을 때 화면이 스크롤 되도록 설정
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
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
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (!(value!.contains('@') && value.contains('.'))) {
                      return '이메일 아이디 형식이 잘못되었습니다.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    id = value!;
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
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
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
                  onChanged: (value) {
                    pw = value;
                  },
                  onSaved: (value) {
                    pw = value!;
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
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != pw) {
                      return '비밀번호가 일치하지 않습니다.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    pw_check = value;
                  },
                  onSaved: (value) {
                    pw_check = value!;
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
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
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
                  width: double.infinity, // 버튼을 화면 가로 전체에 맞춤
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("id: ${id} \npw: ${pw}"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      /// 홈화면으로 이동
                      /// Navigator.of(context).pushNamed("/home");
                    },
                    style: OutlinedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: Colors.blue,
                      side: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    child: Text(
                      "회원가입",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
