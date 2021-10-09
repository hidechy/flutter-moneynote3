import 'package:get/get.dart';

class BankDataController extends GetxController {}

/*
  ///
  Map MonthlyBankRecordOfDate = {};

  Future<void> getMonthlyBankRecordOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/getMonthlyBankRecord";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MonthlyBankRecordOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

*/
