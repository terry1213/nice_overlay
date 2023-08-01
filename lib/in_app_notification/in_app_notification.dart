part of nice_overlay;

/// A widget that shows information about in-app notification.
class NiceInAppNotification extends StatefulWidget implements NiceComponent {
  /// The title of [NiceInAppNotification].
  final Widget? title;

  /// The body of [NiceInAppNotification].
  final Widget? body;

  /// Called when the [NiceInAppNotification] is tapped.
  final void Function()? onTap;

  /// A widget to display before the [NiceInAppNotification]'s [title] and [body].
  final Widget? leading;

  /// A widget to display after the [NiceInAppNotification]'s [title] and [body].
  final Widget? trailing;

  /// Whether the phone vibrates when [NiceInAppNotification] shows;
  final bool vibrate;

  /// The duration of display [NiceInAppNotification] when queue is empty.
  final Duration displayDuration;

  /// The minimum duration of display [NiceInAppNotification] when queue is not empty.
  @override
  final Duration minimumDisplayDuration;

  /// The direction to dismiss [NiceInAppNotification].
  final DismissDirection dismissDirection;

  /// Whether [NiceInAppNotification] can be dismissed by drag.
  final bool isDismissible;

  /// The curve for the showing animation of [NiceInAppNotification].
  final Curve showingAnimationCurve;

  /// The animation duration of showing [NiceInAppNotification].
  @override
  final Duration showingAnimationDuration;

  /// The animation duration of closing [NiceInAppNotification].
  final Curve closingAnimationCurve;

  /// The animation duration of closing [NiceInAppNotification].
  final Duration closingAnimationDuration;

  /// The background color of [NiceInAppNotification].
  final Color backgroundColor;

  /// The box shadows of [NiceInAppNotification].
  final List<BoxShadow> boxShadows;

  /// The border radius of [NiceInAppNotification].
  final BorderRadius borderRadius;

  /// The padding of [NiceInAppNotification].
  final EdgeInsets padding;

  /// The margin of [NiceInAppNotification].
  final EdgeInsets margin;

  const NiceInAppNotification({
    Key? key,
    this.title,
    this.body,
    this.onTap,
    this.vibrate = true,
    this.leading,
    this.trailing,
    this.displayDuration = const Duration(seconds: 4),
    this.minimumDisplayDuration = const Duration(seconds: 1, milliseconds: 500),
    this.dismissDirection = DismissDirection.up,
    this.isDismissible = true,
    this.showingAnimationCurve = Curves.fastOutSlowIn,
    this.showingAnimationDuration = const Duration(milliseconds: 500),
    this.closingAnimationCurve = Curves.fastOutSlowIn,
    this.closingAnimationDuration = const Duration(milliseconds: 500),
    this.backgroundColor = Colors.white,
    this.boxShadows = const [
      BoxShadow(
        color: Colors.grey,
        spreadRadius: 0,
        blurRadius: 5.0,
        offset: Offset(0, 5),
      ),
    ],
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding = const EdgeInsets.all(15),
    this.margin = const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
  })  : assert(displayDuration >= minimumDisplayDuration,
            'displayDuration should be equal to or longer than minimumDisplayDuration.'),
        super(key: key);

  @override
  NiceInAppNotificationState createState() => NiceInAppNotificationState();
}

class NiceInAppNotificationState extends State<NiceInAppNotification>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<Offset> _animation;
  Timer? _timer;

  void _show() {
    _animationController?.forward();
  }

  void _close({bool immediately = false}) async {
    _timer?.cancel();
    if (!immediately) {
      await _animationController?.reverse();
    }
    NiceOverlay.closeInAppNotification();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.showingAnimationDuration,
      reverseDuration: widget.closingAnimationDuration,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: widget.showingAnimationCurve,
        reverseCurve: widget.closingAnimationCurve,
      ),
    );

    _show();

    if (widget.vibrate) {
      HapticFeedback.vibrate();
    }

    _timer = Timer(
      widget.showingAnimationDuration + widget.displayDuration,
      _close,
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  EdgeInsets get _margin => EdgeInsets.only(
        left: widget.margin.left,
        top: widget.margin.top + MediaQuery.of(context).padding.top,
        right: widget.margin.right,
      );

  DismissDirection get _dismissDirection =>
      widget.isDismissible ? widget.dismissDirection : DismissDirection.none;

  Widget get _content => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.leading ?? const SizedBox(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.leading == null ? 0 : 5,
                right: widget.trailing == null ? 0 : 5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title ?? const SizedBox(),
                  SizedBox(
                      height:
                          widget.title == null || widget.body == null ? 0 : 5),
                  widget.body ?? const SizedBox(),
                ],
              ),
            ),
          ),
          widget.trailing ?? const SizedBox(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _animation,
        child: Padding(
          padding: _margin,
          child: Dismissible(
            key: UniqueKey(),
            direction: _dismissDirection,
            onDismissed: (_) => _close(immediately: true),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                  _close(immediately: true);
                },
                child: Container(
                  padding: widget.padding,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: widget.borderRadius,
                    boxShadow: widget.boxShadows,
                  ),
                  child: _content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
