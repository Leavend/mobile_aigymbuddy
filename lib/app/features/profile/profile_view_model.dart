import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../domain/entities/user_profile.dart';
import '../../../domain/usecases/upsert_user_profile.dart';
import '../../../domain/usecases/watch_user_profile.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required WatchUserProfile watchUserProfile,
    required UpsertUserProfile upsertUserProfile,
  })  : _watchUserProfile = watchUserProfile,
        _upsertUserProfile = upsertUserProfile {
    _subscription = _watchUserProfile().listen((profile) {
      _profile = profile;
      _isLoading = false;
      notifyListeners();
    });
  }

  final WatchUserProfile _watchUserProfile;
  final UpsertUserProfile _upsertUserProfile;

  StreamSubscription<UserProfile?>? _subscription;
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  Future<bool> saveProfile(UserProfile updated) async {
    _isSaving = true;
    _error = null;
    notifyListeners();
    try {
      await _upsertUserProfile(updated);
      return true;
    } catch (error, stackTrace) {
      debugPrint('Failed to update profile: $error\n$stackTrace');
      _error = 'Gagal memperbarui profil.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
