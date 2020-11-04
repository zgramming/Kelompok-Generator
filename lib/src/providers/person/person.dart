import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';
import '../../network/models/models.dart';

class PersonProvider extends StateNotifier<List<PersonModel>> {
  PersonProvider([List<PersonModel> state]) : super(state ?? []);

  void add(String name) {
    final person = PersonModel(id: state.length + 1, name: name);
    final existsItem = GlobalFunction.isValueExistObject<PersonModel>(
      state,
      person,
      check: (x) => x.id == person.id,
    );
    if (existsItem != null) {
      state = [person, ...state];
    }
  }

  void update(PersonModel person) {
    state = [
      for (final existsPerson in state)
        if (existsPerson.id == person.id) person else existsPerson,
    ];
  }

  void delete(PersonModel person) {
    print(person);
    state = state.where((x) => x.id != person.id).toList();
  }

  void shuffle() {
    final tempList = <PersonModel>[...state]..shuffle();
    state = [...tempList];
  }
}

final personProvider = StateNotifierProvider((ref) => PersonProvider());
