import 'package:flutter/cupertino.dart';

typedef SidebarXItemBuilder = Widget Function(
  bool selected,
  bool hovered,
);

class SidebarXItem {
  const SidebarXItem({
    this.label,
    this.icon,
    @Deprecated('Use iconBuilder instead') this.iconWidget,
    this.iconBuilder,
    this.onTap,
    this.onLongPress,
    this.onSecondaryTap,
    this.selectable = true,
    this.itemDecoration,
    this.gapHeight = 0.0, // Menambahkan parameter gapHeight
  }) : assert(
          (icon != null || iconBuilder != null || iconWidget != null),
          'You can create SidebarXItem with IconData? icon or with Widget? iconWidget',
        );

  final String? label;
  final IconData? icon;
  @Deprecated('Use iconBuilder instead')
  final Widget? iconWidget;
  final bool selectable;
  final Function()? onTap;
  final Function()? onLongPress;
  final Function()? onSecondaryTap;

  /// The `itemBuilder` callback used for setup custom icon for [SidebarXItem]
  final SidebarXItemBuilder? iconBuilder;
  
  final dynamic itemDecoration;
  
  // Menambahkan properti gapHeight untuk menentukan jarak antar item
  final double gapHeight;
}
