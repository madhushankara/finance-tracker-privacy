import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/pressable_scale.dart';
import 'models/ai_chat_message.dart';
import 'providers/ai_chat_controller.dart';

final class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

final class _AiChatPageState extends ConsumerState<AiChatPage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  bool _historyOpen = false;

  ProviderSubscription<AiChatState>? _chatSub;

  static const _suggestions = <String>[
    'How much did I spend this month?',
    'Where am I overspending?',
    'How much did I spend on movies this month?',
  ];

  @override
  void initState() {
    super.initState();

    // Start a fresh conversation whenever the full-page chat is opened,
    // while keeping prior conversations in memory for quick switching.
    ref.read(aiChatControllerProvider.notifier).beginConversationForPageOpen();

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
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final chat = ref.read(aiChatControllerProvider);
    if (chat.processingMode == AiChatProcessingMode.cloud) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Coming soon')));
      return;
    }
    await ref.read(aiChatControllerProvider.notifier).send(trimmed);
  }

  static String _conversationTitle(AiChatConversation c) {
    final firstUser = c.messages
        .where((m) => m.role == AiChatRole.user)
        .firstOrNull;
    final raw = (firstUser?.text ?? '').trim();
    if (raw.isEmpty) return 'Conversation';
    return raw.length <= 40 ? raw : '${raw.substring(0, 40)}…';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final chat = ref.watch(aiChatControllerProvider);

    final hasAnyMessages =
        chat.messages.isNotEmpty ||
        chat.conversations.any((c) => c.messages.isNotEmpty);
    final showWelcome = !hasAnyMessages;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Assistant'),
        actions: <Widget>[
          Tooltip(
            message: 'Process locally vs Cloud processing',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  chat.processingMode == AiChatProcessingMode.onDevice
                      ? 'Local'
                      : 'Cloud',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(width: AppSpacing.s8),
                Switch.adaptive(
                  value: chat.processingMode == AiChatProcessingMode.cloud,
                  onChanged: (v) {
                    ref
                        .read(aiChatControllerProvider.notifier)
                        .setProcessingMode(
                          v
                              ? AiChatProcessingMode.cloud
                              : AiChatProcessingMode.onDevice,
                        );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          IconButton(
            tooltip: _historyOpen ? 'Close history' : 'History',
            icon: Icon(_historyOpen ? Icons.close : Icons.menu),
            onPressed: () {
              setState(() => _historyOpen = !_historyOpen);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(height: 1),
              Expanded(
                child: showWelcome
                    ? _CenteredWelcomePrompts(
                        suggestions: _suggestions,
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
                              constraints: const BoxConstraints(maxWidth: 560),
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
                padding: EdgeInsets.only(
                  left: AppSpacing.s16,
                  right: AppSpacing.s16,
                  top: AppSpacing.s8,
                  bottom:
                      AppSpacing.s16 + MediaQuery.viewInsetsOf(context).bottom,
                ),
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
                        PressableScaleDecorator(
                          pressedScale: 0.97,
                          child: IconButton.filled(
                            tooltip: 'Send',
                            onPressed: () async {
                              final text = _inputController.text;
                              await _sendPrompt(text);
                              _inputController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_historyOpen) ...<Widget>[
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _historyOpen = false),
                child: ColoredBox(color: cs.scrim.withValues(alpha: 0.25)),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.78,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1, end: 0),
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  builder: (context, v, child) {
                    return Transform.translate(
                      offset: Offset(24 * v, 0),
                      child: child,
                    );
                  },
                  child: Material(
                    color: cs.surface,
                    child: SafeArea(
                      left: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.s16,
                              vertical: AppSpacing.s8,
                            ),
                            child: Text(
                              'Chat history',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const Divider(height: 1),
                          Expanded(
                            child: ListView.builder(
                              itemCount: chat.conversations.length,
                              itemBuilder: (context, index) {
                                final c = chat.conversations[index];
                                final title = _conversationTitle(c);
                                final isSelected =
                                    c.id == chat.activeConversationId;

                                return ListTile(
                                  title: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  selected: isSelected,
                                  onTap: () {
                                    ref
                                        .read(aiChatControllerProvider.notifier)
                                        .selectConversation(c.id);
                                    setState(() => _historyOpen = false);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}

final class _CenteredWelcomePrompts extends StatelessWidget {
  const _CenteredWelcomePrompts({
    required this.suggestions,
    required this.onTapSuggestion,
  });

  final List<String> suggestions;
  final Future<void> Function(String) onTapSuggestion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.25)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Try asking', style: theme.textTheme.titleSmall),
                  const SizedBox(height: AppSpacing.s8),
                  Wrap(
                    alignment: WrapAlignment.center,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
