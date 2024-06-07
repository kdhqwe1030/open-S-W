import "package:flutter/material.dart";

class TabInfo {
  final IconData icon;
  final String label;

  const TabInfo({required this.icon, required this.label});
}

const TABS = [
  TabInfo(
    icon: Icons.home,
    label: "홈",
  ),
  TabInfo(
    icon: Icons.pets_outlined,
    label: "산책 기록",
  ),
  TabInfo(
    icon: Icons.grade,
    label: "랭킹",
  ),
  TabInfo(
    icon: Icons.date_range_rounded,
    label: "캘린더",
  ),
];
