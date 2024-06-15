import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '../../component/pet_info.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
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

  int _calculateDDay(String startDateString) {
    final startDate = DateTime.parse(startDateString);
    final now = DateTime.now();
    final difference = now.difference(startDate).inDays;
    return difference;
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();
  List<Event> currentEvents = [];

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2024, 5, 15): [
      Event('title', "16:00", "18:00"),
      Event('title2', "18:00", "20:00"),
    ],
    DateTime.utc(2024, 5, 16): [
      Event('title3', "16:00", "18:00"),
    ],
  };
  List<Event> _getEventsForDay(DateTime day) {
    setState(() {
      currentEvents = events[day] ?? [];
    });
    print(currentEvents);
    return events[day] ?? [];
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 2000,
        child: Padding(
          padding: EdgeInsets.all(20), // 디자인 변경에 따른 수정
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center, // 테스트
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_dogInfo!['name']}와 함께한지",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'D+${_calculateDDay(_dogInfo?['dogSince'] as String)}일',
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),

                        _photoURL != null
                            ? Center(
                                child: FutureBuilder(
                                  future: _fetchImage(_photoURL!),
                                  builder: (context,
                                      AsyncSnapshot<String?> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.hasError ||
                                          !snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Center(
                                            child:
                                                Text('사진을 불러오는 중 오류가 발생했습니다.'));
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
                        // ClipRRect(
                        //     borderRadius: BorderRadius.circular(10),
                        //     child: Image.asset("asset/img/profile.jpg",
                        //         width: 100, height: 100, fit: BoxFit.cover)),
                      ],
                    ),
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Color(0xFF64d7fa),
                    side: BorderSide(
                      color: Color(0xFF64d7fa),
                    )),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/home/addDog"); // 이 부분이 수정되었습니다
                },
                child: Text(
                  "강아지 정보 추가하기",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: Calendar(
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    });
                    _getEventsForDay(this.selectedDay);
                  },
                  selectedDayPredicate: (DateTime day) {
                    return isSameDay(selectedDay, day);
                  },
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xCC606060),
                          offset: const Offset(0, 10),
                          blurRadius: 20,
                          blurStyle: BlurStyle.outer,
                        )
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Text("오늘의 추억"),
                        Column(
                          children: currentEvents
                              .map((e) => MainEvent(
                                    startTime: e.start,
                                    endTime: e.end,
                                    title: e.title,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 32.0),
              PetInfo(),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

class Calendar extends StatelessWidget {
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;

  const Calendar({
    required this.onDaySelected,
    required this.selectedDayPredicate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        calendarFormat: CalendarFormat.week,
        onDaySelected: onDaySelected,
        selectedDayPredicate: selectedDayPredicate);
  }
}

class Event {
  final String title;
  final String start;
  final String end;

  Event(this.title, this.start, this.end);
}

class MainEvent extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String title;

  const MainEvent({
    required this.startTime,
    required this.endTime,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('$startTime - $endTime'),
    );
  }
}
