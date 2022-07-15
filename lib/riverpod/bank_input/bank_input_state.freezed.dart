// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bank_input_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$BankInputState {
  String get date => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  int get diff => throw _privateConstructorUsedError;
  bool get changeFlag => throw _privateConstructorUsedError;
  bool get upFlag => throw _privateConstructorUsedError;
  String get lastChangeDate => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $BankInputStateCopyWith<BankInputState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankInputStateCopyWith<$Res> {
  factory $BankInputStateCopyWith(
      BankInputState value, $Res Function(BankInputState) then) =
  _$BankInputStateCopyWithImpl<$Res>;
  $Res call(
      {String date,
        int price,
        int diff,
        bool changeFlag,
        bool upFlag,
        String lastChangeDate});
}

/// @nodoc
class _$BankInputStateCopyWithImpl<$Res>
    implements $BankInputStateCopyWith<$Res> {
  _$BankInputStateCopyWithImpl(this._value, this._then);

  final BankInputState _value;
  // ignore: unused_field
  final $Res Function(BankInputState) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? price = freezed,
    Object? diff = freezed,
    Object? changeFlag = freezed,
    Object? upFlag = freezed,
    Object? lastChangeDate = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
      as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
      as int,
      diff: diff == freezed
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
      as int,
      changeFlag: changeFlag == freezed
          ? _value.changeFlag
          : changeFlag // ignore: cast_nullable_to_non_nullable
      as bool,
      upFlag: upFlag == freezed
          ? _value.upFlag
          : upFlag // ignore: cast_nullable_to_non_nullable
      as bool,
      lastChangeDate: lastChangeDate == freezed
          ? _value.lastChangeDate
          : lastChangeDate // ignore: cast_nullable_to_non_nullable
      as String,
    ));
  }
}

/// @nodoc
abstract class _$$_BankInputStateCopyWith<$Res>
    implements $BankInputStateCopyWith<$Res> {
  factory _$$_BankInputStateCopyWith(
      _$_BankInputState value, $Res Function(_$_BankInputState) then) =
  __$$_BankInputStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String date,
        int price,
        int diff,
        bool changeFlag,
        bool upFlag,
        String lastChangeDate});
}

/// @nodoc
class __$$_BankInputStateCopyWithImpl<$Res>
    extends _$BankInputStateCopyWithImpl<$Res>
    implements _$$_BankInputStateCopyWith<$Res> {
  __$$_BankInputStateCopyWithImpl(
      _$_BankInputState _value, $Res Function(_$_BankInputState) _then)
      : super(_value, (v) => _then(v as _$_BankInputState));

  @override
  _$_BankInputState get _value => super._value as _$_BankInputState;

  @override
  $Res call({
    Object? date = freezed,
    Object? price = freezed,
    Object? diff = freezed,
    Object? changeFlag = freezed,
    Object? upFlag = freezed,
    Object? lastChangeDate = freezed,
  }) {
    return _then(_$_BankInputState(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
      as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
      as int,
      diff: diff == freezed
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
      as int,
      changeFlag: changeFlag == freezed
          ? _value.changeFlag
          : changeFlag // ignore: cast_nullable_to_non_nullable
      as bool,
      upFlag: upFlag == freezed
          ? _value.upFlag
          : upFlag // ignore: cast_nullable_to_non_nullable
      as bool,
      lastChangeDate: lastChangeDate == freezed
          ? _value.lastChangeDate
          : lastChangeDate // ignore: cast_nullable_to_non_nullable
      as String,
    ));
  }
}

/// @nodoc
class _$_BankInputState implements _BankInputState {
  const _$_BankInputState(
      {required this.date,
        required this.price,
        required this.diff,
        required this.changeFlag,
        required this.upFlag,
        required this.lastChangeDate});

  @override
  final String date;
  @override
  final int price;
  @override
  final int diff;
  @override
  final bool changeFlag;
  @override
  final bool upFlag;
  @override
  final String lastChangeDate;

  @override
  String toString() {
    return 'BankInputState(date: $date, price: $price, diff: $diff, changeFlag: $changeFlag, upFlag: $upFlag, lastChangeDate: $lastChangeDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BankInputState &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality().equals(other.diff, diff) &&
            const DeepCollectionEquality()
                .equals(other.changeFlag, changeFlag) &&
            const DeepCollectionEquality().equals(other.upFlag, upFlag) &&
            const DeepCollectionEquality()
                .equals(other.lastChangeDate, lastChangeDate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(diff),
      const DeepCollectionEquality().hash(changeFlag),
      const DeepCollectionEquality().hash(upFlag),
      const DeepCollectionEquality().hash(lastChangeDate));

  @JsonKey(ignore: true)
  @override
  _$$_BankInputStateCopyWith<_$_BankInputState> get copyWith =>
      __$$_BankInputStateCopyWithImpl<_$_BankInputState>(this, _$identity);
}

abstract class _BankInputState implements BankInputState {
  const factory _BankInputState(
      {required final String date,
        required final int price,
        required final int diff,
        required final bool changeFlag,
        required final bool upFlag,
        required final String lastChangeDate}) = _$_BankInputState;

  @override
  String get date => throw _privateConstructorUsedError;
  @override
  int get price => throw _privateConstructorUsedError;
  @override
  int get diff => throw _privateConstructorUsedError;
  @override
  bool get changeFlag => throw _privateConstructorUsedError;
  @override
  bool get upFlag => throw _privateConstructorUsedError;
  @override
  String get lastChangeDate => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_BankInputStateCopyWith<_$_BankInputState> get copyWith =>
      throw _privateConstructorUsedError;
}