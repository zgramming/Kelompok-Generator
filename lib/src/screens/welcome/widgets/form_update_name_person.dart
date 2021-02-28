import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kelompok_generator/src/providers/providers.dart';

class FormUpdateNamePerson extends StatelessWidget {
  final int id;

  FormUpdateNamePerson({
    Key key,
    @required this.id,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Update nama',
        style: GoogleFonts.montserrat(),
      ),
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (_, watch, __) {
              final person = watch(personById(id));
              return TextFormFieldCustom(
                controller: null,
                prefixIcon: null,
                initialValue: person.name,
                onFieldSubmitted: (value) {
                  print('heloo');
                  final form = _formKey.currentState.validate();
                  if (!form) {
                    return;
                  }
                  context.read(personProvider).update(person.copyWith(name: value));

                  Navigator.of(context).pop();
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Nama anggota tidak boleh kosong';
                  }
                  return null;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
