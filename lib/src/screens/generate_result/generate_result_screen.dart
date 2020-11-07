import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';

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
        title: Text('Preview kelompok'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...generateResult
                  .map(
                    (nameGroup, persons) {
                      return MapEntry(
                        nameGroup,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              nameGroup,
                              style: appTheme.headline4(context),
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
                  .toList()
            ],
          ),
        ),
      ),
      floatingActionButton: GenerateFAB(generateResult: generateResult),
    );
  }
}
