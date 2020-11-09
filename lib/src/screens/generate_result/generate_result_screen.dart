import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kelompok_generator/src/providers/global/global_provider.dart';

import '../../network/models/models.dart';

import './widgets/generate_list_group.dart';
import './widgets/generate_fab.dart';

class GenerateResultScreen extends StatelessWidget {
  static const routeNamed = '/generate-result-screen';
  final Map<String, List<PersonModel>> generateResult;

  GenerateResultScreen({@required this.generateResult});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Preview Grup'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Consumer(
            builder: (context, watch, child) {
              final nameGroup = watch(globalNameGroup).state;
              return Text(
                nameGroup,
                style: appTheme.headline5(context).copyWith(
                      fontFamily: appConfig.headerFont,
                      fontWeight: FontWeight.w600,
                    ),
              );
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: generateResult
                      .map(
                        (group, persons) {
                          return MapEntry(
                            group,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  group,
                                  style: appTheme.headline6(context),
                                ),
                                SizedBox(height: 10),
                                GenerateListGroup(persons: persons),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      )
                      .values
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GenerateFAB(generateResult: generateResult),
    );
  }
}
