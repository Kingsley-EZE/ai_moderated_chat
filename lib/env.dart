import 'dart:io';
import 'package:path/path.dart' as path;

String loadApiKey() {
  final envFile = File(path.join(Directory.current.path, '.env'));
  if (!envFile.existsSync()) {
    throw Exception('.env file not found. Create it with API_KEY=...');
  }
  final lines = envFile.readAsLinesSync();
  for (var line in lines) {
    if (line.startsWith('API_KEY=')) {
      return line.substring(8).trim();
    }
  }
  throw Exception('API_KEY not found in .env');
}