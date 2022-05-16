import 'package:freezed_annotation/freezed_annotation.dart';

part 'money_state.freezed.dart';

@freezed
class MoneyState with _$MoneyState {
  const factory MoneyState({
    required String date,
    required int yen_10000,
    required int yen_5000,
    required int yen_2000,
    required int yen_1000,
    required int yen_500,
    required int yen_100,
    required int yen_50,
    required int yen_10,
    required int yen_5,
    required int yen_1,
    required int bankA,
    required int bankB,
    required int bankC,
    required int bankD,
    required int bankE,
    required int peyA,
    required int peyB,
    required int peyC,
    required int peyD,
    required int peyE,
    required int total,
  }) = _MoneyState;
}
