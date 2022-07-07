import 'package:flutter_riverpod/flutter_riverpod.dart';

//////////////////////////////////////////////////////////////////////

final graphSelectProvider =
    StateNotifierProvider.autoDispose<GraphSelectStateNotifier, bool>((ref) {
  return GraphSelectStateNotifier(false);
});

class GraphSelectStateNotifier extends StateNotifier<bool> {
  GraphSelectStateNotifier(bool state) : super(state);

  ///
  void toggleGraph() async {
    state = !state;
  }
}

//////////////////////////////////////////////////////////////////////
