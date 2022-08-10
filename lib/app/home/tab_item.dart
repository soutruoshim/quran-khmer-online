import 'package:flutter/material.dart';

enum TabItem{streams, schedules, account}
class TabItemData {
  const TabItemData({ @required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.streams: TabItemData(title: 'Stream', icon: Icons.videocam),
    TabItem.schedules: TabItemData(title: 'Schedule', icon: Icons.timelapse),
    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}