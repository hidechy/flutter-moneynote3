// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_final_fields

import 'package:flutter/material.dart';

import 'InvestmentStockListScreen.dart';
import 'InvestmentShintakuListScreen.dart';

class InvestmentTabScreen extends StatefulWidget {
  @override
  _InvestmentTabScreenState createState() => _InvestmentTabScreenState();
}

class TabInfo {
  String label;
  Widget widget;

  TabInfo(this.label, this.widget);
}

class _InvestmentTabScreenState extends State<InvestmentTabScreen> {
  List<TabInfo> _tabs = [
    TabInfo("Stock", InvestmentStockListScreen()),
    TabInfo("Shintaku", InvestmentShintakuListScreen())
  ];

  ///
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Investment'),
          centerTitle: true,

          //-------------------------//これを消すと「←」が出てくる（消さない）
          leading: const Icon(
            Icons.check_box_outline_blank,
            color: Color(0xFF2e2e2e),
          ),
          //-------------------------//これを消すと「←」が出てくる（消さない）

          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
              color: Colors.greenAccent,
            ),
          ],

          bottom: TabBar(
            tabs: _tabs.map((TabInfo tab) {
              return Tab(text: tab.label);
            }).toList(),
          ),
        ),
        body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
      ),
    );
  }
}
