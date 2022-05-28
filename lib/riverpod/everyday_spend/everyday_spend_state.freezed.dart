// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'everyday_spend_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EverydaySpendState {
  String get date => throw _privateConstructorUsedError;
  int get spend => throw _privateConstructorUsedError;
  String get record => throw _privateConstructorUsedError;
  int get diff => throw _privateConstructorUsedError;
  String get step => throw _privateConstructorUsedError;
  String get distance => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EverydaySpendStateCopyWith<EverydaySpendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EverydaySpendStateCopyWith<$Res> {
  factory $EverydaySpendStateCopyWith(
          EverydaySpendState value, $Res Function(EverydaySpendState) then) =
      _$EverydaySpendStateCopyWithImpl<$Res>;
  $Res call(
      {String date,
      int spend,
      String record,
      int diff,
      String step,
      String distance});
}

/// @nodoc
class _$EverydaySpendStateCopyWithImpl<$Res>
    implements $EverydaySpendStateCopyWith<$Res> {
  _$EverydaySpendStateCopyWithImpl(this._value, this._then);

  final EverydaySpendState _value;
  // ignore: unused_field
  final $Res Function(EverydaySpendState) _then;

  @override
  $Res call({
    Object? date = freezed,
    Object? spend = freezed,
    Object? record = freezed,
    Object? diff = freezed,
    Object? step = freezed,
    Object? distance = freezed,
  }) {
    return _then(_value.copyWith(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      spend: spend == freezed
          ? _value.spend
          : spend // ignore: cast_nullable_to_non_nullable
              as int,
      record: record == freezed
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as String,
      diff: diff == freezed
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as int,
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      distance: distance == freezed
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_EverydaySpendStateCopyWith<$Res>
    implements $EverydaySpendStateCopyWith<$Res> {
  factory _$$_EverydaySpendStateCopyWith(_$_EverydaySpendState value,
          $Res Function(_$_EverydaySpendState) then) =
      __$$_EverydaySpendStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String date,
      int spend,
      String record,
      int diff,
      String step,
      String distance});
}

/// @nodoc
class __$$_EverydaySpendStateCopyWithImpl<$Res>
    extends _$EverydaySpendStateCopyWithImpl<$Res>
    implements _$$_EverydaySpendStateCopyWith<$Res> {
  __$$_EverydaySpendStateCopyWithImpl(
      _$_EverydaySpendState _value, $Res Function(_$_EverydaySpendState) _then)
      : super(_value, (v) => _then(v as _$_EverydaySpendState));

  @override
  _$_EverydaySpendState get _value => super._value as _$_EverydaySpendState;

  @override
  $Res call({
    Object? date = freezed,
    Object? spend = freezed,
    Object? record = freezed,
    Object? diff = freezed,
    Object? step = freezed,
    Object? distance = freezed,
  }) {
    return _then(_$_EverydaySpendState(
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      spend: spend == freezed
          ? _value.spend
          : spend // ignore: cast_nullable_to_non_nullable
              as int,
      record: record == freezed
          ? _value.record
          : record // ignore: cast_nullable_to_non_nullable
              as String,
      diff: diff == freezed
          ? _value.diff
          : diff // ignore: cast_nullable_to_non_nullable
              as int,
      step: step == freezed
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as String,
      distance: distance == freezed
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_EverydaySpendState implements _EverydaySpendState {
  const _$_EverydaySpendState(
      {required this.date,
      required this.spend,
      required this.record,
      required this.diff,
      required this.step,
      required this.distance});

  @override
  final String date;
  @override
  final int spend;
  @override
  final String record;
  @override
  final int diff;
  @override
  final String step;
  @override
  final String distance;

  @override
  String toString() {
    return 'EverydaySpendState(date: $date, spend: $spend, record: $record, diff: $diff, step: $step, distance: $distance)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EverydaySpendState &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality().equals(other.spend, spend) &&
            const DeepCollectionEquality().equals(other.record, record) &&
            const DeepCollectionEquality().equals(other.diff, diff) &&
            const DeepCollectionEquality().equals(other.step, step) &&
            const DeepCollectionEquality().equals(other.distance, distance));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(spend),
      const DeepCollectionEquality().hash(record),
      const DeepCollectionEquality().hash(diff),
      const DeepCollectionEquality().hash(step),
      const DeepCollectionEquality().hash(distance));

  @JsonKey(ignore: true)
  @override
  _$$_EverydaySpendStateCopyWith<_$_EverydaySpendState> get copyWith =>
      __$$_EverydaySpendStateCopyWithImpl<_$_EverydaySpendState>(
          this, _$identity);
}

abstract class _EverydaySpendState implements EverydaySpendState {
  const factory _EverydaySpendState(
      {required final String date,
      required final int spend,
      required final String record,
      required final int diff,
      required final String step,
      required final String distance}) = _$_EverydaySpendState;

  @override
  String get date => throw _privateConstructorUsedError;
  @override
  int get spend => throw _privateConstructorUsedError;
  @override
  String get record => throw _privateConstructorUsedError;
  @override
  int get diff => throw _privateConstructorUsedError;
  @override
  String get step => throw _privateConstructorUsedError;
  @override
  String get distance => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_EverydaySpendStateCopyWith<_$_EverydaySpendState> get copyWith =>
      throw _privateConstructorUsedError;
}
