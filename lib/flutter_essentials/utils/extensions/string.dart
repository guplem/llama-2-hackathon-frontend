extension StringNullableExtensions on String? {
  String? capitalizeFirstLetter({bool restOfStringToLowerCase = false}) {
    if (this == null) return null;
    if (this!.isEmpty) return "";
    String rest = restOfStringToLowerCase? this!.substring(1).toLowerCase() : this!.substring(1);
    return "${this![0].toUpperCase()}$rest";
  }

  String? trimAndSetNullIfEmpty() {
    String? result = this?.trim();
    if (result.isNullOrEmpty) return null;
    return result;
  }

  String getOnlyDigits() {
    return (this ?? "").replaceAll(RegExp(r"[^0-9]"), "");
  }

  int getOnlyDigitsAsInteger() {
    return int.parse(getOnlyDigits().trimAndSetNullIfEmpty() ?? "0");
  }

  bool get isNullOrEmpty {
    return this == null || this!.isEmpty || this == "";
  }

}