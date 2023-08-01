library nice_overlay;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'in_app_notification/in_app_notification.dart';
part 'in_app_notification/in_app_notification_controller.dart';
part 'nice_component.dart';
part 'nice_component_controller.dart';
part 'nice_overlay_setting.dart';
part 'snack_bar/snack_bar.dart';
part 'snack_bar/snack_bar_controller.dart';
part 'toast/toast.dart';
part 'toast/toast_controller.dart';

/// A master controller that manages all kinds of [NiceComponent].
class NiceOverlay {
  static final NiceOverlay _instance = NiceOverlay._internal();
  factory NiceOverlay() => _instance;
  NiceOverlay._internal();

  /// The navigator key to get an overlay of the app.
  static GlobalKey<NavigatorState>? _navigatorKey;

  /// The settings for [NiceOverlay].
  static NiceOverlaySetting _niceOverlaySetting = NiceOverlaySetting();

  /// The controller of [NiceInAppNotification].
  static final _NiceInAppNotificationController
      _niceInAppNotificationController = _NiceInAppNotificationController();

  /// The controller of [NiceSnackBar].
  static final _NiceSnackBarController _niceSnackBarController =
      _NiceSnackBarController();

  /// The controller of [NiceToast].
  static final _NiceToastController _niceToastController =
      _NiceToastController();

  /// Initialize the [NiceOverlay] by setting [navigatorKey] and [niceOverlaySetting].
  static void init(
    GlobalKey<NavigatorState> navigatorKey, {
    NiceOverlaySetting? niceOverlaySetting,
  }) {
    _navigatorKey = navigatorKey;
    _niceOverlaySetting = niceOverlaySetting ?? _niceOverlaySetting;
  }

  /// Whether any component is open.
  static bool get isNiceOverlayOpen =>
      isInAppNotificationOpen || isSnackBarOpen || isToastOpen;

  /// Whether [NiceInAppNotification] is open.
  static bool get isInAppNotificationOpen =>
      _niceInAppNotificationController._isComponentOpen;

  /// Whether [NiceSnackBar] is open.
  static bool get isSnackBarOpen => _niceSnackBarController._isComponentOpen;

  /// Whether [NiceToast] is open.
  static bool get isToastOpen => _niceToastController._isComponentOpen;

  /// Returns the overlay that should be placed directly above the new overlay.
  ///
  /// If return value is null, that means the new overlay will be placed on top.
  static OverlayEntry? _getUpperOverlay<T extends NiceComponent>() {
    int indexOfOverlay = _niceOverlaySetting.displayPriority
        .indexOf(NiceComponents._fromType<T>());

    List<NiceComponents> upperTypes = _niceOverlaySetting.displayPriority
        .sublist(0, indexOfOverlay)
        .reversed
        .toList();

    OverlayEntry? upperOverlay;
    for (var upperType in upperTypes) {
      upperOverlay = switch (upperType) {
        NiceComponents.inAppNotification =>
          _niceInAppNotificationController._overlay,
        NiceComponents.snackBar => _niceSnackBarController._overlay,
        NiceComponents.toast => _niceToastController._overlay,
      };
      if (upperOverlay != null) {
        break;
      }
    }

    return upperOverlay;
  }

  /// Shows [niceInAppNotification] on the screen.
  static void showInAppNotification(
          NiceInAppNotification niceInAppNotification) =>
      _niceInAppNotificationController.showComponent(niceInAppNotification);

  /// Shows [niceSnackBar] on the screen.
  static void showSnackBar(NiceSnackBar niceSnackBar) =>
      _niceSnackBarController.showComponent(niceSnackBar);

  /// Shows [niceToast] on the screen.
  static void showToast(NiceToast niceToast) =>
      _niceToastController.showComponent(niceToast);

  /// Closes [NiceInAppNotification] from the screen.
  static void closeInAppNotification() =>
      _niceInAppNotificationController.closeComponent();

  /// Closes [NiceSnackBar] from the screen.
  static void closeSnackBar() => _niceSnackBarController.closeComponent();

  /// Closes [NiceToast] from the screen.
  static void closeToast() => _niceToastController.closeComponent();

  /// Closes [NiceInAppNotification] from the screen and clears the [NiceInAppNotification] queue.
  static void closeAllInAppNotification() =>
      _niceInAppNotificationController.closeAllComponent();

  /// Closes [NiceSnackBar] from the screen and clears the [NiceSnackBar] queue.
  static void closeAllSnackBar() => _niceSnackBarController.closeAllComponent();

  /// Closes [NiceToast] from the screen and clears the [NiceToast] queue.
  static void closeAllToast() => _niceToastController.closeAllComponent();

  /// Clears the [NiceInAppNotification] queue.
  static void clearInAppNotificationQueue() =>
      _niceInAppNotificationController.clearComponentQueue();

  /// Clears the [NiceSnackBar] queue.
  static void clearSnackBarQueue() =>
      _niceSnackBarController.clearComponentQueue();

  /// Clears the [NiceToast] queue.
  static void clearToastQueue() => _niceToastController.clearComponentQueue();
}
