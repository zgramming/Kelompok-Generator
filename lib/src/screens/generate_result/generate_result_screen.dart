import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import 'package:kelompok_generator/src/functions/functions.dart';
import 'package:kelompok_generator/src/providers/providers.dart';

import '../../network/models/models.dart';

import './widgets/generate_list_group.dart';

class GenerateResultScreen extends StatelessWidget {
  static const routeNamed = '/generate-result-screen';

  final Map<String, List<PersonModel>> generateResult;

  GenerateResultScreen({
    @required this.generateResult,
  });
  @override
  Widget build(BuildContext context) {
    return ProviderListener<StateController<bool>>(
      provider: globalLoading,
      onChange: (context, isLoading) {
        if (isLoading.state) {
          GlobalFunction.showLoadingDialog(context);
        } else {
          Future.delayed(const Duration(milliseconds: 500), () => Navigator.of(context).pop());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Preview Grup'),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async => await FunctionRequest.sharedPDF(context, generateResult),
            ),
          ],
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
      ),
    );
  }
}
