import 'package:freezed_annotation/freezed_annotation.dart';

part 'sameday_spend_state.freezed.dart';

@freezed
class SamedaySpendState with _$SamedaySpendState {
  const factory SamedaySpendState({
    required String ym,
    required int sum,
  }) = _SamedaySpendState;
}
