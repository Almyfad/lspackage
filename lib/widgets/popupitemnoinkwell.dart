import 'package:flutter/material.dart';

class PopupItemNoInkWell<T> extends PopupMenuEntry<T> {
  /// Creates an item for a popup menu.
  ///
  /// By default, the item is [enabled].
  ///
  /// The `enabled` and `height` arguments must not be null.
  const PopupItemNoInkWell({
    super.key,
    this.value,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
  });

  /// The value that will be returned by [showMenu] if this entry is selected.
  final T? value;

  /// Called when the menu item is tapped.

  /// Whether the user is permitted to select this item.
  ///
  /// Defaults to true. If this is false, then the item will not react to
  /// touches.
  final bool enabled;

  /// The minimum height of the menu item.
  ///
  /// Defaults to [kMinInteractiveDimension] pixels.
  @override
  final double height;

  /// The padding of the menu item.
  ///
  /// Note that [height] may interact with the applied padding. For example,
  /// If a [height] greater than the height of the sum of the padding and [child]
  /// is provided, then the padding's effect will not be visible.
  ///
  /// When null, the horizontal padding defaults to 16.0 on both sides.
  final EdgeInsets? padding;

  /// The text style of the popup menu item.
  ///
  /// If this property is null, then [PopupMenuThemeData.textStyle] is used.
  /// If [PopupMenuThemeData.textStyle] is also null, then [TextTheme.subtitle1]
  /// of [ThemeData.textTheme] is used.
  final TextStyle? textStyle;

  /// {@template flutter.material.popupmenu.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  /// {@endtemplate}
  ///
  /// If null, then the value of [PopupMenuThemeData.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  final MouseCursor? mouseCursor;


  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupDatetimeState<T, PopupItemNoInkWell<T>> createState() =>
      PopupDatetimeState<T, PopupItemNoInkWell<T>>();
}

class PopupDatetimeState<T, W extends PopupItemNoInkWell<T>> extends State<W> {

  @protected
  Widget? buildChild() => widget.child;


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style = widget.textStyle ??
        popupMenuTheme.textStyle ??
        theme.textTheme.subtitle1!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(enabled: widget.enabled, button: true, child: item),
    );
  }
}
