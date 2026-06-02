import 'package:flutter/material.dart';

import 'ac_scroll_view_controller.dart';
import 'ac_scroll_view_data_source.dart';

/// Bidirectional infinite list with lazy item loading.
///
/// Uses a [CustomScrollView] with two slivers (before and after),
/// managed via [ACScrollViewDataSource].
class ACScrollView<T> extends StatefulWidget {
  /// Creates a bidirectional list.
  const ACScrollView({
    required this.controller,
    required this.dataSource,
    required this.itemExtentBuilder,
    required this.itemBuilder,
    this.onVisibleItemChanged,
    this.padding,
    this.spacing = 0,
    this.physics,
    this.scrollDirection,
    super.key,
  });

  /// Scroll and navigation controller.
  final ACScrollViewController<T> controller;

  /// Data source: manages items, the index, and loading.
  final ACScrollViewDataSource<T> dataSource;

  /// Returns the item's height/width for computing the scroll offset.
  final double Function(T item) itemExtentBuilder;

  /// Builder for constructing the item widget.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Called when the current visible item changes.
  final void Function(T item)? onVisibleItemChanged;

  /// Inner padding of the list.
  final EdgeInsetsGeometry? padding;

  /// Spacing between list items.
  final double spacing;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Scroll direction. Defaults to [Axis.vertical].
  final Axis? scrollDirection;

  @override
  State<ACScrollView<T>> createState() => _ACScrollViewState();
}

class _ACScrollViewState<T> extends State<ACScrollView<T>> {
  final _centerKey = GlobalKey();

  Axis get _scrollDirection => widget.scrollDirection ?? Axis.vertical;
  bool get _isVertical => _scrollDirection == Axis.vertical;

  @override
  void initState() {
    super.initState();

    _attachDataSourceToController();

    widget.dataSource
      ..initialize(widget.dataSource.currentItem)
      ..addListener(_onDataSourceChanged);
  }

  @override
  void didUpdateWidget(ACScrollView<T> old) {
    super.didUpdateWidget(old);

    if (old.controller != widget.controller ||
        old.dataSource != widget.dataSource) {
      _attachDataSourceToController();
    }

    if (old.dataSource != widget.dataSource) {
      old.dataSource.removeListener(_onDataSourceChanged);
      widget.dataSource.addListener(_onDataSourceChanged);
    }
  }

  @override
  void dispose() {
    widget.dataSource.removeListener(_onDataSourceChanged);
    super.dispose();
  }

  void _attachDataSourceToController() => widget.controller.attachDataSource(
        widget.dataSource,
        itemExtentBuilder: widget.itemExtentBuilder,
        spacing: widget.spacing,
        onVisibleItemChanged: widget.onVisibleItemChanged,
      );

  void _onDataSourceChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Widget _buildItem(T item, {bool skipSpacing = false}) {
    final child = widget.itemBuilder(context, item);
    if (widget.spacing <= 0 || skipSpacing) return child;

    return Padding(
      padding: _isVertical
          ? EdgeInsets.only(bottom: widget.spacing)
          : EdgeInsetsDirectional.only(end: widget.spacing),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding =
        widget.padding?.resolve(Directionality.of(context)) ?? EdgeInsets.zero;

    final crossAxis = _isVertical
        ? EdgeInsets.only(left: padding.left, right: padding.right)
        : EdgeInsets.only(top: padding.top, bottom: padding.bottom);

    final beforePadding = crossAxis +
        (_isVertical
            ? EdgeInsets.only(top: padding.top)
            : EdgeInsets.only(left: padding.left));

    final afterPadding = crossAxis +
        (_isVertical
            ? EdgeInsets.only(bottom: padding.bottom)
            : EdgeInsets.only(right: padding.right));

    final beforeSliver = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= widget.dataSource.beforeItems.length) return null;
          final isLast = index == widget.dataSource.beforeItems.length - 1;
          return _buildItem(
            widget.dataSource.beforeItems[index],
            skipSpacing: isLast && widget.dataSource.reachedEndBefore,
          );
        },
        childCount: widget.dataSource.beforeItems.length,
      ),
    );

    final afterSliver = SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index >= widget.dataSource.afterItems.length) return null;
          final isLast = index == widget.dataSource.afterItems.length - 1;
          return _buildItem(
            widget.dataSource.afterItems[index],
            skipSpacing: isLast && widget.dataSource.reachedEndAfter,
          );
        },
        childCount: widget.dataSource.afterItems.length,
      ),
    );

    return CustomScrollView(
      physics: widget.physics,
      scrollDirection: _scrollDirection,
      controller: widget.controller,
      center: _centerKey,
      slivers: [
        SliverPadding(
          padding: beforePadding,
          sliver: beforeSliver,
        ),
        SliverPadding(
          key: _centerKey,
          padding: afterPadding,
          sliver: afterSliver,
        ),
      ],
    );
  }
}
