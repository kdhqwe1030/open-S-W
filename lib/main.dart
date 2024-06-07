import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:with_pet/providers/current_post_provider.dart';
import 'package:with_pet/providers/events_provider.dart';
import 'package:with_pet/providers/on_off_provider.dart';
import 'package:with_pet/providers/page_index_provider.dart';
import 'package:with_pet/providers/user_info_provider.dart';
import 'package:with_pet/screen/Join_screen.dart';
import 'package:with_pet/screen/home_screen.dart';
import 'package:with_pet/screen/sign_in_screen.dart';
import 'package:with_pet/screen/start_screen.dart';

// 'pages' 디렉토리 안의 'google_map_page.dart' 파일을 가져옵니다. 이 파일에는 Google Maps를 보여주는 페이지가 정의되어 있을 것입니다.
import 'screen/homePage/google_map_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentPostProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => OnOffProvider()),
        ChangeNotifierProvider(create: (_) => PageIndexProvider()),
        ChangeNotifierProvider(create: (_) => UserInfoProvider()),
      ], //
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          // '/': (BuildContext context) => SignInScreen(),
          '/': (BuildContext context) => StartScreen(),
          '/home': (BuildContext context) => HomeScreen(),
          '/signin': (BuildContext context) => SignInScreen(),
          '/signin/join': (BuildContext context) => JoinScreen(),
        },
      ),
    ),
  );
}

class GoogleMap extends StatelessWidget {
  // 'const' 생성자를 사용하여 'MyApp' 클래스의 인스턴스를 만듭니다. 'super.key'를 전달하여 부모 클래스의 생성자를 호출합니다.
  const GoogleMap({super.key});

  // 'build' 메서드는 'MyApp' 위젯의 UI를 구성합니다. 이 메서드는 'BuildContext'를 매개변수로 받아 MaterialApp 위젯을 반환합니다.
  @override
  Widget build(BuildContext context) => MaterialApp(
        // 애플리케이션의 제목을 설정합니다. 이 제목은 일반적으로 운영 체제의 앱 스위처 등에서 사용됩니다.
        title: 'Google Maps App',

        // 애플리케이션의 전반적인 테마를 설정합니다. 여기서는 기본 색상으로 파란색을 사용하는 테마를 정의합니다.
        theme: ThemeData(primarySwatch: Colors.blue),

        // 애플리케이션이 시작될 때 표시될 기본 화면을 설정합니다. 여기서는 'GoogleMapPage'를 기본 화면으로 설정합니다.
        home: const GoogleMapPage(),
      );
}
