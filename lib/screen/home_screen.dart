import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:with_pet/screen/homePage/info_dog.dart';
import '../const/tabs.dart';
import 'homePage/google_map_page.dart';
import 'homePage/calendar_page.dart';
import 'homePage/pagehome.dart';
import 'homePage/rank.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  String? _displayName;
  String? _email;
  String? _phoneNumber;
  bool _loading = true;
  bool _buildDelayed = false; // 추가된 부분

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
    _fetchUserInfo();
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _buildDelayed = true;
      });
    });
  }

  Future<void> _fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DatabaseReference userRef = _database.ref().child('Join').child(user.uid);
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.value != null) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          _displayName = userData['name'];
          _email = userData['email'];
          _phoneNumber = userData['ph_num'];
          _loading = false;
        });
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_buildDelayed) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color(0xFF64d7fa),
        automaticallyImplyLeading: false,
        title: Container(
            height: AppBar().preferredSize.height,
            child: Image.asset('asset/img/logo.png')),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: Color(0xFF64d7fa),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          //Icons.person_rounded
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.dog,
              color: Color(0xFF64d7fa),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("강아지 정보"),
                    content: Container(
                      height: 350, // 원하는 높이로 설정
                      width: double.maxFinite,
                      child: DogInfoScreen(),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            _loading
                ? Center(child: CircularProgressIndicator())
                : UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage("asset/img/profile.jpg"),
                    ),
                    accountName: Text('${_displayName ?? '정보 없음'}'),
                    accountEmail: Text('${_email ?? '정보 없음'}'),
                    //onDetailsPressed: () {},
                    decoration: BoxDecoration(
                      color: Color(0xFF64d7fa),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                  ),
            ListTile(
              leading: Icon(Icons.home),
              iconColor: Color(0xFF64d7fa),
              focusColor: Color(0xFF64d7fa),
              title: Text('홈'),
              onTap: () {
                Navigator.of(context).pop();
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.pets_outlined),
              iconColor: Color(0xFF64d7fa),
              focusColor: Color(0xFF64d7fa),
              title: Text('산책 기록'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(1); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.grade),
              iconColor: Color(0xFF64d7fa),
              focusColor: Color(0xFF64d7fa),
              title: Text('랭킹'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(2); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.date_range_rounded),
              iconColor: Color(0xFF64d7fa),
              focusColor: Color(0xFF64d7fa),
              title: Text('캘린더'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(3); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Color(0xFF64d7fa),
              focusColor: Color(0xFF64d7fa),
              title: Text('설정'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // 각 탭에 해당하는 페이지 위젯을 여기에 추가합니다.
          PageHome(),

          GoogleMapPage(),

          ///PageMap(),
          Page3(),
          // Page4(),
          CalendarPage(),
          // TABS의 길이에 맞게 페이지를 추가하세요.
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          // backgroundColor: Color(0xFF64d7fa),
          selectedItemColor: Color(0xFF64d7fa),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: TABS
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
