class PassValidarion{
bool contemLetrasUppercase(String input) {
    final regex = RegExp(r'[A-Z]');
    return regex.hasMatch(input);
  }

  bool contemLetrasLowercase(String input) {
    final regex = RegExp(r'[a-z]');
    return regex.hasMatch(input);
  }

  bool contemNumeros(String input) {
    final regex = RegExp(r'\d');
    return regex.hasMatch(input);
  }

  bool contemCaracteresEspeciais(String input) {
    final regex = RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?~\\-]');
    return regex.hasMatch(input);
  }

}