import 'package:freezed_annotation/freezed_annotation.dart';

part 'everyday_spend_state.freezed.dart';

@freezed
class EverydaySpendState with _$EverydaySpendState {
  const factory EverydaySpendState({
    required String date,
    required int spend,
    required String record,
    required int diff,
    required String step,
    required String distance,
  }) = _EverydaySpendState;
}
