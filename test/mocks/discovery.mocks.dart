// Mocks generated by Mockito 5.4.4 from annotations
// in wallet/test/mocks/discovery.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i11;
import 'dart:ui' as _i8;

import 'package:flutter/material.dart' as _i5;
import 'package:mockito/mockito.dart' as _i3;
import 'package:wallet/managers/manager.factory.dart' as _i6;
import 'package:wallet/scenes/components/discover/proton.feeditem.dart' as _i10;
import 'package:wallet/scenes/core/coordinator.dart' as _i2;
import 'package:wallet/scenes/core/view.dart' as _i4;
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart' as _i12;
import 'package:wallet/scenes/core/viewmodel.dart' as _i1;
import 'package:wallet/scenes/discover/discover.coordinator.dart' as _i7;
import 'package:wallet/scenes/discover/discover.viewmodel.dart' as _i9;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeViewBase_0<V extends _i1.ViewModel<_i2.Coordinator>>
    extends _i3.SmartFake implements _i4.ViewBase<V> {
  _FakeViewBase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );

  @override
  String toString({_i5.DiagnosticLevel? minLevel = _i5.DiagnosticLevel.info}) =>
      super.toString();
}

class _FakeGlobalKey_1<T extends _i5.State<_i5.StatefulWidget>>
    extends _i3.SmartFake implements _i5.GlobalKey<T> {
  _FakeGlobalKey_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeManagerFactory_2 extends _i3.SmartFake
    implements _i6.ManagerFactory {
  _FakeManagerFactory_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDiscoverCoordinator_3 extends _i3.SmartFake
    implements _i7.DiscoverCoordinator {
  _FakeDiscoverCoordinator_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [DiscoverCoordinator].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiscoverCoordinator extends _i3.Mock
    implements _i7.DiscoverCoordinator {
  MockDiscoverCoordinator() {
    _i3.throwOnMissingStub(this);
  }

  @override
  _i4.ViewBase<_i1.ViewModel<_i2.Coordinator>> get widget =>
      (super.noSuchMethod(
        Invocation.getter(#widget),
        returnValue: _FakeViewBase_0<_i1.ViewModel<_i2.Coordinator>>(
          this,
          Invocation.getter(#widget),
        ),
      ) as _i4.ViewBase<_i1.ViewModel<_i2.Coordinator>>);

  @override
  set widget(_i4.ViewBase<_i1.ViewModel<_i2.Coordinator>>? _widget) =>
      super.noSuchMethod(
        Invocation.setter(
          #widget,
          _widget,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.GlobalKey<_i5.NavigatorState> get navigatorKey => (super.noSuchMethod(
        Invocation.getter(#navigatorKey),
        returnValue: _FakeGlobalKey_1<_i5.NavigatorState>(
          this,
          Invocation.getter(#navigatorKey),
        ),
      ) as _i5.GlobalKey<_i5.NavigatorState>);

  @override
  _i6.ManagerFactory get serviceManager => (super.noSuchMethod(
        Invocation.getter(#serviceManager),
        returnValue: _FakeManagerFactory_2(
          this,
          Invocation.getter(#serviceManager),
        ),
      ) as _i6.ManagerFactory);

  @override
  void end() => super.noSuchMethod(
        Invocation.method(
          #end,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.ViewBase<_i1.ViewModel<_i2.Coordinator>> start() => (super.noSuchMethod(
        Invocation.method(
          #start,
          [],
        ),
        returnValue: _FakeViewBase_0<_i1.ViewModel<_i2.Coordinator>>(
          this,
          Invocation.method(
            #start,
            [],
          ),
        ),
      ) as _i4.ViewBase<_i1.ViewModel<_i2.Coordinator>>);

  @override
  List<_i5.Widget> starts() => (super.noSuchMethod(
        Invocation.method(
          #starts,
          [],
        ),
        returnValue: <_i5.Widget>[],
      ) as List<_i5.Widget>);

  @override
  void showInBottomSheet(
    _i5.Widget? view, {
    _i8.Color? backgroundColor,
    bool? fullScreen = false,
    bool? enableDrag = true,
    bool? isDismissible = true,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #showInBottomSheet,
          [view],
          {
            #backgroundColor: backgroundColor,
            #fullScreen: fullScreen,
            #enableDrag: enableDrag,
            #isDismissible: isDismissible,
          },
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pushReplacement(
    _i5.Widget? view, {
    bool? fullscreenDialog = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #pushReplacement,
          [view],
          {#fullscreenDialog: fullscreenDialog},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pushReplacementRemoveAll(
    _i5.Widget? view, {
    bool? fullscreenDialog = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #pushReplacementRemoveAll,
          [view],
          {#fullscreenDialog: fullscreenDialog},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void push(
    _i5.Widget? view, {
    bool? fullscreenDialog = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #push,
          [view],
          {#fullscreenDialog: fullscreenDialog},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pop() => super.noSuchMethod(
        Invocation.method(
          #pop,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pushCustom(
    _i5.Widget? view, {
    bool? fullscreenDialog = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #pushCustom,
          [view],
          {#fullscreenDialog: fullscreenDialog},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void pushReplacementCustom(
    _i5.Widget? view, {
    bool? fullscreenDialog = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #pushReplacementCustom,
          [view],
          {#fullscreenDialog: fullscreenDialog},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void showDialog1(_i5.Widget? view) => super.noSuchMethod(
        Invocation.method(
          #showDialog1,
          [view],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [DiscoverViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiscoverViewModel extends _i3.Mock implements _i9.DiscoverViewModel {
  MockDiscoverViewModel() {
    _i3.throwOnMissingStub(this);
  }

  @override
  bool get initialized => (super.noSuchMethod(
        Invocation.getter(#initialized),
        returnValue: false,
      ) as bool);

  @override
  set initialized(bool? _initialized) => super.noSuchMethod(
        Invocation.setter(
          #initialized,
          _initialized,
        ),
        returnValueForMissingStub: null,
      );

  @override
  List<_i10.ProtonFeedItem> get protonFeedItems => (super.noSuchMethod(
        Invocation.getter(#protonFeedItems),
        returnValue: <_i10.ProtonFeedItem>[],
      ) as List<_i10.ProtonFeedItem>);

  @override
  set protonFeedItems(List<_i10.ProtonFeedItem>? _protonFeedItems) =>
      super.noSuchMethod(
        Invocation.setter(
          #protonFeedItems,
          _protonFeedItems,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i7.DiscoverCoordinator get coordinator => (super.noSuchMethod(
        Invocation.getter(#coordinator),
        returnValue: _FakeDiscoverCoordinator_3(
          this,
          Invocation.getter(#coordinator),
        ),
      ) as _i7.DiscoverCoordinator);

  @override
  set currentSize(_i4.ViewSize? _currentSize) => super.noSuchMethod(
        Invocation.setter(
          #currentSize,
          _currentSize,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i11.Stream<_i1.ViewModel<_i2.Coordinator>> get datasourceChanged =>
      (super.noSuchMethod(
        Invocation.getter(#datasourceChanged),
        returnValue: _i11.Stream<_i1.ViewModel<_i2.Coordinator>>.empty(),
      ) as _i11.Stream<_i1.ViewModel<_i2.Coordinator>>);

  @override
  bool get isMobileSize => (super.noSuchMethod(
        Invocation.getter(#isMobileSize),
        returnValue: false,
      ) as bool);

  @override
  bool get keepAlive => (super.noSuchMethod(
        Invocation.getter(#keepAlive),
        returnValue: false,
      ) as bool);

  @override
  bool get mobile => (super.noSuchMethod(
        Invocation.getter(#mobile),
        returnValue: false,
      ) as bool);

  @override
  bool get desktop => (super.noSuchMethod(
        Invocation.getter(#desktop),
        returnValue: false,
      ) as bool);

  @override
  bool get screenSizeState => (super.noSuchMethod(
        Invocation.getter(#screenSizeState),
        returnValue: false,
      ) as bool);

  @override
  void sinkAddSafe() => super.noSuchMethod(
        Invocation.method(
          #sinkAddSafe,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i11.Future<void> loadData() => (super.noSuchMethod(
        Invocation.method(
          #loadData,
          [],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i11.Future<void> move(_i12.NavID? to) => (super.noSuchMethod(
        Invocation.method(
          #move,
          [to],
        ),
        returnValue: _i11.Future<void>.value(),
        returnValueForMissingStub: _i11.Future<void>.value(),
      ) as _i11.Future<void>);
}
