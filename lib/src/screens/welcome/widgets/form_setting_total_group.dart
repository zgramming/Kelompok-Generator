import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import '../../../providers/providers.dart';

class FormSettingTotalGroup extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Total kelompok',
        style: appTheme.headline6(context),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormFieldCustom(
            controller: null,
            prefixIcon: null,
            keyboardType: TextInputType.number,
            labelText: 'Total kelompok',
            hintText: 'Contoh : 5',
            inputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onFieldSubmitted: (value) async {
              final form = _formKey.currentState.validate();
              if (!form) {
                return;
              }
              await context.read(settingProvider).saveSettingTotalGroup(
                int.tryParse(value),
                generateTotal: (total) {
                  Navigator.of(context).pop();
                  GlobalFunction.showToast(
                    message: 'Total kelompok menjadi : $total',
                    toastType: ToastType.success,
                    isLongDuration: true,
                  );
                },
              );
            },
            validator: (value) {
              if (value.isEmpty) {
                return "Tidak boleh kosong";
              }
              if (int.tryParse(value) <= 0) {
                return "Total kelompok harus bilangan positif";
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
