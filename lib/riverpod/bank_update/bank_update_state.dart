import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_update_state.freezed.dart';

@freezed
class BankUpdateState with _$BankUpdateState {
  const factory BankUpdateState({
    required String date,
    required String bank,
    required int price,
  }) = _BankUpdateState;
}
