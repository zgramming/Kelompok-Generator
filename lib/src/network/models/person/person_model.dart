class PersonModel {
  final int id;
  final String name;
  PersonModel({
    this.id,
    this.name,
  });

  PersonModel copyWith({
    int id,
    String name,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return PersonModel(
      id: json['id'],
      name: json['name'],
    );
  }

  @override
  String toString() => 'PersonModel(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is PersonModel && o.id == id && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
