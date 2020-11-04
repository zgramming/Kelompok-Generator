import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/functions/global_function.dart';
import 'package:kelompok_generator/main.dart';

import '../../network/models/models.dart';
import '../../providers/providers.dart';

class FunctionRequest {
  static Future<void> addPerson(
    BuildContext context, {
    @required GlobalKey<FormState> formKey,
    @required TextEditingController nameController,
    @required GlobalKey<AnimatedListState> animatedListKey,
  }) async {
    final form = formKey.currentState.validate();

    if (!form) {
      return;
    }
    context.read(personProvider).add(nameController.text);
    if (animatedListKey.currentState != null) {
      animatedListKey.currentState.insertItem(0, duration: Duration(seconds: 1));
    }
    nameController.clear();
  }

  static Future<void> deletePerson(
    BuildContext context, {
    @required PersonModel person,
    @required GlobalKey<AnimatedListState> animatedListKey,
    @required int index,
  }) async {
    final persons = context.read(personProvider.state);
    context.read(personProvider).delete(person);

    if (animatedListKey.currentState != null) {
      animatedListKey.currentState.removeItem(
        index,
        (ctx, animation) => ListPerson(
          /// For ordering number, [real index =0 || new index = index + 1]
          newIndex: index + 1,

          /// Person
          person: person,

          /// For logic end item dont have divider
          persons: persons,

          /// Animation
          animation: animation,
        ),
        duration: Duration(seconds: 1),
      );
    }
  }

  static Future<Map<String, List<PersonModel>>> generateGroup(
    BuildContext context, {
    int generateTotalGroup = 1,
  }) async {
    final persons = context.read(personProvider.state);
    if (persons.isEmpty) {
      await GlobalFunction.showToast(
        message: 'Anggota tidak boleh kosong',
        toastType: ToastType.Error,
      );
      return null;
    }
    var tempMap = <String, List<PersonModel>>{};
    var tempPersonList = <PersonModel>[];

    final totalPerson = persons.length;

    final totalPersonEveryGroup = totalPerson ~/ generateTotalGroup;

    var totalUnselectedPerson = totalPerson % generateTotalGroup;

    for (int i = 1; i <= generateTotalGroup; i++) {
      var totalPickedPerson = totalPersonEveryGroup;

      if (totalUnselectedPerson > 0) {
        totalUnselectedPerson--;
        totalPickedPerson++;
      }

      var nameGroup = "Group $i";
      var selectedPerson = persons
          .getRange(tempPersonList.length, tempPersonList.length + totalPickedPerson)
          .toList();

      tempMap[nameGroup] = selectedPerson;
      tempPersonList = [
        ...tempPersonList,
        ...selectedPerson,
      ];
    }

    return tempMap;
  }

  static void processGenerate(
    BuildContext context, {
    VoidCallback onCompleteGenerate,
  }) {
    context.read(globalLoading).state = true;
    final next5Second = DateTime.now().add(const Duration(seconds: 5));
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      final now = DateTime.now();
      if (now.isAfter(next5Second)) {
        timer.cancel();
        context.read(globalLoading).state = false;
        onCompleteGenerate();
      } else {
        context.read(personProvider).shuffle();
      }
    });
  }
}

///? Original Code generateGroup
/*

Map<String, List<Person>> generateGroup(
  List<Person> values, {
  int generateTotalGroup = 1,
}) {
  var tempMap = <String, List<Person>>{};
  var tempPersonList = <Person>[];

  final totalPerson = values.length; 

  final totalPersonEveryGroup = totalPerson ~/ generateTotalGroup; 
  
  var totalUnselectedPerson = totalPerson % generateTotalGroup; 

values.shuffle();
  for (int i = 1; i <= generateTotalGroup; i++) {
   var totalPickedPerson = totalPersonEveryGroup;
   
    if(totalUnselectedPerson > 0){
      totalUnselectedPerson--;
      totalPickedPerson++;
    }

    var nameGroup = "Group $i";
    var selectedPerson = values
        .getRange(tempPersonList.length,
            tempPersonList.length + totalPickedPerson)
        .toList();

    tempMap[nameGroup] = selectedPerson;
    tempPersonList = [
      ...tempPersonList,
      ...selectedPerson,
    ];
  }

  return tempMap;
}

*/
