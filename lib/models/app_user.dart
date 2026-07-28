class AppUser {
  final String id;
  final String username;
  final String bio;
  final String profilePicture;
  final String socialLink;
  final String location;
  final String joinedDate;
  final int followers;
  final int following;
  AppUser({
    required this.id,
    required this.username,
    required this.bio,
    required this.profilePicture,
    required this.socialLink,
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
      profilePicture: map['cover_url'] ?? '',
      socialLink: map['social_link'] ?? '',
      location: map['location'] ?? '',
      joinedDate: map['joined_date'] ?? '',
      followers: (map['followers'] as num?)?.toInt() ?? 0,
      following: (map['following'] as num?)?.toInt() ?? 0,
    );
  }
}
