import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

//////////////////////////////////////////////////////////////////////

final timeplaceZerousedateProvider = StateNotifierProvider.autoDispose<
    TimeplaceZerousedateStateNotifier, List<dynamic>>((ref) {
  return TimeplaceZerousedateStateNotifier([])..getTimeplaceZerousedateData();
});

class TimeplaceZerousedateStateNotifier extends StateNotifier<List<dynamic>> {
  TimeplaceZerousedateStateNotifier(List<dynamic> state) : super(state);

  ///
  void getTimeplaceZerousedateData() async {
    String url = "http://toyohide.work/BrainLog/api/timeplacezerousedate";
    Map<String, String> headers = {'content-type': 'application/json'};
    Response response = await post(Uri.parse(url), headers: headers);
    final timeplaceZerousedate = jsonDecode(response.body);
    state = timeplaceZerousedate['data'];
  }
}

//////////////////////////////////////////////////////////////////////
