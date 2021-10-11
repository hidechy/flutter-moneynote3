// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utilities/utility.dart';
import '../utilities/CustomShapeClipper.dart';

import '../controllers/SummaryDataController.dart';

class YachinDataDisplayScreen extends StatelessWidget {
  SummaryDataController summaryDataController = Get.put(
    SummaryDataController(),
  );

  final Utility _utility = Utility();

  YachinDataDisplayScreen({Key? key}) : super(key: key);

  ///
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    summaryDataController.loadData(kind: 'AllHomeFixData');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('家計固定費'),
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
      ),
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
              if (summaryDataController.loading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return _yachinList(data: summaryDataController.data);
            },
          ),
        ],
      ),
    );
  }

  /// リスト表示
  Widget _yachinList({data}) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int position) => _listItem(
        position: position,
        data2: data,
      ),
    );
  }

  /// リストアイテム表示
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
              Text('${data[position]['ym']}'),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.home,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['yachin']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.wifi,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['wifi']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.mobileAlt,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['mobile']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.bolt,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['denki']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.burn,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['gas']}')
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: 40,
                    child: const Icon(
                      FontAwesomeIcons.tint,
                      size: 12,
                    ),
                  ),
                  Text('${data[position]['suidou']}')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  List _makeData({data}) {
    List<Map<dynamic, dynamic>> _yachinData = [];

    for (var i = 0; i < data.length; i++) {
      var exData = (data[i]).split('|');

      Map _map = {};

      _map['ym'] = exData[0];
      _map['yachin'] = exData[1];
      _map['wifi'] = exData[2];
      _map['mobile'] = exData[3];
      _map['gas'] = exData[4];
      _map['denki'] = exData[5];
      _map['suidou'] = exData[6];

      _yachinData.add(_map);
    }

    return _yachinData;
  }
}
