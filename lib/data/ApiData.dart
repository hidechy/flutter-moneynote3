// ignore_for_file: file_names, non_constant_identifier_names, unnecessary_getters_setters, unnecessary_null_comparison

import 'package:http/http.dart';

import 'dart:convert';

import '../models/StockDetail.dart';
import '../models/ShintakuDetail.dart';
import '../models/AmazonPurchaseRecord.dart';

class ApiData {
  Map<String, String> headers = {'content-type': 'application/json'};

  ///
  Map _AuthOfLogin = {};

  ///
  Map get AuthOfLogin => _AuthOfLogin;

  ///
  set AuthOfLogin(Map AuthOfLogin) {
    _AuthOfLogin = AuthOfLogin;
  }

  Future<void> getAuthOfLogin({String? email, String? password}) async {
    String url = "http://toyohide.work/BrainLog/api/login";
    String body = json.encode({"email": email, "password": password});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    AuthOfLogin = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MoneyOfDate = {};

  Future<void> getMoneyOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/moneydownload";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MoneyOfDate = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MoneyOfAll = {};

  Future<void> getMoneyOfAll() async {
    String url = "http://toyohide.work/BrainLog/api/getAllMoney";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MoneyOfAll = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MoneyOfMonthStart = {};

  Future<void> getMoneyOfMonthStart() async {
    String url = "http://toyohide.work/BrainLog/api/getmonthstartmoney";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MoneyOfMonthStart = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map HolidayOfAll = {};

  Future<void> getHolidayOfAll() async {
    String url = "http://toyohide.work/BrainLog/api/getholiday";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    HolidayOfAll = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map BenefitOfAll = {};

  Future<void> getBenefitOfAll() async {
    String url = "http://toyohide.work/BrainLog/api/getAllBenefit";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    BenefitOfAll = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MonthSummaryOfDate = {};

  Future<void> getMonthSummaryOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthsummary";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MonthSummaryOfDate = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map DateOfTimePlaceZeroUse = {};

  Future<void> getDateOfTimePlaceZeroUse() async {
    String url = "http://toyohide.work/BrainLog/api/timeplacezerousedate";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    DateOfTimePlaceZeroUse =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfCardItemData = {};

  Future<void> getListOfCardItemData() async {
    String url = "http://toyohide.work/BrainLog/api/carditemlist";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfCardItemData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfCardSpendData = {};

  Future<void> getListOfCardSpendData() async {
    String url = "http://toyohide.work/BrainLog/api/allcardspend";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfCardSpendData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  List AmazonPurchaseOfDate = [];

  Future<void> getAmazonPurchaseOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/amazonPurchaseList";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    final amazonPurchaseRecord = amazonPurchaseRecordFromJson(response.body);
    AmazonPurchaseOfDate = amazonPurchaseRecord.data;
  }

  ///
  Map SeiyuuPurchaseOfDate = {};

  Future<void> getSeiyuuPurchaseOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseList";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    SeiyuuPurchaseOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map SeiyuuPurchaseItemOfDate = {};

  Future<void> getSeiyuuPurchaseItemOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseItemList";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    SeiyuuPurchaseItemOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfBalanceSheetData = {};

  Future<void> getListOfBalanceSheetData() async {
    String url = "http://toyohide.work/BrainLog/api/getBalanceSheetRecord";
    String body = json.encode({"date": ''});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfBalanceSheetData =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map UcCardSpendOfDate = {};

  Future<void> getUcCardSpendOfDate({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/uccardspend";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    UcCardSpendOfDate = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfGoldData = {};

  Future<void> getListOfGoldData() async {
    String url = "http://toyohide.work/BrainLog/api/getgolddata";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfGoldData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfStockData = {};

  Future<void> getListOfStockData() async {
    String url = "http://toyohide.work/BrainLog/api/getDataStock";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfStockData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfShintakuData = {};

  Future<void> getListOfShintakuData() async {
    String url = "http://toyohide.work/BrainLog/api/getDataShintaku";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfShintakuData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfFundData = {};

  Future<void> getListOfFundData() async {
    String url = "http://toyohide.work/BrainLog/api/getFundRecord";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfFundData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfDutyData = {};

  Future<void> getListOfDutyData() async {
    String url = "http://toyohide.work/BrainLog/api/dutyData";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfDutyData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfMercariData = {};

  Future<void> getListOfMercariData() async {
    String url = "http://toyohide.work/BrainLog/api/mercaridata";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfMercariData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfPlaceTimeData = {};

  Future<void> getListOfPlaceTimeData({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/timeplace";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfPlaceTimeData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MonthlySpendItemOfDate = {};

  Future<void> getMonthlySpendItemOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthlyspenditem";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MonthlySpendItemOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MonthlyTrainDataOfDate = {};

  Future<void> getMonthlyTrainDataOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthlytraindata";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MonthlyTrainDataOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map MonthlyTimePlaceDataOfDate = {};

  Future<void> getMonthlyTimePlaceDataOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthlytimeplace";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    MonthlyTimePlaceDataOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map YearSummaryOfDate = {};

  Future<void> getYearSummaryOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/yearsummary";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    YearSummaryOfDate = (response != null) ? jsonDecode(response.body) : null;
  }

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

  ///
  Map ListOfTrainData = {};

  Future<void> getListOfTrainData() async {
    String url = "http://toyohide.work/BrainLog/api/gettraindata";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfTrainData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map WeekNumOfDate = {};

  Future<void> getWeekNumOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthlyweeknum";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    WeekNumOfDate = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map WeeklySpendItemOfDate = {};

  Future<void> getWeeklySpendItemOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/spenditemweekly";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    WeeklySpendItemOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map WeeklyTimePlaceOfDate = {};

  Future<void> getWeeklyTimePlaceOfDate({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/timeplaceweekly";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    WeeklyTimePlaceOfDate =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfWellsData = {};

  Future<void> getListOfWellsData() async {
    String url = "http://toyohide.work/BrainLog/api/getWellsRecord";
    String body = json.encode({"date": ''});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfWellsData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfHomeFixData = {};

  Future<void> getListOfHomeFixData() async {
    String url = "http://toyohide.work/BrainLog/api/homeFixData";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfHomeFixData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfSalaryData = {};

  Future<void> getListOfSalaryData() async {
    String url = "http://toyohide.work/BrainLog/api/getsalary";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfSalaryData = (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  List ListOfStockDetailData = [];

  Future<void> getListOfStockDetailData() async {
    String url = "http://toyohide.work/BrainLog/api/getStockDetail";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    final stockDetail = stockDetailFromJson(response.body);
    ListOfStockDetailData = stockDetail.data;
  }

  ///
  List ListOfShintakuDetailData = [];

  Future<void> getListOfShintakuDetailData() async {
    String url = "http://toyohide.work/BrainLog/api/getShintakuDetail";
    String body = json.encode({});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);

    final shintakuDetail = shintakuDetailFromJson(response.body);
    ListOfShintakuDetailData = shintakuDetail.data;
  }

  ///
  Map ListOfMonthlySpendItemDetailData = {};

  Future<void> getListOfMonthlySpendItemDetailData({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/monthSpendItem";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfMonthlySpendItemDetailData =
        (response != null) ? jsonDecode(response.body) : null;
  }

  ///
  Map ListOfCreditDateData = {};

  Future<void> getListOfCreditDateData({String? date}) async {
    String url = "http://toyohide.work/BrainLog/api/getCreditDateData";
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    ListOfCreditDateData =
        (response != null) ? jsonDecode(response.body) : null;
  }
}
