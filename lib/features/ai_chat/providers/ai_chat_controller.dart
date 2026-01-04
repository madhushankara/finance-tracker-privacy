import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatting/money_format.dart';
import '../../../data/models/money.dart';
import '../../settings/providers/settings_providers.dart';
import '../models/ai_chat_message.dart';

enum AiChatProcessingMode { onDevice, cloud }

final class AiChatConversation {
  const AiChatConversation({
    required this.id,
    required this.messages,
    required this.createdAt,
  });

  final int id;
  final List<AiChatMessage> messages;
  final DateTime createdAt;
}

final aiChatControllerProvider =
    StateNotifierProvider<AiChatController, AiChatState>(
      (ref) => AiChatController(ref),
    );

final class AiChatState {
  const AiChatState({
    required this.messages,
    required this.conversations,
    required this.activeConversationId,
    required this.processingMode,
    required this.nextId,
    required this.nextConversationId,
  });

  final List<AiChatMessage> messages;
  final List<AiChatConversation> conversations;
  final int? activeConversationId;
  final AiChatProcessingMode processingMode;
  final int nextId;
  final int nextConversationId;

  bool get isEmpty => messages.isEmpty;

  AiChatState copyWith({
    List<AiChatMessage>? messages,
    List<AiChatConversation>? conversations,
    int? activeConversationId,
    AiChatProcessingMode? processingMode,
    int? nextId,
    int? nextConversationId,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
      activeConversationId: activeConversationId ?? this.activeConversationId,
      processingMode: processingMode ?? this.processingMode,
      nextId: nextId ?? this.nextId,
      nextConversationId: nextConversationId ?? this.nextConversationId,
    );
  }

  static const AiChatState initial = AiChatState(
    messages: <AiChatMessage>[],
    conversations: <AiChatConversation>[],
    activeConversationId: null,
    processingMode: AiChatProcessingMode.onDevice,
    nextId: 1,
    nextConversationId: 1,
  );
}

final class AiChatController extends StateNotifier<AiChatState> {
  AiChatController(this.ref) : super(AiChatState.initial);

  final Ref ref;

  void setProcessingMode(AiChatProcessingMode mode) {
    state = state.copyWith(processingMode: mode);
  }

  /// Called when the full-page chat is opened.
  ///
  /// This starts a new conversation if the current one already has messages,
  /// enabling quick multi-chat history without needing a separate "new chat"
  /// button.
  void beginConversationForPageOpen() {
    if (state.messages.isEmpty && state.activeConversationId != null) return;

    // If we have messages but no conversation tracking (older state), materialize it.
    _materializeMissingConversationForCurrentMessagesIfNeeded();

    if (state.messages.isNotEmpty) {
      _startNewConversation();
      return;
    }

    // Ensure an active conversation exists.
    if (state.activeConversationId == null) {
      _startNewConversation();
    }
  }

  void selectConversation(int conversationId) {
    final conv = state.conversations
        .where((c) => c.id == conversationId)
        .firstOrNull;
    if (conv == null) return;
    state = state.copyWith(
      activeConversationId: conversationId,
      messages: conv.messages,
    );
  }

  void _materializeMissingConversationForCurrentMessagesIfNeeded() {
    if (state.messages.isEmpty) return;
    if (state.activeConversationId != null) return;
    if (state.conversations.isNotEmpty) return;

    final id = state.nextConversationId;
    final conv = AiChatConversation(
      id: id,
      messages: state.messages,
      createdAt: state.messages.first.createdAt,
    );

    state = state.copyWith(
      conversations: <AiChatConversation>[conv],
      activeConversationId: id,
      nextConversationId: id + 1,
    );
  }

  void _startNewConversation() {
    final id = state.nextConversationId;
    final conv = AiChatConversation(
      id: id,
      messages: const <AiChatMessage>[],
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      conversations: <AiChatConversation>[...state.conversations, conv],
      activeConversationId: id,
      messages: const <AiChatMessage>[],
      nextConversationId: id + 1,
    );
  }

  void _setActiveConversationMessages(List<AiChatMessage> newMessages) {
    final activeId = state.activeConversationId;
    if (activeId == null) {
      // If we somehow have no active conversation, create one and try again.
      _startNewConversation();
      return _setActiveConversationMessages(newMessages);
    }

    final updatedConversations = state.conversations
        .map(
          (c) => c.id == activeId
              ? AiChatConversation(
                  id: c.id,
                  messages: newMessages,
                  createdAt: c.createdAt,
                )
              : c,
        )
        .toList(growable: false);

    state = state.copyWith(
      messages: newMessages,
      conversations: updatedConversations,
    );
  }

  Future<void> send(String rawText) async {
    final text = rawText.trim();
    if (text.isEmpty) return;

    // Ensure we are writing into a conversation.
    if (state.activeConversationId == null) {
      _startNewConversation();
    }

    final now = DateTime.now();
    final userId = state.nextId;
    final typingId = userId + 1;

    final userMsg = AiChatMessage(
      id: userId,
      role: AiChatRole.user,
      text: text,
      createdAt: now,
    );

    final typingMsg = AiChatMessage(
      id: typingId,
      role: AiChatRole.assistant,
      text: '…',
      isTyping: true,
      createdAt: now,
    );

    _setActiveConversationMessages(<AiChatMessage>[
      ...state.messages,
      userMsg,
      typingMsg,
    ]);
    state = state.copyWith(nextId: typingId + 1);

    // Optional typing delay (1–2s).
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    final responseText = _mockResponse(text);

    final updated = state.messages
        .map(
          (m) => m.id == typingId
              ? m.copyWith(
                  text: responseText,
                  isTyping: false,
                  createdAt: DateTime.now(),
                )
              : m,
        )
        .toList(growable: false);

    _setActiveConversationMessages(updated);
  }

  String _mockResponse(String prompt) {
    final settings = ref.read(appSettingsProvider);
    final locale = null as String?;

    Money money(int minor) => Money(
      currencyCode: settings.primaryCurrencyCode,
      amountMinor: minor,
      scale: 2,
    );

    final p = prompt.toLowerCase();

    if (p.contains('how much') && p.contains('spend') && p.contains('month')) {
      final spent = formatMoney(
        money(124500),
        settings: settings,
        locale: locale,
      );
      final budget = formatMoney(
        money(180000),
        settings: settings,
        locale: locale,
      );
      final remaining = formatMoney(
        money(55500),
        settings: settings,
        locale: locale,
      );

      return 'This month so far, you’ve spent $spent.\n\n'
          'If your monthly target is around $budget, you still have about $remaining left.\n\n'
          'Tip: check your top 2 categories to find quick savings.';
    }

    if (p.contains('overspending') ||
        (p.contains('where') && p.contains('overspend'))) {
      return 'Based on your recent patterns, you may be overspending in:\n'
          '• Food delivery (↑ vs last month)\n'
          '• Subscriptions (multiple small charges)\n'
          '• Shopping (few larger purchases)\n\n'
          'Under development: category-by-category breakdown and alerts.';
    }

    if (p.contains('movies') && p.contains('month')) {
      final movies = formatMoney(
        money(28900),
        settings: settings,
        locale: locale,
      );
      return 'You spent about $movies on movies this month.\n\n'
          'Under development: I’ll soon be able to list the exact transactions.';
    }

    return 'I’m still under development.';
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
