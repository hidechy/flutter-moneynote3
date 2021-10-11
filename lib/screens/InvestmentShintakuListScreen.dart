// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/InvestmentDataController.dart';

class InvestmentShintakuListScreen extends StatelessWidget {
  final Utility _utility = Utility();

  InvestmentDataController investmentDataController = Get.put(
    InvestmentDataController(),
  );

  InvestmentShintakuListScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    investmentDataController.loadData(kind: 'AllShintakuDetailData');

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(context: context),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: const EdgeInsets.only(
                top: 5,
                left: 6,
              ),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
          ),
          Obx(
            () {
              if (investmentDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _shintakuList(data: investmentDataController.data);
            },
          ),
        ],
      ),
    );
  }

  ///
  Widget _shintakuList({data}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int position) => _listItem(
        position: position,
        data2: data,
      ),
    );
  }

  ///
  Widget _listItem({required int position, required List data2}) {
    var data = _makeData(data: data2);

    return Card(
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: const TextStyle(fontSize: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${data[position]['name']}'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellowAccent.withOpacity(0.3),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 5,
                ),
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 60,
                      child: Text('${data[position]['suuryou']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${data[position]['cost']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${data[position]['result']}'),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text('${data[position]['score']}'),
                    ),
                    Text('${data[position]['date']}'),
                  ],
                ),
              ),
              const Divider(color: Colors.indigo),
              _dispDetail(data: data[position]['data']),
            ],
          ),
        ),
      ),
    );
  }

  ///
  Widget _dispDetail({data}) {
    List<Widget> _list = [];

    var exData = (data).split('/');
    for (var i = 0; i < exData.length; i++) {
      var exValue = (exData[i]).split('|');
      _list.add(
        Row(
          children: <Widget>[
            SizedBox(
              width: 60,
              child: Text('${exValue[2]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[3]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[4]}'),
            ),
            SizedBox(
              width: 60,
              child: Text('${exValue[5]}'),
            ),
            Text('${exValue[0]}'),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Column(
        children: _list,
      ),
    );
  }

  ///
  List _makeData({data}) {
    List<Map<dynamic, dynamic>> _shintakuDetailData = [];

    for (var i = 0; i < data.length; i++) {
      var exData = (data[i]).split(';');

      Map _map = {};
      _map['name'] = exData[0];
      _map['date'] = exData[1];
      _map['suuryou'] = exData[2];
      _map['cost'] = exData[3];
      _map['result'] = exData[4];
      _map['score'] = exData[5];
      _map['data'] = exData[6];
      _shintakuDetailData.add(_map);
    }

    return _shintakuDetailData;
  }
}
