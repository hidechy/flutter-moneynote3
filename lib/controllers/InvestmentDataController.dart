// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/GoldRecord.dart';

class InvestmentDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "AllGoldData":
        //getListOfGoldData    //InvestmentDataController->loadData('AllGoldData', null);
        url = "http://toyohide.work/BrainLog/api/getgolddata";
        break;

      case "AllStockData":
        //getListOfStockData    //InvestmentDataController->loadData('AllStockData', null);
        url = "http://toyohide.work/BrainLog/api/getDataStock";
        break;

      case "AllStockDetailData":
        //getListOfStockDetailData    //InvestmentDataController->loadData('AllStockDetailData', null);
        url = "http://toyohide.work/BrainLog/api/getStockDetail";
        break;

      case "AllShintakuData":
        //getListOfShintakuData    //InvestmentDataController->loadData('AllShintakuData', null);
        url = "http://toyohide.work/BrainLog/api/getDataShintaku";
        break;

      case "AllShintakuDetailData":
        //getListOfShintakuDetailData    //InvestmentDataController->loadData('AllShintakuDetailData', null);
        url = "http://toyohide.work/BrainLog/api/getShintakuDetail";
        break;

      case "AllFundData":
        //getListOfFundData    //InvestmentDataController->loadData('AllFundData', null);
        url = "http://toyohide.work/BrainLog/api/getFundRecord";
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

    switch (kind) {
      case "AllGoldData":
        final goldRecord = goldRecordFromJson(response.body);
        data = goldRecord.data;
        break;

      case "AllStockData":
      case "AllStockDetailData":
      case "AllShintakuData":
      case "AllShintakuDetailData":
      case "AllFundData":
        var decoded = json.decode(response.body);
        data = decoded['data'];
        break;
    }

    loading(false);
  }
}
