import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChatApi {
  final String baseUrl;

  AiChatApi({required this.baseUrl});

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // adjust key if backend uses different field: Backend is returning {"bot": "AI response here"} - JS
        // return data["bot"] ?? "No response from AI";

        return data["response"] ??
               data["bot"] ??
               data["reply"] ??
               data["message"] ??
               "No response from AI";
        // The above is the future proof version backend changes won’t break app, 
        // it will try multiple common keys to find the AI response.

      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to connect to AI server: $e");
    }
  }
}