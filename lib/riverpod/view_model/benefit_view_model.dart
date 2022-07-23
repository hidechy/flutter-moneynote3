import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../models/Benefit.dart';

final benefitSearchProvider = StateNotifierProvider.autoDispose<
    BenefitSearchStateNotifier, List<dynamic>>((ref) {
  return BenefitSearchStateNotifier([])..init();
});

class BenefitSearchStateNotifier extends StateNotifier<List<dynamic>> {
  BenefitSearchStateNotifier(List<dynamic> state) : super(state);

  ///
  void init() async {
    try {
      String url = "http://toyohide.work/BrainLog/api/getAllBenefit";
      Map<String, String> headers = {'content-type': 'application/json'};
      Response response = await post(Uri.parse(url), headers: headers);
      final benefit = benefitFromJson(response.body);

      List<Map<dynamic, dynamic>> _list = [];
      for (var i = 0; i < benefit.data.length; i++) {
        var exValue = (benefit.data[i]).split('|');
        var exDate = (exValue[0]).split('-');
        Map _map = {};
        _map['ym'] = exValue[1];
        _map['price'] = exValue[2];
        _map['company'] = exValue[3];
        _map['group'] = exDate[0];
        _list.add(_map);
      }
      state = _list;
    } catch (e) {
      throw e.toString();
    }
  }
}
