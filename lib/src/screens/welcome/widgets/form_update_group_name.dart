import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../providers/providers.dart';

class FormUpdateGroupName extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Nama Kelompok',
        style: appTheme.headline6(context),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(
            8.0,
          ),
          child: TextFormFieldCustom(
            autoFocus: true,
            controller: null,
            prefixIcon: null,
            hintText: 'Kelompok Ceria',
            labelText: 'Nama Kelompok',
            onFieldSubmitted: (value) {
              final form = _formKey.currentState.validate();
              if (!form) {
                return;
              }
              context.read(globalNameGroup).state = value;

              Navigator.of(context).pop();
            },
            validator: (value) {
              if (value.isEmpty) {
                return 'Nama Kelompok tidak boleh kosong';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
