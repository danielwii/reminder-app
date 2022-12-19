import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_use/flutter_use.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum ReminderFormNames {
  name,
  description,
  date,
  time,
}

class FormFields {
  static Widget text(
    WidgetRef ref, {
    required String name,
    String? title,
    int maxLines = 3,
    int? maxLength,
    required GlobalKey<FormBuilderState> formKey,
    required MapAction<String, bool?> formErrors,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
  }) {
    return FormBuilderTextField(
      autofocus: true,
      name: name,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: title ?? '名称',
        suffixIcon: formErrors.get(name) == null
            ? null
            : formErrors.get(name)!
                ? const Icon(Icons.error, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
      ),
      onChanged: (val) => formErrors.add(
          name, !(formKey.currentState?.fields[name]?.validate() ?? false)),
      valueTransformer: (text) => text?.trim(),
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
