import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../functions/functions.dart';
import '../../../network/models/models.dart';
import '../../../providers/providers.dart';

class ListPerson extends StatelessWidget {
  const ListPerson({
    Key key,
    @required this.newIndex,
    @required this.person,
    @required this.animation,
  }) : super(key: key);

  final int newIndex;
  final PersonModel person;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text("$newIndex"),
            ),
            title: Text(person.name),
            trailing: Consumer(
              builder: (context, watch, child) {
                final keyAnimatedList = watch(globalAnimatedListKey).state;
                return KeyboardVisibilityBuilder(
                  builder: (context, child, isKeyboardVisible) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: isKeyboardVisible
                          ? SizedBox()
                          : ActionCircleButton(
                              backgroundColor: colorPallete.red,
                              icon: Icons.delete,
                              foregroundColor: colorPallete.white,
                              radius: sizes.isMobileLayout(context)
                                  ? sizes.width(context) * .045
                                  : sizes.width(context) * .025,
                              onTap: () => FunctionRequest.deletePerson(
                                context,
                                animatedListKey: keyAnimatedList,
                                index: newIndex - 1,
                              ),
                            ),
                    );
                  },
                  child: child,
                );
              },
            ),
          ),
        ),
        Divider(color: colorPallete.accentColor),
      ],
    );
  }
}
