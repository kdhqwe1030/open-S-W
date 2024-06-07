import "package:flutter/material.dart";

class RankComponent extends StatelessWidget {
  final int index;
  final String name;
  final String photo;
  final int distance;
  const RankComponent({
    required this.index,
    required this.name,
    required this.photo,
    required this.distance,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // ba
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(photo,
                        width: 100, height: 60, fit: BoxFit.cover)),
                SizedBox(width: 20),
                Text('$name'),
              ],
            ),
            Text('$distance'),
          ],
        ),
      ),
    );
  }
}
