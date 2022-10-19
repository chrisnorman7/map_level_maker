import 'constants.dart';

/// Validate that [value] is a suitable dart function name.
String? validateFunctionName({
  required final String? value,
  final String? emptyMessage = 'You must supply a value',
  final String? invalidFunctionNameMessage = 'Invalid function name',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  }
  final code = 'const $value = 1;\n';
  try {
    codeFormatter.format(code);
  } on FormatException {
    return invalidFunctionNameMessage;
  }
  return null;
}

/// Ensure that [value] is not empty.
String? validateNonEmptyValue({
  required final String? value,
  final String emptyMessage = 'You must supply a value',
}) =>
    value == null || value.isEmpty ? emptyMessage : null;
