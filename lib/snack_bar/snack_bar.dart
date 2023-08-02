part of nice_overlay;

/// The positions of [NiceSnackBar] on the screen.
enum NiceSnackBarPosition {
  top,
  bottom,
}

/// A widget that shows information about snack bar.
class NiceSnackBar extends StatefulWidget implements NiceComponent {
  /// The message of [NiceSnackBar].
  final Widget? message;

  /// An action that the user can take based on [NiceSnackBar].
  final Widget? action;

  /// Whether the phone vibrates when [NiceSnackBar] shows;
  final bool vibrate;

  /// The duration of display [NiceSnackBar] when queue is empty.
  final Duration displayDuration;

  /// The minimum duration of display [NiceSnackBar] when queue is not empty.
  @override
  final Duration minimumDisplayDuration;

  /// Whether [NiceSnackBar] can be dismissed by drag.
  final bool isDismissible;

  /// The curve for the showing animation of [NiceSnackBar].
  final Curve showingAnimationCurve;

  /// The animation duration of showing [NiceSnackBar].
  @override
  final Duration showingAnimationDuration;

  /// The animation duration of closing [NiceSnackBar].
  final Curve closingAnimationCurve;

  /// The animation duration of closing [NiceSnackBar].
  final Duration closingAnimationDuration;

  /// The background color of [NiceSnackBar].
  final Color backgroundColor;

  /// The box shadows of [NiceSnackBar].
  final List<BoxShadow> boxShadows;

  /// The border radius of [NiceSnackBar].
  final BorderRadius borderRadius;

  /// The padding of [NiceSnackBar].
  final EdgeInsets padding;

  /// The margin of [NiceSnackBar].
  final EdgeInsets margin;

  /// The position of [NiceSnackBar] on the screen.
  final NiceSnackBarPosition niceSnackBarPosition;

  /// Whether [NiceSnackBar] avoids safe area(operating system interfaces).
  final bool useSafeArea;

  const NiceSnackBar({
    Key? key,
    this.message,
    this.action,
    this.vibrate = true,
    this.displayDuration = const Duration(seconds: 2, milliseconds: 500),
    this.minimumDisplayDuration = const Duration(seconds: 1, milliseconds: 500),
    this.isDismissible = true,
    this.showingAnimationCurve = Curves.fastOutSlowIn,
    this.showingAnimationDuration = const Duration(milliseconds: 350),
    this.closingAnimationCurve = Curves.fastOutSlowIn,
    this.closingAnimationDuration = const Duration(milliseconds: 350),
    this.backgroundColor = const Color(0xffdcdcdc),
    this.boxShadows = const [],
    this.borderRadius = const BorderRadius.all(Radius.zero),
    this.padding = const EdgeInsets.all(20),
    EdgeInsets? margin,
    this.niceSnackBarPosition = NiceSnackBarPosition.bottom,
    this.useSafeArea = true,
  })  : assert(displayDuration >= minimumDisplayDuration,
            'displayDuration should be equal to or longer than minimumDisplayDuration.'),
        assert(!(useSafeArea && margin != null),
            'margin can not be used when useSafeArea is true'),
        margin = margin ?? EdgeInsets.zero,
        super(key: key);

  @override
  NiceSnackBarState createState() => NiceSnackBarState();
}

class NiceSnackBarState extends State<NiceSnackBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _animation;
  Timer? _timer;

  void show() {
    _animationController?.forward();
  }

  void close({bool immediately = false}) async {
    _timer?.cancel();
    if (!immediately) {
      await _animationController?.reverse();
    }
    NiceOverlay.closeSnackBar();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.showingAnimationDuration,
      reverseDuration: widget.closingAnimationDuration,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
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

  EdgeInsets get _padding => EdgeInsets.only(
        left: widget.padding.left,
        top: widget.padding.top +
            (widget.useSafeArea ||
                    widget.niceSnackBarPosition == NiceSnackBarPosition.bottom
                ? 0
                : MediaQuery.of(context).padding.top),
        right: widget.padding.right,
        bottom: widget.padding.bottom +
            (widget.useSafeArea ||
                    widget.niceSnackBarPosition == NiceSnackBarPosition.top
                ? 0
                : MediaQuery.of(context).padding.bottom),
      );

  EdgeInsets get _margin => EdgeInsets.only(
        left: widget.margin.left,
        top: widget.margin.top +
            (widget.useSafeArea ? MediaQuery.of(context).padding.top : 0),
        right: widget.margin.right,
        bottom: widget.margin.bottom +
            (widget.useSafeArea ? MediaQuery.of(context).padding.bottom : 0),
      );

  DismissDirection get _dismissDirection => widget.isDismissible
      ? (widget.niceSnackBarPosition == NiceSnackBarPosition.bottom
          ? DismissDirection.down
          : DismissDirection.up)
      : DismissDirection.none;

  Widget get _content => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: widget.message ?? const SizedBox(),
          ),
          widget.action ?? const SizedBox(),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.niceSnackBarPosition == NiceSnackBarPosition.bottom
          ? Alignment.bottomCenter
          : Alignment.topCenter,
      child: Padding(
        padding: _margin,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return ClipRect(
              child: Align(
                alignment:
                    widget.niceSnackBarPosition == NiceSnackBarPosition.bottom
                        ? AlignmentDirectional.topStart
                        : AlignmentDirectional.bottomStart,
                heightFactor: _animation.value,
                child: child,
              ),
            );
          },
          child: Dismissible(
            key: UniqueKey(),
            direction: _dismissDirection,
            onDismissed: (_) => close(immediately: true),
            child: Material(
              child: Container(
                padding: _padding,
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
    );
  }
}
