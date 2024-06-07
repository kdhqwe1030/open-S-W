import 'package:flutter/material.dart';

import '../../component/rank_component.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
            RankComponent(
                index: 1,
                name: "뽀삐",
                photo: "asset/img/profile.jpg",
                distance: 123984),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
