import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';

import '../../network/models/models.dart';
import '../../providers/providers.dart';
import '../../screens/welcome/widgets/list_person.dart';
import './pdf_layout/pdf_layout.dart';

class FunctionRequest {
  static const nameApplication = 'kelompok-generator';

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
    final persons = context.read(personProvider.state);
    final index = persons.length > 0 ? persons.length : 0;
    context.read(personProvider).add(nameController.text);

    if (animatedListKey.currentState != null) {
      animatedListKey.currentState.insertItem(
        index,
        duration: Duration(seconds: 1),
      );
    }
    nameController.clear();
  }

  static Future<void> deletePerson(
    BuildContext context, {
    @required GlobalKey<AnimatedListState> animatedListKey,
    @required int index,
  }) async {
    final persons = context.read(personProvider.state);
    final removedItem = persons.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (ctx, animation) {
      return ListPerson(
        animation: animation,
        newIndex: index + 1,
        person: removedItem,
      );
    };

    context.read(personProvider).delete(removedItem);
    animatedListKey.currentState.removeItem(index, builder);
  }

  static Map<String, List<PersonModel>> generateGroup(BuildContext context) {
    final persons = context.read(personProvider.state);
    final generateTotalGroup = context.read(settingProvider.state).totalGenerateGroup;

    final tempMap = <String, List<PersonModel>>{};
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
    final settingTotalGenerateGroup = context.read(settingProvider.state);

    if (persons.isEmpty) {
      throw 'Anggota tidak boleh kosong';
    }
    if (settingTotalGenerateGroup.totalGenerateGroup > persons.length) {
      throw 'Settingan total kelompok lebih dari total anggota';
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

  static Future<void> printPDF(
    BuildContext context, {
    @required Map<String, List<PersonModel>> generateResult,
  }) async {
    print(generateResult);
    final now = DateTime.now();
    try {
      var myTheme = pw.ThemeData.withFont(
        base: pw.Font.ttf(await rootBundle.load("assets/fonts/body/Poppins-Medium.ttf")),
        bold: pw.Font.ttf(await rootBundle.load("assets/fonts/body/Poppins-Regular.ttf")),
      );

      final pw.Document _pdf = pw.Document(theme: myTheme);

      final logo = PdfImage.file(
        _pdf.document,
        bytes: (await rootBundle.load(
          "${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}",
        ))
            .buffer
            .asUint8List(),
      );

      _pdf.addPage(
        pw.MultiPage(
          header: (context) => PDFHeader(logo: logo),
          footer: (context) => PDFFooter(),
          build: (ctx) => generateResult.entries.map((e) {
            final nameGroup = e.key;
            final persons = e.value;
            return pw.Wrap(
              children: [
                pw.Header(
                  child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text(nameGroup, style: pw.Theme.of(ctx).header0),
                    pw.Text('Total anggota : ${persons.length}'),
                  ]),
                ),
                for (int i = 0; i < persons.length; i++)
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 20,
                            height: 20,
                            margin: const pw.EdgeInsets.all(4.0),
                            decoration: pw.BoxDecoration(
                              shape: pw.BoxShape.circle,
                              color: PdfColor.fromInt(0xFFAE355B),
                            ),
                            child: pw.FittedBox(
                              child: pw.Padding(
                                padding: const pw.EdgeInsets.all(8.0),
                                child: pw.Text(
                                  '${i + 1}',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromInt(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          pw.Text('${persons[i].name}')
                        ],
                      ),
                      pw.Divider(thickness: .25),
                    ],
                  )
              ],
            );
          }).toList(),
        ),
      );
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/$nameApplication-${now.microsecondsSinceEpoch}.pdf");
      await file.writeAsBytes(_pdf.save());
      print(file.path);
      await Share.shareFiles(
        [
          file.path,
        ],
        text: 'PDF generate kelompok',
        subject: '''

                Tanggal pembuatan : 
                ${GlobalFunction.formatYearMonthDaySpecific(now)} 
                ${GlobalFunction.formatHoursMinutesSeconds(now)}
              
                ''',
      ).whenComplete(
        () async {
          print('start save history');

          /// Get global name group
          final nameGroup = context.read(globalNameGroup).state;

          /// Encoded list person
          final persons = context.read(personProvider.state);
          final encodedPersons = json.encode(persons);

          /// Convert File PDF to base64
          final bytesPDF = await file.readAsBytes();
          final base64PDF = base64Encode(bytesPDF);

          final history = HiveHistoryModel()
            ..nameGroup = nameGroup
            ..base64PDF = base64PDF
            ..encodedPersons = encodedPersons
            ..createdAt = now;

          await context.read(historyProvider).add(history);
          print('end save history');
        },
      );
    } catch (e) {
      throw e;
    }
  }

  static Future<void> printHistoryPDF(HiveHistoryModel history) async {
    try {
      final tempFolder = await getTemporaryDirectory();
      final now = DateTime.now();

      final base64ToUint8List = base64Decode(history.base64PDF);

      final filePDF = await File(
              '${tempFolder.path}/kelompok-generator-${history.createdAt.microsecondsSinceEpoch}.pdf')
          .create();
      await filePDF.writeAsBytes(base64ToUint8List);
      print(filePDF.path);
      await Share.shareFiles(
        [
          filePDF.path,
        ],
        text: 'PDF generate kelompok',
        subject: '''
                Tanggal pembuatan : 
                ${GlobalFunction.formatYearMonthDaySpecific(now)} 
                ${GlobalFunction.formatHoursMinutesSeconds(now)}
              ''',
      );
    } catch (e) {
      throw e;
    }
  }

  static Future<String> previewPDF(HiveHistoryModel history) async {
    try {
      final tempFolder = await getTemporaryDirectory();
      final path =
          '${tempFolder.path}/kelompok-generator-${history.createdAt.microsecondsSinceEpoch}.pdf';
      final pdfExists = await File(path).exists();

      if (!pdfExists) {
        print('masuk sini ga? ');
        final base64ToUint8List = base64Decode(history.base64PDF);
        final filePDF = await File(path).create();
        await filePDF.writeAsBytes(base64ToUint8List);
      }

      return path;
    } catch (e) {
      throw e;
    }
  }

  static void reGenerate(
    BuildContext context, {
    @required HiveHistoryModel history,
    @required VoidCallback onCompeleted,
  }) {
    /// Get current list person
    final persons = context.read(personProvider.state);

    /// decoded list person
    final List decodedPersons = json.decode(history.encodedPersons);

    /// mapping result decoded list person
    final result = decodedPersons.map((e) => PersonModel.fromJson(e)).toList();

    context.read(personProvider).reGenerate(result);

    final animatedListKey = context.read(globalAnimatedListKey).state;

    for (var i = 0; i < result.length; i++) {
      final indexPerson = persons.length > 0 ? persons.length : 0;
      if (animatedListKey.currentState != null) {
        animatedListKey.currentState.insertItem(indexPerson);
      }
    }
    onCompeleted();
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
