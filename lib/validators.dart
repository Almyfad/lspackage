
class LSValidator {

  final List<Validators> validators;

  LSValidator(this.validators);
  String? validate<T>(String? pattern) {
    for (dynamic validator in validators) {
      if (validator.validate<T>(pattern) == false) {
        return validator.errorMessage;
      }
    }
    return null;
  }
}

class Validators {
  @Deprecated('Use Constructor instead')
  static String? validate<T>(T? pattern, Iterable<Validators> validators) {
    for (dynamic validator in validators) {
      if (validator.validate<T>(pattern) == false) {
        return validator.errorMessage;
      }
    }
    return null;
  }
}

class RequiredValidator extends Validators {
  String errorMessage;
  RequiredValidator({
    this.errorMessage = "Ce champ est obligatoire",
  });
  bool validate<T>(T? pattern) {
    switch (pattern.runtimeType) {
      case String:
        if (pattern == null) return false;
        if ((pattern as String).isNotEmpty) return true;
        break;
      default:
        return pattern != null;
    }
    return false;
  }
}

class DecimalValidator extends Validators {
  String errorMessage;
  DecimalValidator({
    this.errorMessage = "Ce champ doit etre un nombre",
  });

  bool validate<T>(T? pattern) {
    switch (pattern.runtimeType) {
      case String:
        if (pattern == null) return true;
        if ((pattern as String).isEmpty) return true;
        RegExp regExp = RegExp(
          r"^\d+(.\d+)*$",
          caseSensitive: false,
          multiLine: false,
        );

        if (regExp.hasMatch(pattern)) return true;
        break;
      default:
        throw ("${pattern.runtimeType} is not impletemented yet");
    }
    return false;
  }
}

class NumberValidator extends Validators {
  String errorMessage;
  int? length;
  NumberValidator({
    this.errorMessage = "Ce champ doit etre un nombre",
    this.length,
  });

  bool validate<T>(T? pattern) {
    switch (pattern.runtimeType) {
      case String:
        if (pattern == null) return true;
        if ((pattern as String).isEmpty) return true;
        RegExp regExp = RegExp(
          r"^\d+$",
          caseSensitive: false,
          multiLine: false,
        );
        if (regExp.hasMatch(pattern)) {
          return length == null ? true : pattern.length == length;
        }
        break;
      default:
        throw ("${pattern.runtimeType} is not impletemented yet");
    }
    return false;
  }
}

class EmailValidator extends Validators {
  String errorMessage;
  EmailValidator({
    this.errorMessage = "Ce champ doit etre un email valide",
  });

  bool validate<T>(T? pattern) {
    switch (pattern.runtimeType) {
      case String:
        if (pattern == null) return true;
        if ((pattern as String).isEmpty) return true;
        RegExp regExp = RegExp(
          r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$",
          caseSensitive: false,
          multiLine: false,
        );
        if (regExp.hasMatch(pattern)) return true;
        break;
      default:
        throw ("${pattern.runtimeType} is not impletemented yet");
    }
    return false;
  }
}

class DateTimeValidator extends Validators {
  String errorMessage;
  final DateTime? lessthen;
  final DateTime? greaterthen;
  DateTimeValidator({
    this.errorMessage = "la date est hors limite",
    this.lessthen,
    this.greaterthen,
  });
  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    if (pattern is DateTime) {
      if (lessthen != null && greaterthen != null) {
        return greaterthen!.isBefore(pattern) && lessthen!.isAfter(pattern);
      }

      if (greaterthen != null) {
        return pattern.isAfter(greaterthen!);
      }
      if (lessthen != null) {
        return pattern.isBefore(lessthen!);
      }
    }
    return false;
  }
}

class VariableValidator extends Validators {
  final String? errorMessage;
  final bool isValid;
  VariableValidator({
    this.errorMessage = "Champ invalide",
    required this.isValid,
  });

  bool validate<T>(T? pattern) {
    return isValid;
  }
}

class PasswordComplexityValidator extends Validators {
  String? errorMessage;
  final int? minimalNumber;
  final int? minimalSpecialCharater;
  final int? minimallength;
  final int? minimalUpperCase;
  final int? minimallowerCase;

  PasswordComplexityValidator({
    this.errorMessage = "Champ invalide",
    this.minimalNumber = 1,
    this.minimalSpecialCharater = 1,
    this.minimallength = 8,
    this.minimalUpperCase = 1,
    this.minimallowerCase = 1,
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return true;
    if ((pattern as String).isEmpty) return true;

    // minimallength verification
    if (pattern.length < minimallength!) {
      errorMessage =
          "Doit contenir au moins $minimallength caractère${minimallength! > 1 ? "s" : ""}";
      return false;
    }

    // Upercase verification
    String rgx = '^(.*?[A-Z]){$minimalUpperCase,}';
    if (pattern.contains(RegExp(rgx)) == false) {
      errorMessage =
          "Doit contenir au moins $minimalUpperCase majuscule${minimalUpperCase! > 1 ? "s" : ""}";
      return false;
    }

    // LowerCase verification
    rgx = '^(.*?[a-z]){$minimallowerCase,}';
    if (pattern.contains(RegExp(rgx)) == false) {
      errorMessage =
          "Doit contenir au moins $minimallowerCase miniscule${minimallowerCase! > 1 ? "s" : ""}";
      return false;
    }

    // minimalNumber verification
    rgx = '^(.*?[0-9]){$minimalNumber,}';
    if (pattern.contains(RegExp(rgx)) == false) {
      errorMessage =
          "Doit contenir au moins $minimalNumber chiffre${minimalNumber! > 1 ? "s" : ""}";
      return false;
    }

    // minimalSpecialCharater verification
    rgx = r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){" "$minimalSpecialCharater,}";
    if (pattern.contains(RegExp(rgx)) == false) {
      errorMessage =
          "Doit contenir au moins $minimalSpecialCharater caratères spéci${minimalSpecialCharater! > 1 ? "aux" : "al"}";
      return false;
    }

    return true;
  }
}

class CodePostalValidator extends Validators {
  String errorMessage;
  CodePostalValidator({
    this.errorMessage = "Le code postal n'est pas valide",
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    String input = pattern.toString().trim().replaceAll(RegExp(r'\D'), ''); // enlève tous les caractères non numériques et les espaces
    if (input.length != 5) return false; // un code postal valide doit avoir 5 chiffres
    return true;
  }
}

class SiretValidator extends Validators {
  String errorMessage;
  SiretValidator({
    this.errorMessage = "Le numéro SIRET n'est pas valide",
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    String input = pattern.toString().replaceAll(RegExp(r'\D'), ''); // enlève tous les caractères non numériques
    if (input.length != 14) return false; // un numéro SIRET valide doit avoir 14 chiffres
    int sum = 0;
    for (int i = 0; i < input.length; i++) {
      int digit = int.parse(input[i]);
      if (i % 2 == 0) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }
}

class SirenValidator extends Validators {
  String errorMessage;
  SirenValidator({
    this.errorMessage = "Le numéro SIREN n'est pas valide",
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    String input = pattern.toString().replaceAll(RegExp(r'\D'), ''); // enlève tous les caractères non numériques
    if (input.length != 9) return false; // un numéro SIREN valide doit avoir 9 chiffres
    int sum = 0;
    for (int i = 0; i < input.length; i++) {
      int digit = int.parse(input[i]);
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }
}

class CodeAPEValidator extends Validators {
  String errorMessage;
  CodeAPEValidator({
    this.errorMessage = "Le code APE n'est pas valide",
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    String input = pattern.toString().trim().toUpperCase();
    if (!RegExp(r'^[0-9]{2}\.?[0-9]{2}[A-Z]{1}$').hasMatch(input)) return false; // un code APE valide doit être composé d'une lettre suivie de 4 chiffres
    return true;
  }
}

class IDCCValidator extends Validators {
  String errorMessage;
  IDCCValidator({
    this.errorMessage = "Le code IDCC n'est pas valide",
  });

  bool validate<T>(T? pattern) {
    if (pattern == null) return false;
    String input = pattern.toString().trim().toUpperCase();
    if (!RegExp(r'^[0-9]{4}$').hasMatch(input)) return false; // un code APE valide doit être composé d'une lettre suivie de 4 chiffres
    return true;
  }
}
