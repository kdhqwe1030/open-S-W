import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:with_pet/providers/events_provider.dart';
import 'package:with_pet/providers/user_info_provider.dart';
import 'package:with_pet/providers/text_field.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List> _selectedEvents;
  TextEditingController _textEditingController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectMarker = 0;

  bool onOff = false;
  Color _color1 = Colors.grey;
  Color _color2 = Colors.grey;
  Color _color3 = Colors.grey;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  // saveData 메서드 추가
  void saveData() async {
    final storage = await SharedPreferences.getInstance();
    String map = jsonEncode(context.read<EventsProvider>().getEvents());
    if (map.isNotEmpty) {
      storage.setString('${context.read<UserInfoProvider>().getName()}', map);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initializeDateFormatting(Localizations.localeOf(context).languageCode);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _textEditingController.clear();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  List _getEventsForDay(DateTime day) {
    String dayT = DateFormat('yy/MM/dd').format(day);
    Map<String, dynamic> events = context.read<EventsProvider>().getEvents();
    return events[dayT] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Card(
              margin: EdgeInsets.all(8.0),
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                side: BorderSide(color: Color(0xff5d5d5d), width: 1.w),
              ),
              child: TableCalendar(
                headerStyle: HeaderStyle(
                  headerMargin: EdgeInsets.only(bottom: 20.h),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 15),
                  decoration: BoxDecoration(
                      color: Color(0xab5d5d5d),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      )),
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 20,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                rowHeight: 60.h,
                locale: 'ko-KR',
                firstDay: DateTime.utc(2023, 01, 01),
                lastDay: DateTime.utc(2024, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  markersAlignment: Alignment.bottomCenter,
                  canMarkersOverflow: true,
                  markersMaxCount: 2,
                  markersAnchor: 0.7,
                  todayDecoration: BoxDecoration(
                    color: Color(0x4c5d5d5d),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color(0xc85d5d5d),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle:
                      TextStyle(color: Colors.black), // 여기서 주말 날짜 색상 변경 가능
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (events.isNotEmpty) {
                      List iconEvents = events;
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal, // 날짜 밑 이모티콘 가로 정렬
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            Map key = iconEvents[index];
                            if (key['iconIndex'] == 1) {
                              return Container(
                                  margin: EdgeInsets.only(top: 40.h),
                                  child: Icon(
                                    size: 10.sp,
                                    Icons.pets_outlined,
                                    color: Colors.red,
                                  ));
                            } else if (key['iconIndex'] == 2) {
                              return Container(
                                  margin: EdgeInsets.only(top: 40.h),
                                  child: Icon(
                                    size: 10.sp,
                                    Icons.rice_bowl_outlined,
                                    color: Colors.yellow,
                                  ));
                            } else if (key['iconIndex'] == 3) {
                              return Container(
                                  margin: EdgeInsets.only(top: 40.h),
                                  child: Icon(
                                    size: 10.sp,
                                    Icons.water_drop_outlined,
                                    color: Colors.blue,
                                  ));
                            }
                          });
                    }
                  },
                  dowBuilder: (context, day) {
                    final text = DateFormat.E('ko').format(day);
                    return Center(
                      child: Text(
                        text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ), // 여기서 조건문으로 요일 색상 변경 가능
                    );
                  },
                ),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
                child: ValueListenableBuilder<List>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length < 3 ? value.length : 3,
                    itemBuilder: (context, index) {
                      Map event_icon_index = value[index];
                      if (event_icon_index['iconIndex'] == 1) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              context
                                  .read<EventsProvider>()
                                  .deleteEvents(_selectedDay, index);
                              saveData();
                            },
                            title: Text('${event_icon_index['contents']}'),
                            trailing: Icon(
                              Icons.pets_outlined,
                              color: Colors.red,
                            ),
                          ),
                        );
                      }
                      if (event_icon_index['iconIndex'] == 2) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              setState(() {
                                context
                                    .read<EventsProvider>()
                                    .deleteEvents(_selectedDay, index);
                                saveData();
                              });
                            },
                            title: Text('${event_icon_index['contents']}'),
                            trailing: Icon(
                              Icons.rice_bowl_outlined,
                              color: Colors.yellow,
                            ),
                          ),
                        );
                      }
                      if (event_icon_index['iconIndex'] == 3) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              setState(() {
                                context
                                    .read<EventsProvider>()
                                    .deleteEvents(_selectedDay, index);
                                saveData();
                              });
                            },
                            title: Text('${event_icon_index['contents']}'),
                            trailing: Icon(
                              Icons.water_drop_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        );
                      }
                    });
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder:
                    (BuildContext context, StateSetter dialogSetState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Text('일정 추가하기',
                        style: TextStyle(
                          fontSize: 15.sp,
                        )),
                    actions: <Widget>[
                      Container(
                          margin: EdgeInsets.only(
                              left: 0.w, right: 0.w), // 일정 내용 입력 칸 양옆 여백
                          child: CustomTextField(
                              text: '일정 내용',
                              hintText: '내용을 입력하세요',
                              controller: _textEditingController)),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 0.w,
                              right: 0.w,
                              top: 30.w), // 마커 선택 안내 문장 위치
                          child: Text('캘린더에 표시할 마커를 선택하세요',
                              style: TextStyle(
                                fontSize: 13.sp,
                              ))),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 500.w, // 마커 박스 가로 길이
                          height: 100.h, // 마커 박스 세로 길이
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(
                                      0, 10), // changes position of shadow
                                ),
                              ],
                              color: Color(0x415d5d5d),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_color2 == Colors.grey &&
                                      _color3 == Colors.grey) {
                                    dialogSetState(() {
                                      _color1 = (_color1 == Colors.red)
                                          ? Colors.grey
                                          : Colors.red;
                                    });
                                    if (_color1 == Colors.grey) {
                                      selectMarker = 0;
                                    } else {
                                      selectMarker = 1;
                                    }
                                  }
                                },
                                child: Container(
                                  width: 65.w,
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Icon(
                                    Icons.pets_outlined,
                                    color: _color1,
                                    size: 50.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_color1 == Colors.grey &&
                                      _color3 == Colors.grey) {
                                    dialogSetState(() {
                                      _color2 = _color2 == Colors.yellow
                                          ? Colors.grey
                                          : Colors.yellow;
                                    });
                                    if (_color2 == Colors.grey) {
                                      selectMarker = 0;
                                    } else {
                                      selectMarker = 2;
                                    }
                                  }
                                },
                                child: Container(
                                  width: 65.w,
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Icon(
                                    Icons.rice_bowl_outlined,
                                    color: _color2,
                                    size: 50.sp,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_color1 == Colors.grey &&
                                      _color2 == Colors.grey) {
                                    dialogSetState(() {
                                      _color3 = _color3 == Colors.blue
                                          ? Colors.grey
                                          : Colors.blue;
                                    });
                                    if (_color3 == Colors.grey) {
                                      selectMarker = 0;
                                    } else {
                                      selectMarker = 3;
                                    }
                                  }
                                },
                                child: Container(
                                  width: 65.w,
                                  height: 65.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Icon(
                                    Icons.water_drop_outlined,
                                    color: _color3,
                                    size: 50.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextButton(
                          onPressed: () {
                            if (selectMarker != 0) {
                              if (_textEditingController.text == '') {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          content: Text('\n일정 내용을 추가해 주세요.'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Ok')),
                                          ],
                                        ));
                              } else {
                                var maxIconCount = context
                                    .read<EventsProvider>()
                                    .setEvents(
                                        _selectedDay,
                                        _textEditingController.text,
                                        selectMarker);
                                if (maxIconCount == '초과') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            title: Text('일정 초과'),
                                            content:
                                                Text('일정에 추가 가능한 개수는 3개입니다'),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('Ok')),
                                            ],
                                          ));
                                } else {
                                  _color1 = Colors.grey;
                                  _color2 = Colors.grey;
                                  _color3 = Colors.grey;
                                  _textEditingController.clear();
                                  selectMarker = 0;
                                  saveData();
                                  Navigator.pushReplacementNamed(
                                      context, '/pageRouter');
                                }
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        content: Text(
                                            '\n마커를 지정하지 않았습니다.\n마커를 지정해주세요.'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('Ok')),
                                        ],
                                      ));
                            }
                          },
                          child: Text(
                            'Ok',
                            style: TextStyle(fontSize: 15.sp),
                          )),
                    ],
                  );
                });
              });
        },
        backgroundColor: const Color(0xff5d5d5d),
        child: Icon(
          Icons.create,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }
}
