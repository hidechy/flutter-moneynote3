// ignore_for_file: file_names

import 'package:get/get.dart';

//import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

//import 'dart:convert';

class TrainDataController extends GetxController {
  List data = [].obs;
  Map data2 = {}.obs;

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

    var dio = Dio();

    await dio
        .post(
      url,
      options: Options(headers: headers),
    )
        .then(
      (response) {
        switch (kind) {
          case "DateMonthlyTrainData":
            data = response.data['data'];
            break;

          case "AllTrainData":
            data2 = response.data['data'];
            break;
        }
      },
    );

    loading(false);
  }
}
