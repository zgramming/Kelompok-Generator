import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

class TextFormName extends StatelessWidget {
  const TextFormName({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.namePersonController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController namePersonController;

  @override
  Widget build(BuildContext context) {
    print('rebuild 2');
    return Positioned(
      child: Form(
        key: _formKey,
        child: TextFormFieldCustom(
          controller: namePersonController,
          disableOutlineBorder: false,
          hintText: 'Tambah nama anggota',
          labelText: 'Nama Anggota',
          validator: (value) {
            if (value.isEmpty) {
              return 'Nama anggota tidak boleh kosong';
            }
            return null;
          },
        ),
      ),
      bottom: 12.0,
      left: 12.0,
      right:
          sizes.isMobileLayout(context) ? sizes.width(context) * .2 : sizes.width(context) * .075,
    );
  }
}
