// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class MoneyDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "DateMoneyData":
        //getMoneyOfDate    //MoneyDataController->loadData('DateMoneyData', YMD);
        url = "http://toyohide.work/BrainLog/api/moneydownload";
        break;

      case "AllMoneyData":
        //getMoneyOfAll    //MoneyDataController->loadData('AllMoneyData', null);
        url = "http://toyohide.work/BrainLog/api/getAllMoney";
        break;

      case "AllMonthStartMoneyData":
        //getMoneyOfMonthStart    //MoneyDataController->loadData('AllMonthStartMoneyData', null);
        url = "http://toyohide.work/BrainLog/api/getmonthstartmoney";
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
