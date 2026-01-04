import 'package:flutter/material.dart';

import '../animations/motion.dart';

typedef ImplicitAnimatedListKey<T> = Object Function(T item);
typedef ImplicitAnimatedListItemBuilder<T> =
    Widget Function(BuildContext context, T item, Animation<double> animation);

/// Lightweight insert/remove animation for lists without explicit controllers.
///
/// Assumptions:
/// - No reordering animations are desired.
/// - Small, incremental diffs (insert/remove) are common; large diffs reset.
final class ImplicitAnimatedList<T> extends StatefulWidget {
  const ImplicitAnimatedList({
    super.key,
    required this.items,
    required this.itemKey,
    required this.itemBuilder,
    this.padding,
    this.physics,
    this.shrinkWrap = false,
  });

  final List<T> items;
  final ImplicitAnimatedListKey<T> itemKey;
  final ImplicitAnimatedListItemBuilder<T> itemBuilder;

  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  @override
  State<ImplicitAnimatedList<T>> createState() =>
      _ImplicitAnimatedListState<T>();
}

final class _ImplicitAnimatedListState<T>
    extends State<ImplicitAnimatedList<T>> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<T> _items = <T>[];

  Duration get _animDuration =>
      Motion.duration(context, const Duration(milliseconds: 180));

  @override
  void initState() {
    super.initState();
    _items = List<T>.of(widget.items);
  }

  @override
  void didUpdateWidget(covariant ImplicitAnimatedList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(oldItems: _items, newItems: widget.items);
  }

  void _resetTo(List<T> newItems) {
    setState(() {
      // AnimatedList keeps its own internal item count. When we need to do a
      // full reset (reorder/large diffs), remount it with a fresh key so the
      // count matches [_items].
      _listKey = GlobalKey<AnimatedListState>();
      _items = List<T>.of(newItems);
    });
  }

  void _sync({required List<T> oldItems, required List<T> newItems}) {
    if (identical(oldItems, newItems)) return;

    var didUpdateExisting = false;

    // If reduced motion is enabled, keep it deterministic and instant.
    if (Motion.reduceMotion(context)) {
      _resetTo(newItems);
      return;
    }

    final oldKeys = oldItems.map(widget.itemKey).toList(growable: false);
    final newKeys = newItems.map(widget.itemKey).toList(growable: false);

    // If this looks like a reorder (same keys, different order), reset (no reorder animations).
    if (oldKeys.length == newKeys.length) {
      final sameSet =
          oldKeys.toSet().length == newKeys.toSet().length &&
          oldKeys.toSet().containsAll(newKeys);
      final sameOrder = _listEquals(oldKeys, newKeys);
      if (sameSet && !sameOrder) {
        _resetTo(newItems);
        return;
      }
    }

    // If diff is large, reset to avoid jank.
    final maxLen = oldItems.length > newItems.length
        ? oldItems.length
        : newItems.length;
    if (maxLen > 0) {
      final delta = (oldItems.length - newItems.length).abs();
      if (delta > 12 || delta > (maxLen * 0.4)) {
        _resetTo(newItems);
        return;
      }
    }

    final newKeySet = newKeys.toSet();

    // 1) Removals (fade out).
    for (int i = _items.length - 1; i >= 0; i--) {
      final item = _items[i];
      final k = widget.itemKey(item);
      if (newKeySet.contains(k)) continue;

      _items.removeAt(i);
      _listKey.currentState?.removeItem(
        i,
        (context, animation) => _removeTransition(
          context,
          animation,
          child: widget.itemBuilder(context, item, animation),
        ),
        duration: _animDuration,
      );
    }

    // 2) Insertions (fade + subtle slide).
    final currentKeys = _items.map(widget.itemKey).toList(growable: false);
    for (int i = 0; i < newItems.length; i++) {
      final item = newItems[i];
      final k = widget.itemKey(item);

      if (currentKeys.contains(k)) {
        // Keep consistent content for existing keys.
        final existingIndex = currentKeys.indexOf(k);
        if (existingIndex >= 0) {
          _items[existingIndex] = item;
          didUpdateExisting = true;
        }
        continue;
      }

      final insertIndex = i.clamp(0, _items.length);
      _items.insert(insertIndex, item);
      currentKeys.insert(insertIndex, k);
      _listKey.currentState?.insertItem(insertIndex, duration: _animDuration);
    }

    // If lengths match but keys differ (edge case), fall back to reset.
    final finalKeys = _items.map(widget.itemKey).toList(growable: false);
    if (!_listEquals(finalKeys, newKeys)) {
      _resetTo(newItems);
      return;
    }

    // If items changed but keys stayed the same, we still need a rebuild so the
    // updated content is reflected.
    if (didUpdateExisting) {
      setState(() {});
    }
  }

  static bool _listEquals(List<Object> a, List<Object> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  Widget _insertTransition(
    BuildContext context,
    Animation<double> animation, {
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      ),
    );
  }

  Widget _removeTransition(
    BuildContext context,
    Animation<double> animation, {
    required Widget child,
  }) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );
    return SizeTransition(
      sizeFactor: curved,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1, end: 0).animate(curved),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: _items.length,
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index, animation) {
        final item = _items[index];
        return _insertTransition(
          context,
          animation,
          child: widget.itemBuilder(context, item, animation),
        );
      },
    );
  }
}
