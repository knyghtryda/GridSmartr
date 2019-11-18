import 'package:flutter/widgets.dart';

class AnimatedCount extends ImplicitlyAnimatedWidget {
  AnimatedCount({
    Key key,
    @required this.count,
    @required Duration duration,
    this.style,
    Curve curve = Curves.linear,
  }) : super(duration: duration, curve: curve, key: key);

  final num count;
  final TextStyle style;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedCountState();
  }
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _intCount;
  Tween<double> _doubleCount;

  @override
  Widget build(BuildContext context) {
    return widget.count is int
        ? Text(
            _intCount.evaluate(animation).toString(),
            style: widget.style,
          )
        : Text(
            _doubleCount.evaluate(animation).toStringAsFixed(1),
            style: widget.style,
          );
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    if (widget.count is int) {
      _intCount = visitor(
        _intCount,
        widget.count,
        (dynamic value) => IntTween(begin: value),
      );
    } else {
      _doubleCount = visitor(
        _doubleCount,
        widget.count,
        (dynamic value) => Tween<double>(begin: value),
      );
    }
  }
}
