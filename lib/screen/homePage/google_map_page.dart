// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:with_pet/const/apiKey.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// import '../../component/map_controll_component.dart';
//
// class GoogleMapPage extends StatefulWidget {
//   const GoogleMapPage({super.key});
//
//   @override
//   State<GoogleMapPage> createState() => _GoogleMapPageState();
// }
//
// class _GoogleMapPageState extends State<GoogleMapPage> {
//   final locationController = Location();
//   late GoogleMapController mapController;
//
//   LatLng? currentPosition;
//   List<LatLng> polylineCoordinates = [];
//   Map<PolylineId, Polyline> polylines = {};
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await fetchInitialLocation();
//       await initializeMap();
//     });
//   }
//
//   Future<void> fetchInitialLocation() async {
//     bool serviceEnabled;
//     PermissionStatus permissionGranted;
//
//     serviceEnabled = await locationController.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await locationController.requestService();
//       if (!serviceEnabled) {
//         return;
//       }
//     }
//
//     permissionGranted = await locationController.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await locationController.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     final locationData = await locationController.getLocation();
//     if (locationData.latitude != null && locationData.longitude != null) {
//       setState(() {
//         currentPosition =
//             LatLng(locationData.latitude!, locationData.longitude!);
//       });
//     }
//   }
//
//   Future<void> initializeMap() async {
//     if (currentPosition != null) {
//       final coordinates = await fetchPolylinePoints();
//       setState(() {
//         polylineCoordinates = coordinates;
//       });
//       generatePolyLineFromPoints();
//     }
//     await fetchLocationUpdates();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Column(
//           children: <Widget>[
//             // Expanded 위젯을 사용하여 지도와 하단 컨테이너의 높이 비율을 조정
//             Expanded(
//               flex: 4, // 지도에 더 많은 공간 할당
//               child: currentPosition == null
//                   ? const Center(
//                       child:
//                           CircularProgressIndicator()) // 위치 데이터가 준비되지 않았을 때 로딩 인디케이터 표시
//                   : GoogleMap(
//                       // 위치 데이터가 준비되었을 때 GoogleMap 위젯 표시
//                       onMapCreated: (GoogleMapController controller) {
//                         mapController = controller;
//                         if (currentPosition != null) {
//                           mapController.animateCamera(
//                               CameraUpdate.newLatLngZoom(currentPosition!, 18));
//                         }
//                       },
//                       initialCameraPosition: CameraPosition(
//                         target: currentPosition ?? const LatLng(0, 0),
//                         zoom: 18,
//                       ),
//                       markers: {
//                         if (currentPosition != null)
//                           Marker(
//                             markerId: const MarkerId('currentLocation'),
//                             icon: BitmapDescriptor.defaultMarker,
//                             position: currentPosition!,
//                           ),
//                       },
//                       polylines: Set<Polyline>.of(polylines.values),
//                     ),
//             ),
//             Expanded(
//               flex: 2, // 하단 컨테이너에 할당된 공간
//               child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(30),
//                         topRight: Radius.circular(30)),
//                     color: Colors.blueGrey[50], // 컨테이너의 배경색 설정
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           MapControllButton(
//                             height: MediaQuery.of(context).size.height * 0.1,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: Text("123.00KM"),
//                           ),
//                           MapControllButton(
//                             height: MediaQuery.of(context).size.height * 0.1,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: Text("00:10:23"),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 15.0, vertical: 5.0),
//                         child: MapControllButton(
//                           height: MediaQuery.of(context).size.height * 0.06,
//                           width: double.infinity,
//                           child: Center(
//                             child: Text("산책 시작하기"),
//                           ),
//                         ),
//                       )
//
//
//                     ],
//                   )),
//             ),
//           ],
//         ),
//       );
//
//   Future<void> fetchLocationUpdates() async {
//     locationController.changeSettings(
//       interval: 100, // 위치 업데이트 주기 (밀리초 단위)
//       distanceFilter: 0.1, // 위치 업데이트 거리 (10cm 단위)
//     );
//
//     locationController.onLocationChanged.listen((currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           currentPosition = LatLng(
//             currentLocation.latitude!,
//             currentLocation.longitude!,
//           );
//           polylineCoordinates.add(currentPosition!);
//         });
//         generatePolyLineFromPoints();
//         mapController
//             .animateCamera(CameraUpdate.newLatLngZoom(currentPosition!, 20));
//       }
//     });
//   }
//
//   Future<List<LatLng>> fetchPolylinePoints() async {
//     final polylinePoints = PolylinePoints();
//
//     // 여기에 polyline을 그릴 출발점과 도착점 좌표를 지정해야 합니다.
//     // 아래는 예시로 (0, 0) 좌표를 사용하고 있습니다.
//     final result = await polylinePoints.getRouteBetweenCoordinates(
//       googleMapsApiKey,
//       PointLatLng(0, 0),
//       PointLatLng(1, 1),
//     );
//
//     if (result.points.isNotEmpty) {
//       return result.points
//           .map((point) => LatLng(point.latitude, point.longitude))
//           .toList();
//     } else {
//       debugPrint(result.errorMessage);
//       return [];
//     }
//   }
//
//   void generatePolyLineFromPoints() {
//     const id = PolylineId('polyline');
//
//     final polyline = Polyline(
//       polylineId: id,
//       color: Colors.blueAccent,
//       points: polylineCoordinates,
//       width: 5,
//     );
//
//     setState(() => polylines[id] = polyline);
//   }
// }
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:with_pet/const/apiKey.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';

import 'package:with_pet/component/camera_after_map.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();
  late GoogleMapController mapController;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController diaryController = TextEditingController();
  LatLng? currentPosition;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Color _borderColor = Colors.red;
  bool isWalking = false;
  DateTime? walkStartTime;
  double totalDistance = 0;
  Duration totalTime = Duration.zero;
  Timer? timer;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    addCustomIcon();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeLocale();
      await fetchInitialLocation();
      await initializeMap();
    });
  }

  // 여기 DB에서 커스텀 사진 가져와서 넣기
  void addCustomIcon() async {
    BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/puppy.bmp",
    );
    setState(() {
      markerIcon = icon;
    });
  }

  Future<void> initializeLocale() async {
    await initializeDateFormatting('ko');
  }

  Future<void> fetchInitialLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await locationController.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        currentPosition =
            LatLng(locationData.latitude!, locationData.longitude!);
      });
    }
  }

  Future<void> initializeMap() async {
    if (currentPosition != null) {
      final coordinates = await fetchPolylinePoints();
      setState(() {
        polylineCoordinates = coordinates;
      });
      generatePolyLineFromPoints();
    }
    await fetchLocationUpdates();
  }

  Future<void> fetchLocationUpdates() async {
    locationController.changeSettings(
      interval: 100, // 위치 업데이트 주기 (밀리초 단위)
      distanceFilter: 0.1, // 위치 업데이트 거리 (미터 단위)
    );

    locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        LatLng newPosition =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        if (isWalking) {
          setState(() {
            polylineCoordinates.add(newPosition);
            totalDistance += calculateDistance(currentPosition!, newPosition);
          });
          generatePolyLineFromPoints();
        }
        setState(() {
          currentPosition = newPosition;
        });
        mapController
            .animateCamera(CameraUpdate.newLatLngZoom(currentPosition!, 18));
      }
    });
  }

  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000; // in meters
    double dLat = (end.latitude - start.latitude) * (3.141592653589793 / 180.0);
    double dLng =
        (end.longitude - start.longitude) * (3.141592653589793 / 180.0);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(start.latitude * (3.141592653589793 / 180.0)) *
            cos(end.latitude * (3.141592653589793 / 180.0)) *
            sin(dLng / 2) *
            sin(dLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  void generatePolyLineFromPoints() {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: const Color(0xff448aff),
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

  void startWalk() {
    setState(() {
      isWalking = true;
      walkStartTime = DateTime.now();
      totalDistance = 0;
      totalTime = Duration.zero;
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
          totalTime = DateTime.now().difference(walkStartTime!);
        });
      });
    });
  }

  void endWalk() {
    timer?.cancel();
    setState(() {
      isWalking = false;
    });
    polylineCoordinates.clear();
    showEndWalkDialog();
  }

  Future<void> showEndWalkDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("산책 종료"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${DateFormat('yyyy년 MM월 dd일 EEEE', 'ko').format(DateTime.now())}\n",
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "${totalTime.inMinutes % 60}분 ${totalTime.inSeconds % 60}초 동안 ${totalDistance.toStringAsFixed(2)}미터\n 산책했습니다!\n\n",
                style: TextStyle(fontSize: 22),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그를 닫고
                Navigator.push(
                  // 카메라 켜짐
                  context,
                  MaterialPageRoute(builder: (context) => CameraAfterMap()),
                ).then((_) {
                  // 사진 찍기 후에 실행할 코드를 여기에 추가
                  writeDiary();
                  resetWalk();
                });
              },
              child: Text("사진 찍기"),
            ),
          ],
        );
      },
    );
  }

  Future<void> writeDiary() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                '오늘의 산책 일기',
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: '제목',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제목을 입력하세요.';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20), // 간격 추가
                  TextFormField(
                    controller: diaryController,
                    maxLines: 3, // 여러 줄 입력 가능하도록 설정
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      labelText: '내용',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '내용을 입력하세요.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void resetWalk() {
    // 여기서 totalDistance, totalTime DB로 넘기기
    setState(() {
      polylineCoordinates.clear();
      totalDistance = 0;
      totalTime = Duration.zero;
      polylines.clear();
      walkStartTime = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                      if (currentPosition != null) {
                        mapController.animateCamera(
                            CameraUpdate.newLatLngZoom(currentPosition!, 18));
                      }
                    },
                    initialCameraPosition: CameraPosition(
                      target: currentPosition ?? const LatLng(0, 0),
                      zoom: 17, // 초기 줌 레벨 설정 (기존보다 더 줌 인)
                    ),
                    markers: {
                      if (currentPosition != null)
                        Marker(
                          markerId: const MarkerId("currentLocation"),
                          position: currentPosition!,
                          draggable: false,
                          // icon: markerIcon,
                        ),
                    },
                    polylines: Set<Polyline>.of(polylines.values),
                  ),
            Positioned(
              bottom: 95,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: isWalking ? endWalk : startWalk,
                style: OutlinedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Color(0xFF64d7fa),
                    side: BorderSide(
                      color: Color(0xFF64d7fa),
                    )),
                child: Text(
                  isWalking ? "종료" : "시작",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            if (isWalking)
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.65,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: Offset(0, 1),
                      ),
                    ],
                    border: Border.all(color: Color(0xFF64d7fa), width: 2),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        "산책 시간",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${totalTime.inMinutes % 60}분 ${totalTime.inSeconds % 60}초",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            if (isWalking)
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width * 0.45,
                right: MediaQuery.of(context).size.width * 0.2,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: Offset(0, 1),
                      ),
                    ],
                    border: Border.all(color: Color(0xFF64d7fa), width: 2),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        "이동 거리",
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${totalDistance.toStringAsFixed(2)} 미터",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    // 여기에 polyline을 그릴 출발점과 도착점 좌표를 지정해야 합니다.
    // 아래는 예시로 (0, 0) 좌표를 사용하고 있습니다.
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleMapsApiKey,
      PointLatLng(0, 0),
      PointLatLng(1, 1),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }
}
