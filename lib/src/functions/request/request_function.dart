import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/functions/global_function.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

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

  static Map<String, List<PersonModel>> generateGroup(BuildContext context) {
    final persons = context.read(personProvider.state);
    final generateTotalGroup = context.read(settingProvider.state).totalGenerateGroup;
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

  static Future<void> processGenerate(
    BuildContext context, {
    VoidCallback onCompleteGenerate,
  }) async {
    final persons = context.read(personProvider.state);
    if (persons.isEmpty) {
      await GlobalFunction.showToast(
          message: 'Anggota tidak boleh kosong', toastType: ToastType.Error);
      return null;
    }
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

  ///! Note [Maximum baris = 20, Jika lebih dari sini akan error]
  static Future<void> printPDF(Map<String, List<PersonModel>> generateResult) async {
    print(generateResult);
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("assets/fonts/body/Poppins-Medium.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("assets/fonts/body/Poppins-Regular.ttf")),
    );

    final pw.Document _pdf = pw.Document(theme: myTheme);

    _pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        build: (ctx) => <pw.Widget>[
          ...generateResult.entries.map((e) {
            final nameGroup = e.key;
            final persons = e.value;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  nameGroup,
                  style: pw.TextStyle(fontSize: 20.0),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    borderRadius: 15,
                    border: pw.BoxBorder(),
                  ),
                  child: persons.length > 15
                      ? pw.GridView(
                          crossAxisCount: 5,
                          children: persons
                              .map((e) => pw.Text(e.name, textAlign: pw.TextAlign.center))
                              .toList(),
                          padding: pw.EdgeInsets.all(20),
                          childAspectRatio: .5,
                        )
                      : pw.ListView.builder(
                          itemCount: persons.length,
                          itemBuilder: (context, index) {
                            final person = persons[index];
                            return pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 12.0),
                              child: pw.Column(
                                children: [
                                  pw.Row(
                                    children: [
                                      pw.Flexible(child: pw.Text('${index + 1}.')),
                                      pw.Flexible(
                                        fit: pw.FlexFit.tight,
                                        child: pw.Padding(
                                          padding: pw.EdgeInsets.symmetric(horizontal: 8.0),
                                          child: pw.Text(person.name, maxLines: 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  pw.SizedBox(height: 10),
                                  if ((index + 1) < persons.length) pw.Divider(thickness: 1),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                pw.SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
        footer: (context) {
          return pw.Text(
              '${GlobalFunction.formatYearMonthDay(DateTime.now())} | ${GlobalFunction.formatHoursMinutesSeconds(DateTime.now())}');
        },
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/kelompok-generator.pdf");
    await file.writeAsBytes(_pdf.save());
    print(file.path);
    await Share.shareFiles(
      [
        file.path,
      ],
      text: 'PDF generate kelompok',
      subject: 'Gunakan PDF ini sebaik mungkin ya...',
    );
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
