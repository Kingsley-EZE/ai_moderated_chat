const List<String> bannedKeywords = ['kill', 'hack', 'bomb', 'murder', 'explosive'];

bool containsBannedWord(String text) {
  final lower = text.toLowerCase();
  return bannedKeywords.any((word) => lower.contains(word));
}

String redactBannedWords(String text) {
  var result = text;
  for (final word in bannedKeywords) {
    final regex = RegExp(word, caseSensitive: false);
    result = result.replaceAll(regex, '[REDACTED]');
  }
  return result;
}