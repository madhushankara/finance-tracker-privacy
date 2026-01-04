import 'package:flutter/material.dart';

import '../../../core/animations/motion.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/pressable_scale.dart';
import 'ai_chat_panel.dart';

final class AiChatEntryButton extends StatefulWidget {
  const AiChatEntryButton({super.key});

  @override
  State<AiChatEntryButton> createState() => _AiChatEntryButtonState();
}

final class _AiChatEntryButtonState extends State<AiChatEntryButton> {
  bool _shown = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _shown = true);
    });
  }

  Future<void> _openChat() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        return const SizedBox(height: 560, child: AiChatPanel());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final duration = Motion.duration(
      context,
      const Duration(milliseconds: 220),
    );

    final bottomPad = MediaQuery.paddingOf(context).bottom;
    // BottomAppBar height in _AppShell is 72.
    final bottom = 72.0 + bottomPad + AppSpacing.s16;

    return Positioned(
      left: AppSpacing.s16,
      bottom: bottom,
      child: AnimatedSlide(
        offset: _shown ? Offset.zero : const Offset(-0.1, 0.08),
        duration: duration,
        curve: Curves.easeOutCubic,
        child: AnimatedOpacity(
          opacity: _shown ? 1 : 0,
          duration: duration,
          curve: Curves.easeOut,
          child: PressableScaleDecorator.forButton(
            onPressed: () {
              _openChat();
            },
            child: FloatingActionButton(
              heroTag: 'ai_chat_fab',
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              onPressed: _openChat,
              child: const Icon(Icons.auto_awesome),
            ),
          ),
        ),
      ),
    );
  }
}
