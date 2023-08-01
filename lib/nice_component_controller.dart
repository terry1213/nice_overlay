part of nice_overlay;

/// A controller that manages [T] which is a specific child class of [NiceComponent].
abstract class _NiceComponentController<T extends NiceComponent> {
  /// The overlay which is currently displayed on screen.
  OverlayEntry? _overlay;

  /// The queue which contains waiting components.
  final List<T> _componentQueue = [];

  /// The timer to check if the queue is full when [NiceComponent.minimumDisplayDuration] is over.
  Timer? _queuedCheckTimer;

  /// Whether the component is open.
  bool get _isComponentOpen => _overlay != null;

  /// Whether the [_componentQueue] is not empty.
  bool get _isComponentQueueNotEmpty => _componentQueue.isNotEmpty;

  /// Adds [niceComponent] to the [_componentQueue] to shows it on the screen later.
  void showComponent(T niceComponent) {
    if (!_isComponentOpen && !_isComponentQueueNotEmpty) {
      _componentQueue.add(niceComponent);
      _showNextComponentImmediately();
    } else if (_queuedCheckTimer != null && !_queuedCheckTimer!.isActive) {
      _componentQueue.add(niceComponent);
      closeComponent();
    } else {
      _componentQueue.add(niceComponent);
    }
  }

  /// Shows next component immediately.
  void _showNextComponentImmediately() {
    GlobalKey<NavigatorState>? navigatorKey = NiceOverlay._navigatorKey;

    if (navigatorKey == null) {
      closeAllComponent();
      throw ("Error: _navigatorKey is null, NiceOverlay.init(navigatorKey) should be call before showing $T.");
    }

    T niceComponent = _componentQueue.removeAt(0);
    _overlay = OverlayEntry(
      builder: (_) => niceComponent,
    );

    OverlayEntry? upperOverlay = NiceOverlay._getUpperOverlay<T>();

    navigatorKey.currentState!.overlay!.insert(_overlay!, below: upperOverlay);

    _queuedCheckTimer = Timer(
        niceComponent.showingAnimationDuration +
            niceComponent.minimumDisplayDuration, () {
      if (_isComponentQueueNotEmpty) {
        closeComponent();
      }
    });
  }

  /// Closes component from the screen.
  void closeComponent() {
    _queuedCheckTimer?.cancel();
    _overlay?.remove();
    _overlay = null;
    _showNextComponentIfQueueIsNotEmpty();
  }

  /// Show next component if the [_componentQueue] is not empty.
  void _showNextComponentIfQueueIsNotEmpty() {
    if (_isComponentQueueNotEmpty) {
      _showNextComponentImmediately();
    }
  }

  /// Closes the component from the screen and clears the [_componentQueue].
  void closeAllComponent() {
    _queuedCheckTimer?.cancel();
    _overlay?.remove();
    _overlay = null;
    _componentQueue.clear();
  }

  /// Clears the [_componentQueue].
  void clearComponentQueue() => _componentQueue.clear();
}
