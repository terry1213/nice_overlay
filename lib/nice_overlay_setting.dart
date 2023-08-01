part of nice_overlay;

/// Enums which is representing child class of [NiceComponent].
enum NiceComponents {
  /// The enum which means [NiceInAppNotification].
  inAppNotification(NiceInAppNotification),

  /// The enum which means [NiceToast].
  toast(NiceToast),

  /// The enum which means [NiceSnackBar].
  snackBar(NiceSnackBar);

  const NiceComponents(this.type);

  /// The type of the enum.
  ///
  /// It will be child class type of [NiceComponent].
  final Type type;

  /// Returns [NiceComponents] enum that represents [T].
  static NiceComponents _fromType<T extends NiceComponent>() => switch (T) {
        NiceInAppNotification => NiceComponents.inAppNotification,
        NiceToast => NiceComponents.toast,
        NiceSnackBar => NiceComponents.snackBar,
        _ =>
          throw ('T of NiceComponents._fromType() should be a child class of NiceComponent'),
      };
}

/// The settings for [NiceOverlay].
class NiceOverlaySetting {
  /// The display priority of the [NiceComponent].
  ///
  /// The earlier in the list, the higher the priority.
  /// For example, if the value of displayPriority is [NiceComponents.inAppNotification, NiceComponents.toast, NiceComponents.snackBar],
  /// [NiceInAppNotification] will always be upper than [NiceToast] and [NiceSnackBar] on the screen.
  /// And [NiceToast] will always be upper than [NiceSnackBar].
  final List<NiceComponents> displayPriority;

  NiceOverlaySetting({
    this.displayPriority = const [
      NiceComponents.inAppNotification,
      NiceComponents.toast,
      NiceComponents.snackBar,
    ],
  }) {
    assert(
      NiceComponents.values.length == displayPriority.length &&
          displayPriority.toSet().containsAll(NiceComponents.values.toSet()),
      'displayPriority should contain all values of NiceComponents.',
    );
  }
}
