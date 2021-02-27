import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../providers/providers.dart';

import './widgets/drawer_side.dart';
import './widgets/fab.dart';
import './widgets/header_title.dart';
import './widgets/list_person.dart';
import './widgets/text_form_name.dart';
import './widgets/generate_icon.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeNamed = '/welcome-screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GlobalKey<AnimatedListState> _animatedListKey;
  final _formKey = GlobalKey<FormState>();

  final namePersonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      _animatedListKey = GlobalKey<AnimatedListState>();

      context.read(globalContext).state = context;
      context.read(globalAnimatedListKey).state = _animatedListKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      drawer: SafeArea(
        child: DrawerSide(),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Kelompok Generator'),
        actions: [
          GenerateIcon(),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  WelcomeHeaderTitle(),
                  SizedBox(height: 5.0),
                  Expanded(
                    child: Consumer(
                      builder: (context, watch, child) {
                        final persons = watch(personProvider.state);
                        if (persons.isEmpty) {
                          return Center(
                            child: Text('Anggota kelompok masih kosong'),
                          );
                        }
                        return AnimatedList(
                          key: _animatedListKey,
                          initialItemCount: persons.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                            Animation<double> animation,
                          ) {
                            final person = persons[index];
                            final newIndex = index + 1;
                            return ListPerson(
                              newIndex: newIndex,
                              person: person,
                              animation: animation,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: sizes.statusBarHeight(context) * 2)
                ],
              ),
            ),
            TextFormName(
              formKey: _formKey,
              namePersonController: namePersonController,
            ),
          ],
        ),
      ),
      floatingActionButton: FAB(
        formKey: _formKey,
        namePersonController: namePersonController,
      ),
    );
  }
}
