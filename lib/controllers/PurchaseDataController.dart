// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class PurchaseDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "DateAmazonPurchaseData":
        //getAmazonPurchaseOfDate    //PurchaseDataController->loadData('DateAmazonPurchaseData', YMD);
        url = "http://toyohide.work/BrainLog/api/amazonPurchaseList";
        break;

      case "DateSeiyuuPurchaseData":
        //getSeiyuuPurchaseOfDate    //PurchaseDataController->loadData('DateSeiyuuPurchaseData', YMD);
        url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseList";
        break;

      case "DateSeiyuuPurchaseItemData":
        //getSeiyuuPurchaseItemOfDate    //PurchaseDataController->loadData('DateSeiyuuPurchaseItemData', YMD);
        url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseItemList";
        break;

      case "AllMercariPurchaseData":
        //getListOfMercariData    //PurchaseDataController->loadData('AllMercariPurchaseData', null);
        url = "http://toyohide.work/BrainLog/api/mercaridata";
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
