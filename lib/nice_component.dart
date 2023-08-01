part of nice_overlay;

/// A class that includes all nice components([NiceInAppNotification], [NiceSnackBar], [NiceToast]).
///
/// But this class can't be created(because the constructor is private).
/// It is used for restricting the type in Generic.
///
/// The only properties that be used in [_NiceComponentController] are defined in this class.
sealed class NiceComponent extends Widget {
  /// The minimum duration of display [NiceComponent] when queue is not empty.
  final Duration minimumDisplayDuration;

  /// The animation duration of showing [NiceComponent].
  final Duration showingAnimationDuration;

  const NiceComponent._({
    required this.minimumDisplayDuration,
    required this.showingAnimationDuration,
  });
}
