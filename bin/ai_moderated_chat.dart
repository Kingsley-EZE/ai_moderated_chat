import 'dart:io';
import 'package:ai_moderated_chat/env.dart';
import 'package:ai_moderated_chat/moderation.dart';
import 'package:ai_moderated_chat/prompts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(List<String> arguments) async {
  print('Enter your prompt (or type "exit" to quit):');
  final userInput = stdin.readLineSync();

  if (userInput == null || userInput.trim().isEmpty || userInput == 'exit') {
    print('Goodbye!');
    return;
  }

  if (containsBannedWord(userInput)) {
    print('Your input violated the moderation policy.');
    return;
  }

  final apiKey = loadApiKey();
  final response = await http.post(
    Uri.parse('https://api.openai.com/v1/chat/completions'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        {'role': 'user', 'content': userInput}
      ],
      'temperature': 0.7
    }),
  );

  if (response.statusCode != 200) {
    print('API Error: ${response.statusCode}');
    print(response.body);
    return;
  }

  final data = jsonDecode(response.body);
  final aiResponse = data['choices'][0]['message']['content'] as String;

  if (containsBannedWord(aiResponse)) {
    final redacted = redactBannedWords(aiResponse);
    print('AI Response (moderated):');
    print(redacted);
  } else {
    print('AI Response:');
    print(aiResponse);
  }
}