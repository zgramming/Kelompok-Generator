import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:global_template/global_template.dart';

import '../../../functions/functions.dart';
import '../../../network/models/models.dart';

class GenerateFAB extends StatelessWidget {
  const GenerateFAB({
    Key key,
    @required this.generateResult,
  }) : super(key: key);

  final Map<String, List<PersonModel>> generateResult;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      tooltip: 'Cetak Kelompok',
      animatedIcon: AnimatedIcons.menu_close,
      overlayColor: Colors.black45,
      children: [
        SpeedDialChild(
          child: Icon(Icons.picture_as_pdf),
          backgroundColor: colorPallete.red,
          foregroundColor: colorPallete.white,
          onTap: () async {
            try {
              await FunctionRequest.printPDF(
                context,
                generateResult: generateResult,
              );
            } catch (e) {
              await GlobalFunction.showToast(
                message: e.toString(),
                toastType: ToastType.error,
                isLongDuration: true,
              );
            }
          },
        ),
      ],
    );
  }
}
