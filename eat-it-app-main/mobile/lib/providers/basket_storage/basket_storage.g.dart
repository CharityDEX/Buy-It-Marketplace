// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_storage.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$basketStorageHash() => r'22a60c48c9061be23f4fc84abe43eec65ebcb0aa';

/// See also [BasketStorage].
@ProviderFor(BasketStorage)
final basketStorageProvider =
    AutoDisposeAsyncNotifierProvider<BasketStorage, List<BasketItem>>.internal(
  BasketStorage.new,
  name: r'basketStorageProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$basketStorageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BasketStorage = AutoDisposeAsyncNotifier<List<BasketItem>>;
String _$basketPointsHash() => r'dd6de6a01b56a0805c42a62e1b8963cb070640aa';

/// See also [basketPoints].
@ProviderFor(basketPoints)
final basketPointsProvider = AutoDisposeProvider<int>.internal(
  basketPoints,
  name: r'basketPointsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$basketPointsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BasketPointsRef = AutoDisposeProviderRef<int>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
