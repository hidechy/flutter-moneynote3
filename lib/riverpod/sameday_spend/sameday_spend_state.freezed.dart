// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'sameday_spend_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SamedaySpendState {
  String get ym => throw _privateConstructorUsedError;
  int get sum => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SamedaySpendStateCopyWith<SamedaySpendState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SamedaySpendStateCopyWith<$Res> {
  factory $SamedaySpendStateCopyWith(
          SamedaySpendState value, $Res Function(SamedaySpendState) then) =
      _$SamedaySpendStateCopyWithImpl<$Res>;
  $Res call({String ym, int sum});
}

/// @nodoc
class _$SamedaySpendStateCopyWithImpl<$Res>
    implements $SamedaySpendStateCopyWith<$Res> {
  _$SamedaySpendStateCopyWithImpl(this._value, this._then);

  final SamedaySpendState _value;
  // ignore: unused_field
  final $Res Function(SamedaySpendState) _then;

  @override
  $Res call({
    Object? ym = freezed,
    Object? sum = freezed,
  }) {
    return _then(_value.copyWith(
      ym: ym == freezed
          ? _value.ym
          : ym // ignore: cast_nullable_to_non_nullable
              as String,
      sum: sum == freezed
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_SamedaySpendStateCopyWith<$Res>
    implements $SamedaySpendStateCopyWith<$Res> {
  factory _$$_SamedaySpendStateCopyWith(_$_SamedaySpendState value,
          $Res Function(_$_SamedaySpendState) then) =
      __$$_SamedaySpendStateCopyWithImpl<$Res>;
  @override
  $Res call({String ym, int sum});
}

/// @nodoc
class __$$_SamedaySpendStateCopyWithImpl<$Res>
    extends _$SamedaySpendStateCopyWithImpl<$Res>
    implements _$$_SamedaySpendStateCopyWith<$Res> {
  __$$_SamedaySpendStateCopyWithImpl(
      _$_SamedaySpendState _value, $Res Function(_$_SamedaySpendState) _then)
      : super(_value, (v) => _then(v as _$_SamedaySpendState));

  @override
  _$_SamedaySpendState get _value => super._value as _$_SamedaySpendState;

  @override
  $Res call({
    Object? ym = freezed,
    Object? sum = freezed,
  }) {
    return _then(_$_SamedaySpendState(
      ym: ym == freezed
          ? _value.ym
          : ym // ignore: cast_nullable_to_non_nullable
              as String,
      sum: sum == freezed
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_SamedaySpendState implements _SamedaySpendState {
  const _$_SamedaySpendState({required this.ym, required this.sum});

  @override
  final String ym;
  @override
  final int sum;

  @override
  String toString() {
    return 'SamedaySpendState(ym: $ym, sum: $sum)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SamedaySpendState &&
            const DeepCollectionEquality().equals(other.ym, ym) &&
            const DeepCollectionEquality().equals(other.sum, sum));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(ym),
      const DeepCollectionEquality().hash(sum));

  @JsonKey(ignore: true)
  @override
  _$$_SamedaySpendStateCopyWith<_$_SamedaySpendState> get copyWith =>
      __$$_SamedaySpendStateCopyWithImpl<_$_SamedaySpendState>(
          this, _$identity);
}

abstract class _SamedaySpendState implements SamedaySpendState {
  const factory _SamedaySpendState(
      {required final String ym,
      required final int sum}) = _$_SamedaySpendState;

  @override
  String get ym => throw _privateConstructorUsedError;
  @override
  int get sum => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SamedaySpendStateCopyWith<_$_SamedaySpendState> get copyWith =>
      throw _privateConstructorUsedError;
}
