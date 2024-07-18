bool isValidString(String input) {
  final invalidCharacters = RegExp(r'[/.]');
  return !invalidCharacters.hasMatch(input);
}