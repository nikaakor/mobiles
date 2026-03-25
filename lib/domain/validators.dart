class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Введіть email';
    if (!value.contains('@')) return 'Email має містити @';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Введіть ім\'я';
    if (RegExp(r'[0-9]').hasMatch(value)) return 'Ім\'я не може містити цифри';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    if (value.length < 6) return 'Пароль має бути від 6 символів';
    return null;
  }
}