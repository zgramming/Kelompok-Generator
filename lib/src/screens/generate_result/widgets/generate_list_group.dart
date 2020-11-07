import 'package:flutter/material.dart';
import 'package:global_template/global_template.dart';
import '../../../network/models/models.dart';

class GenerateListGroup extends StatelessWidget {
  const GenerateListGroup({@required this.persons});
  final List<PersonModel> persons;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorPallete.accentColor,
                  foregroundColor: colorPallete.white,
                  child: Text('${index + 1}'),
                ),
                title: Text(person.name),
              ),
              if ((index + 1 < persons.length)) Divider(thickness: 1),
            ],
          );
        },
      ),
    );
  }
}
