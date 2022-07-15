// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bank_update_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BankUpdateState {
  String get date => throw _privateConstructorUsedError;
  String get bank => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BankUpdateStateCopyWith<BankUpdateState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankUpdateStateCopyWith<$Res> {
  factory $BankUpdateStateCopyWith(
          BankUpdateState value, $Res Function(BankUpdateState) then) =
      _$BankUpdateStateCopyWithImpl<$Res>;
  $Res call({String date, String bank, int price});
}

/// @nodoc
class _$BankUpdateStateCopyWithImpl<$Res>
    implements $BankUpdateStateCopyWith<$Res> {
  _$BankUpdateStateCopyWithImpl(this._value, this._then);

  final BankUpdateState _value;
  // ignore: unused_field
  final $Res Function(BankUpdateState) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? bank = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      bank: bank == freezed
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_BankUpdateStateCopyWith<$Res>
    implements $BankUpdateStateCopyWith<$Res> {
  factory _$$_BankUpdateStateCopyWith(
          _$_BankUpdateState value, $Res Function(_$_BankUpdateState) then) =
      __$$_BankUpdateStateCopyWithImpl<$Res>;
  @override
  $Res call({String date, String bank, int price});
}

/// @nodoc
class __$$_BankUpdateStateCopyWithImpl<$Res>
    extends _$BankUpdateStateCopyWithImpl<$Res>
    implements _$$_BankUpdateStateCopyWith<$Res> {
  __$$_BankUpdateStateCopyWithImpl(
      _$_BankUpdateState _value, $Res Function(_$_BankUpdateState) _then)
      : super(_value, (v) => _then(v as _$_BankUpdateState));

  @override
  _$_BankUpdateState get _value => super._value as _$_BankUpdateState;

  @override
  $Res call({
    Object? date = freezed,
    Object? bank = freezed,
    Object? price = freezed,
  }) {
    return _then(_$_BankUpdateState(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      bank: bank == freezed
          ? _value.bank
          : bank // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_BankUpdateState implements _BankUpdateState {
  const _$_BankUpdateState(
      {required this.date, required this.bank, required this.price});

  @override
  final String date;
  @override
  final String bank;
  @override
  final int price;

  @override
  String toString() {
    return 'BankUpdateState(date: $date, bank: $bank, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BankUpdateState &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality().equals(other.bank, bank) &&
            const DeepCollectionEquality().equals(other.price, price));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(bank),
      const DeepCollectionEquality().hash(price));

  @JsonKey(ignore: true)
  @override
  _$$_BankUpdateStateCopyWith<_$_BankUpdateState> get copyWith =>
      __$$_BankUpdateStateCopyWithImpl<_$_BankUpdateState>(this, _$identity);
}

abstract class _BankUpdateState implements BankUpdateState {
  const factory _BankUpdateState(
      {required final String date,
      required final String bank,
      required final int price}) = _$_BankUpdateState;

  @override
  String get date => throw _privateConstructorUsedError;
  @override
  String get bank => throw _privateConstructorUsedError;
  @override
  int get price => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BankUpdateStateCopyWith<_$_BankUpdateState> get copyWith =>
      throw _privateConstructorUsedError;
}
