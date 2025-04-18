import 'dacha_model.dart';

class ProfileModel {
  final String name;
  final String surname;
  final String phone;
  final List<DachaModel> dachas;

  ProfileModel({
    required this.name,
    required this.surname,
    required this.phone,
    required this.dachas,
  });

  // Десериализация из JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      phone: json['phone'] ?? '',
      dachas: json['dachas'] != null && json['dachas'] is List
          ? List<DachaModel>.from((json['dachas'] as List).map((x) {
              if (x is Map<String, dynamic>) {
                return DachaModel.fromJson(x);
              } else if (x is Map) {
                return DachaModel.fromJson(Map<String, dynamic>.from(x));
              } else {
                throw Exception("Invalid dacha format: $x");
              }
            }))
          : [],
    );
  }

  // Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'phone': phone,
      'dachas': dachas.map((d) => d.toJson()).toList(),
    };
  }
}
