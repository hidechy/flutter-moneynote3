// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class TrainDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "DateMonthlyTrainData":
        //getMonthlyTrainDataOfDate    //TrainDataController->loadData('DateMonthlyTrainData', YMD);
        url = "http://toyohide.work/BrainLog/api/monthlytraindata";
        break;

      case "AllTrainData":
        //getListOfTrainData    //TrainDataController->loadData('AllTrainData', null);
        url = "http://toyohide.work/BrainLog/api/gettraindata";
        break;
    }

    Map<String, String> headers = {'content-type': 'application/json'};

    String body = "";
    if (date == null) {
      body = json.encode({});
    } else {
      body = json.encode({"date": date});
    }

    var response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    var decoded = json.decode(response.body);

    data = decoded['data'];

    loading(false);
  }
}
