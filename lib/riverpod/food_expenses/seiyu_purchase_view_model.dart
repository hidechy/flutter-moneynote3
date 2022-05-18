import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seiyu_purchase_model.dart';

import 'dart:convert';

import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////
final seiyuPurchaseProvider = StateNotifierProvider.autoDispose
    .family<SeiyuPurchaseStateNotifier, List<SeiyuPurchaseData>, String>(
        (ref, date) {
  return SeiyuPurchaseStateNotifier([])..getSeiyuPurchaseData(date: date);
});

class SeiyuPurchaseStateNotifier
    extends StateNotifier<List<SeiyuPurchaseData>> {
  SeiyuPurchaseStateNotifier(List<SeiyuPurchaseData> state) : super(state);

  ///
  void getSeiyuPurchaseData({required String date}) async {
    String url = "http://toyohide.work/BrainLog/api/seiyuuPurchaseList";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response =
        await post(Uri.parse(url), headers: headers, body: body);
    final seiyuPurchase = seiyuPurchaseFromJson(response.body);

    state = seiyuPurchase.data;
  }
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////
final seiyuPurchaseDetailProvider = StateNotifierProvider.autoDispose<
    SeiyuPurchaseDetailStateNotifier, List<SeiyuPurchaseData>>((ref) {
  return SeiyuPurchaseDetailStateNotifier([]);
});

class SeiyuPurchaseDetailStateNotifier
    extends StateNotifier<List<SeiyuPurchaseData>> {
  SeiyuPurchaseDetailStateNotifier(List<SeiyuPurchaseData> state)
      : super(state);

  ///
  void setSeiyuPurchaseDetailData({required List<SeiyuPurchaseData> data}) {
    state = data;
  }
}

//////////////////////////////////////////////////////////////////////
