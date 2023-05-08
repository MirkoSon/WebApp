class UserData {
  final String name;
  final String address;
  final String? profilePictureUrl;

  UserData({required this.name, required this.address, this.profilePictureUrl});

  // factory method to create UserData object from a map
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
    );
  }

  // method to convert UserData object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
