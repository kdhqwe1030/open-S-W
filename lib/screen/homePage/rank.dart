import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../component/rank_component.dart'; // RankComponent 파일 경로 확인 필요

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Dogs')
                  .orderBy('distance', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                final dogs = snapshot.data!.docs;
                return Column(
                  children: dogs.map((dog) {
                    final data = dog.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Unknown';
                    final distance = data['distance']?.toInt() ?? 0;
                    final photoURL =
                        data['photoURL'] ?? 'asset/img/profile.jpg';
                    final index = dogs.indexOf(dog) + 1;

                    return Column(
                      children: [
                        RankComponent(
                          index: index,
                          name: name,
                          photoURL: photoURL,
                          distance: distance.toDouble(),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
