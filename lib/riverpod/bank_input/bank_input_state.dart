import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_input_state.freezed.dart';

@freezed
class BankInputState with _$BankInputState {
  const factory BankInputState({
    required String date,
    required int price,
    required int diff,
    required bool changeFlag,
    required bool upFlag,
    required String lastChangeDate,
  }) = _BankInputState;
}
