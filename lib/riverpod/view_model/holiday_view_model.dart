import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////

final holidayProvider =
    StateNotifierProvider.autoDispose<HolidayStateNotifier, List<dynamic>>(
        (ref) {
  return HolidayStateNotifier([])..getHolidayData();
});

class HolidayStateNotifier extends StateNotifier<List<dynamic>> {
  HolidayStateNotifier(List<dynamic> state) : super(state);

  ///
  void getHolidayData() async {
    String url = "http://toyohide.work/BrainLog/api/getholiday";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    final holiday = jsonDecode(response.body);
    state = holiday['data'];
  }
}

//////////////////////////////////////////////////////////////////////
