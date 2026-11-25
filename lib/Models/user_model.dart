class UserModel {
  final String id;
  final String name;
  final String email;
  final String photoUrl;
  final String status;
  final double storageLimit;
  final double freeStorage;
  final bool isProUser;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl = '',
    this.status = 'active',
    this.storageLimit = 512,
    this.freeStorage = 0,
    this.isProUser = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      photoUrl: (json['photoUrl'] ?? '').toString(),
      status: (json['status'] ?? 'active').toString(),
      storageLimit: (json['storageLimit'] is num)
          ? (json['storageLimit'] as num).toDouble()
          : 512.0,
      freeStorage: (json['freeStorage'] is num)
          ? (json['freeStorage'] as num).toDouble()
          : 0.0,
      isProUser: json['isProUser'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'status': status,
      'storageLimit': storageLimit,
      'freeStorage': freeStorage,
      'isProUser': isProUser,
    };
  }
}
