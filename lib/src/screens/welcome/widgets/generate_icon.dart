import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../functions/functions.dart';
import '../../../providers/providers.dart';

import '../../generate_result/generate_result_screen.dart';

class GenerateIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProviderListener(
      provider: globalLoading,
      onChange: (context, loading) async {
        if (loading.state)
          await GlobalFunction.showDialogLoading(context);
        else
          Navigator.of(context).pop();
      },
      child: IconButton(
        icon: Icon(Icons.wifi_protected_setup_sharp),
        onPressed: () async {
          try {
            await FunctionRequest.processGenerate(
              context,
              onCompleteGenerate: () {
                final result = FunctionRequest.generateGroup(context);
                print(result);
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context).pushNamed(
                    GenerateResultScreen.routeNamed,
                    arguments: result,
                  );
                });
              },
            );
          } catch (e) {
            await GlobalFunction.showToast(
              message: e.toString(),
              toastType: ToastType.Error,
              isLongDuration: true,
            );
          }
        },
      ),
    );
  }
}
