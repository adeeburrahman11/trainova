class UserProfile {
  final String name;
  final int age;
  final double weight;
  final double height;
  final int weeklyGoalDays;
  final String? profilePhotoPath;

  UserProfile({
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
    required this.weeklyGoalDays,
    this.profilePhotoPath,
  });

  UserProfile copyWith({
    String? name,
    int? age,
    double? weight,
    double? height,
    int? weeklyGoalDays,
    String? profilePhotoPath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      weeklyGoalDays: weeklyGoalDays ?? this.weeklyGoalDays,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'weeklyGoalDays': weeklyGoalDays,
      'profilePhotoPath': profilePhotoPath,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String,
      age: json['age'] as int,
      weight: (json['weight'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      weeklyGoalDays: json['weeklyGoalDays'] as int,
      profilePhotoPath: json['profilePhotoPath'] as String?,
    );
  }
}
