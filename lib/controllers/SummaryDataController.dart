// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/HomeFix.dart';

class SummaryDataController extends GetxController {
  List data = [].obs;

  RxBool loading = false.obs;

  loadData({required String kind, var date}) async {
    loading(true);

    var url = "";
    switch (kind) {
      case "DateMonthSummaryData":
        //getMonthSummaryOfDate    //SummaryDataController->loadData('DateMonthSummaryData', YMD);
        url = "http://toyohide.work/BrainLog/api/monthsummary";
        break;

      case "AllDutyData":
        //getListOfDutyData    //SummaryDataController->loadData('AllDutyData', null);
        url = "http://toyohide.work/BrainLog/api/dutyData";
        break;

      case "DateYearSummaryData":
        //getYearSummaryOfDate    //SummaryDataController->loadData('DateYearSummaryData', YMD);
        url = "http://toyohide.work/BrainLog/api/yearsummary";
        break;

      case "DateMonthlyWeekNumData":
        //getWeekNumOfDate    //SummaryDataController->loadData('DateMonthlyWeekNumData', YMD);
        url = "http://toyohide.work/BrainLog/api/monthlyweeknum";
        break;

      case "AllHomeFixData":
        //getListOfHomeFixData    //SummaryDataController->loadData('AllHomeFixData', null);
        url = "http://toyohide.work/BrainLog/api/homeFixData";
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
      case "AllHomeFixData":
        final homeFix = homeFixFromJson(response.body);
        data = homeFix.data;
        break;

      case "AllDutyData":
      case "DateMonthSummaryData":
      case "DateYearSummaryData":
      case "DateMonthlyWeekNumData":
        var decoded = json.decode(response.body);
        data = decoded['data'];
        break;
    }

    loading(false);
  }
}
