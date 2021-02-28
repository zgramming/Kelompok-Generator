import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../providers/providers.dart';
import 'form_update_group_name.dart';

class WelcomeHeaderTitle extends StatelessWidget {
  const WelcomeHeaderTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => FormUpdateGroupName(),
              );
            },
            child: Consumer(
              builder: (context, watch, child) {
                final nameGroup = watch(globalNameGroup).state;
                return Text(
                  nameGroup,
                  maxLines: 1,
                  style: appTheme.subtitle1(context).copyWith(
                        color: colorPallete.blue,
                        fontWeight: FontWeight.bold,
                      ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final totalPersons = watch(personProvider.state).length;
                return Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    radius: sizes.isMobileLayout(context)
                        ? sizes.width(context) * .04
                        : sizes.width(context) * .02,
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$totalPersons',
                          style: appTheme.headline6(context).copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorPallete.white,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
