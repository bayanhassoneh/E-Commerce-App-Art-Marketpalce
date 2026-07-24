import 'dart:async';
import 'package:flutter/material.dart';
import 'package:art_marketplace/services/profile_service.dart';
import 'package:art_marketplace/models/app_user.dart';
import 'package:art_marketplace/models/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:art_marketplace/services/follow_service.dart';
//import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _profileService = ProfileService();
  final FollowService _followService = FollowService();
  SupabaseClient supabase = Supabase.instance.client;
  bool isLoading = false;
  List<Post> artworks = [];
  // void pickImage() {}
  AppUser? profile;
  int followersCount = 0;
  int followingCount = 0;
  bool isFollowing = false;
  Future<void> fetchUserProfile(String profileUserId) async {
    profile = await _profileService.fetchUserProfile(
      profileUserId: profileUserId,
    );
    notifyListeners();
  }

  Future<void> fetchUserArtworks(String profileUserId) async {
    artworks = await _profileService.fetchUserArtworks(
      profileUserId: profileUserId,
    );
    notifyListeners();
  }

  Future<void> refresh(String profileUserId) async {
    isLoading = true;
    notifyListeners();

    await fetchUserProfile(profileUserId);
    await fetchUserArtworks(profileUserId);
    await fetchFollowCount(profileUserId);
    await checkFollowing(profileUserId);
    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFollow(String profileUserId) async {
    final currentUserId = supabase.auth.currentUser!.id;

    await _followService.followUser(currentUserId, profileUserId);
    notifyListeners();
    await fetchFollowCount(profileUserId);
    isFollowing = true;
  }

  Future<void> fetchFollowCount(String profileUserId) async {
    followersCount = await _followService.getFollowersCount(profileUserId);
    followingCount = await _followService.getFollowingCount(profileUserId);
    notifyListeners();
  }

  Future<void> unfollow(String profileUserId) async {
    await _followService.unfollow(profileUserId);
    isFollowing = false;
    await fetchFollowCount(profileUserId);
    notifyListeners();
  }

  Future<void> checkFollowing(String profileUserId) async {
    isFollowing = await _followService.checkFollowing(profileUserId);

    notifyListeners();
  }
}
