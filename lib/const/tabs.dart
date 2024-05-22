import "package:flutter/material.dart";

class TabInfo {
  final IconData icon;
  final String label;

  const TabInfo({required this.icon, required this.label});
}

const TABS = [
  TabInfo(
    icon: Icons.home,
    label: "Home",
  ),
  TabInfo(
    icon: Icons.pets_outlined,
    label: "Dogwork",
  ),
  TabInfo(
    icon: Icons.account_balance_outlined,
    label: "Community",
  ),
  TabInfo(
    icon: Icons.date_range_outlined,
    label: "Calendar",
  ),
];
