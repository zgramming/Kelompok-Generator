import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../functions/functions.dart';
import '../../../providers/providers.dart';

class FAB extends StatelessWidget {
  const FAB({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.namePersonController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController namePersonController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final keyAnimatedList = watch(globalAnimatedListKey).state;
        return FloatingActionButton(
          onPressed: () {
            return FunctionRequest.addPerson(
              context,
              formKey: _formKey,
              nameController: namePersonController,
              animatedListKey: keyAnimatedList,
            );
          },
          tooltip: 'Tambah anggota',
          child: Icon(Icons.add),
        );
      },
    );
  }
}
