part of nice_overlay;

/// The positions of [NiceToast] on the screen.
enum NiceToastPosition {
  top,
  bottom,
}

/// A widget that shows information about toast.
class NiceToast extends StatefulWidget implements NiceComponent {
  /// The message of [NiceToast].
  final Widget? message;

  /// Called when the [NiceToast] is tapped.
  final void Function()? onTap;

  /// Whether the phone vibrates when [NiceToast] shows;
  final bool vibrate;

  /// The duration of display [NiceToast] when queue is empty.
  final Duration displayDuration;

  /// The minimum duration of display [NiceToast] when queue is not empty.
  @override
  final Duration minimumDisplayDuration;

  /// The direction to dismiss [NiceToast].
  final DismissDirection dismissDirection;

  /// Whether [NiceToast] can be dismissed by drag.
  final bool isDismissible;

  /// The curve for the showing animation of [NiceToast].
  final Curve showingAnimationCurve;

  /// The animation duration of showing [NiceToast].
  @override
  final Duration showingAnimationDuration;

  /// The animation duration of closing [NiceToast].
  final Curve closingAnimationCurve;

  /// The animation duration of closing [NiceToast].
  final Duration closingAnimationDuration;

  /// The background color of [NiceToast].
  final Color backgroundColor;

  /// The box shadows of [NiceToast].
  final List<BoxShadow> boxShadows;

  /// The border radius of [NiceToast].
  final BorderRadius borderRadius;

  /// The padding of [NiceToast].
  final EdgeInsets padding;

  /// The margin of [NiceToast].
  final EdgeInsets margin;

  /// The position of [NiceToast] on the screen.
  final NiceToastPosition niceToastPosition;

  const NiceToast({
    Key? key,
    this.message,
    this.onTap,
    this.vibrate = true,
    this.displayDuration = const Duration(seconds: 2, milliseconds: 500),
    this.minimumDisplayDuration = const Duration(seconds: 1),
    this.dismissDirection = DismissDirection.up,
    this.isDismissible = true,
    this.showingAnimationCurve = Curves.fastOutSlowIn,
    this.showingAnimationDuration = const Duration(milliseconds: 300),
    this.closingAnimationCurve = Curves.fastOutSlowIn,
    this.closingAnimationDuration = const Duration(milliseconds: 300),
    this.backgroundColor = const Color(0xffebebeb),
    this.boxShadows = const [],
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.margin = const EdgeInsets.all(10),
    this.niceToastPosition = NiceToastPosition.bottom,
  })  : assert(displayDuration >= minimumDisplayDuration,
            'displayDuration should be equal to or longer than minimumDisplayDuration.'),
        super(key: key);

  @override
  NiceToastState createState() => NiceToastState();
}

class NiceToastState extends State<NiceToast>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<Offset> _animation;
  Timer? _timer;

  void show() {
    _animationController?.forward();
  }

  void close({bool immediately = false}) async {
    _timer?.cancel();
    if (!immediately) {
      await _animationController?.reverse();
    }
    NiceOverlay.closeToast();
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
      begin: Offset(
        0,
        widget.niceToastPosition == NiceToastPosition.bottom ? 1 : -1,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: widget.showingAnimationCurve,
        reverseCurve: widget.closingAnimationCurve,
      ),
    );

    show();

    if (widget.vibrate) {
      HapticFeedback.vibrate();
    }

    _timer = Timer(
      widget.showingAnimationDuration + widget.displayDuration,
      close,
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
        bottom: widget.margin.bottom + MediaQuery.of(context).padding.bottom,
      );

  DismissDirection get _dismissDirection =>
      widget.isDismissible ? widget.dismissDirection : DismissDirection.none;

  Widget get _content => widget.message ?? const SizedBox();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.niceToastPosition == NiceToastPosition.bottom
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      child: SlideTransition(
        position: _animation,
        child: Padding(
          padding: _margin,
          child: Dismissible(
            key: UniqueKey(),
            direction: _dismissDirection,
            onDismissed: (_) => close(immediately: true),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                  close(immediately: true);
                },
                child: Container(
                  padding: widget.padding,
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
