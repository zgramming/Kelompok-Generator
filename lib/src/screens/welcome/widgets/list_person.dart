import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import '../../../functions/functions.dart';
import '../../../network/models/models.dart';
import '../../../providers/providers.dart';
import 'form_update_name_person.dart';

class ListPerson extends StatelessWidget {
  const ListPerson({
    Key key,
    @required this.index,
    @required this.person,
    @required this.animation,
  }) : super(key: key);

  final int index;
  final PersonModel person;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ),
      ),
      child: Consumer(
        builder: (_, watch, __) {
          final animatedListKey = watch(globalAnimatedListKey).state;
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.delete_rounded,
                    color: colorPallete.white,
                  ),
                  Icon(
                    Icons.delete_rounded,
                    color: colorPallete.white,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              color: colorPallete.red,
            ),
            onDismissed: (direction) {
              FunctionRequest.deletePerson(
                context,
                animatedListKey: animatedListKey,
                index: index,
              );
            },
            child: ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => FormUpdateNamePerson(id: person.id),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              leading: Container(
                padding: const EdgeInsets.all(8),
                width: sizes.width(context) / 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorPallete.accentColor,
                  border: Border.all(color: colorPallete.accentColor),
                ),
                child: FittedBox(
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorPallete.white,
                    ),
                  ),
                ),
              ),
              title: Text(
                person.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              trailing: Container(
                width: 2.5,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorPallete.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
