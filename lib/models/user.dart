class AppUser {
  final String name;
  final String email;
  final String phone;

  const AppUser({required this.name, required this.email, this.phone = ''});

  AppUser copyWith({String? name, String? email, String? phone}) => AppUser(
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
      );
}
