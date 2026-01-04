import 'package:meta/meta.dart';

enum AiChatRole { user, assistant }

@immutable
final class AiChatMessage {
  const AiChatMessage({
    required this.id,
    required this.role,
    required this.text,
    this.isTyping = false,
    required this.createdAt,
  });

  final int id;
  final AiChatRole role;
  final String text;
  final bool isTyping;
  final DateTime createdAt;

  AiChatMessage copyWith({
    AiChatRole? role,
    String? text,
    bool? isTyping,
    DateTime? createdAt,
  }) {
    return AiChatMessage(
      id: id,
      role: role ?? this.role,
      text: text ?? this.text,
      isTyping: isTyping ?? this.isTyping,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
