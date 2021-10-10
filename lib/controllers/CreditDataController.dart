// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class CreditDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "AllCardItemData":
        //getListOfCardItemData    //CreditDataController->loadData('AllCardItemData', null);
        url = "http://toyohide.work/BrainLog/api/carditemlist";
        break;

      case "AllCardSpendData":
        //getListOfCardSpendData    //CreditDataController->loadData('AllCardSpendData', null);
        url = "http://toyohide.work/BrainLog/api/allcardspend";
        break;

      case "DateCardSpendData":
        //getUcCardSpendOfDate    //CreditDataController->loadData('DateCardSpendData', YMD);
        url = "http://toyohide.work/BrainLog/api/uccardspend";
        break;

      case "DateCreditData":
        //getListOfCreditDateData    //CreditDataController->loadData('DateCreditData', YMD);
        url = "http://toyohide.work/BrainLog/api/getCreditDateData";
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
