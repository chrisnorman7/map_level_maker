import 'package:dart_style/dart_style.dart';

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
  } on FormatterException {
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

/// Validate that [value] is a class name.
String? validateClassName({
  required final String? value,
  final String emptyMessage = 'You must provide a value',
  final String invalidClassNameMessage = 'Invalid class name',
}) {
  if (value == null || value.isEmpty) {
    return emptyMessage;
  }
  final code = 'class $value {\n/// Create an instance.\nconst $value();\n}\n';
  try {
    codeFormatter.format(code);
    return null;
  } on FormatterException {
    return invalidClassNameMessage;
  }
}
