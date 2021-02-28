import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/models/models.dart';

class PersonProvider extends StateNotifier<List<PersonModel>> {
  PersonProvider([List<PersonModel> state]) : super(state ?? []);

  void add(String name) {
    final person = PersonModel(id: DateTime.now().microsecondsSinceEpoch, name: name);
    state = [...state, person];
  }

  void update(PersonModel person) {
    state = [
      for (final existsPerson in state)
        if (existsPerson.id == person.id) person else existsPerson,
    ];
  }

  void delete(PersonModel person) {
    state = state.where((x) => x.id != person.id).toList();
  }

  void shuffle() {
    final tempList = <PersonModel>[...state]..shuffle();
    state = [...tempList];
  }

  void reGenerate(List<PersonModel> persons) {
    for (var person in persons) {
      add(person.name);
    }
  }
}

final personProvider = StateNotifierProvider((ref) => PersonProvider());

final personById = Provider.family.autoDispose<PersonModel, int>((ref, id) {
  final person = ref.watch(personProvider.state);

  final result = person.firstWhere(
    (element) => element.id == id,
    orElse: () => PersonModel(),
  );
  return result;
});
