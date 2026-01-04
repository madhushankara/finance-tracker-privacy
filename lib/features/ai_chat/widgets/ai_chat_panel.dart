import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../models/ai_chat_message.dart';
import '../providers/ai_chat_controller.dart';

final class AiChatPanel extends ConsumerStatefulWidget {
  const AiChatPanel({super.key});

  @override
  ConsumerState<AiChatPanel> createState() => _AiChatPanelState();
}

final class _AiChatPanelState extends ConsumerState<AiChatPanel> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  ProviderSubscription<AiChatState>? _chatSub;

  @override
  void initState() {
    super.initState();

    _chatSub = ref.listenManual(aiChatControllerProvider, (prev, next) {
      if (prev?.messages.length == next.messages.length) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (!_scrollController.hasClients) return;
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _chatSub?.close();
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendPrompt(String text) async {
    await ref.read(aiChatControllerProvider.notifier).send(text);
  }

  Future<void> _showProcessingInfo() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Processing modes'),
          content: const Text(
            'On-device: private, fast, limited (if supported).\n\n'
            'Cloud: powerful, needs internet (coming soon).',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chat = ref.watch(aiChatControllerProvider);

    final suggestions = const <String>[
      'How much did I spend this month?',
      'Where am I overspending?',
      'How much did I spend on movies this month?',
    ];

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Material(
          color: cs.surface,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s8,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Finance Assistant',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    GestureDetector(
                      onLongPress: _showProcessingInfo,
                      child: SegmentedButton<AiChatProcessingMode>(
                        segments: const <ButtonSegment<AiChatProcessingMode>>[
                          ButtonSegment(
                            value: AiChatProcessingMode.onDevice,
                            label: Text('On-device'),
                          ),
                          ButtonSegment(
                            value: AiChatProcessingMode.cloud,
                            label: Text('Cloud'),
                          ),
                        ],
                        selected: <AiChatProcessingMode>{chat.processingMode},
                        onSelectionChanged: (set) {
                          if (set.isEmpty) return;
                          ref
                              .read(aiChatControllerProvider.notifier)
                              .setProcessingMode(set.first);
                        },
                        showSelectedIcon: false,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: chat.messages.isEmpty
                    ? _EmptyChat(
                        suggestions: suggestions,
                        onTapSuggestion: (s) async {
                          _inputController.text = s;
                          _inputController.selection =
                              TextSelection.fromPosition(
                                TextPosition(offset: s.length),
                              );
                          _focusNode.requestFocus();
                          await _sendPrompt(s);
                          _inputController.clear();
                        },
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: AppSpacing.pagePadding,
                        itemCount: chat.messages.length,
                        itemBuilder: (context, i) {
                          final m = chat.messages[i];
                          final isUser = m.role == AiChatRole.user;

                          final bubbleColor = isUser
                              ? cs.primary
                              : cs.surfaceContainerHighest;
                          final textColor = isUser
                              ? cs.onPrimary
                              : cs.onSurface;
                          final align = isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft;

                          return Align(
                            alignment: align,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.s4,
                                ),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: bubbleColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.s8,
                                    ),
                                    child: m.isTyping
                                        ? SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: textColor.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            m.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(color: textColor),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            focusNode: _focusNode,
                            textInputAction: TextInputAction.send,
                            minLines: 1,
                            maxLines: 4,
                            onSubmitted: (v) async {
                              await _sendPrompt(v);
                              _inputController.clear();
                            },
                            decoration: const InputDecoration(
                              hintText: 'Ask a question…',
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s8),
                        IconButton.filled(
                          tooltip: 'Send',
                          onPressed: () async {
                            final text = _inputController.text;
                            await _sendPrompt(text);
                            _inputController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.suggestions, required this.onTapSuggestion});

  final List<String> suggestions;
  final Future<void> Function(String) onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.pagePadding,
      children: <Widget>[
        Text('Try asking', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.s8),
        Wrap(
          spacing: AppSpacing.s8,
          runSpacing: AppSpacing.s8,
          children: suggestions
              .map(
                (s) => ActionChip(
                  label: Text(s),
                  onPressed: () => onTapSuggestion(s),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(
          'This assistant is UI-only for now. Some requests may be under development.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
