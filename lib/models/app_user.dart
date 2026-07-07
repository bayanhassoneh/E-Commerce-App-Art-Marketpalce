class AppUser {
  final String id;
  final String username;
  final String bio;
  final String profilePicture;
  final String location;
  final String joinedDate;
  final int followers;
  final int following;
  AppUser({
    required this.id,
    required this.username,
    required this.bio,
    required this.profilePicture,
    required this.location,
    required this.joinedDate,
    required this.followers,
    required this.following,
  });

  //turning database's map into class's object by using factory
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? '',
      username: map['user_name'] ?? 'undefined user',
      bio: map['bio'] ?? ' ',
      profilePicture: map['profile_picture'] ?? '',
      location: map['location'] ?? '',
      joinedDate: map['joined_date'] ?? '',
      followers: map['followers'] ?? '',
      following: map['following'] ?? '',
    );
  }
}
