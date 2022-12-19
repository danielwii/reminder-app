import 'dart:ui';

import 'package:asuna_flutter/asuna_flutter.dart';
import 'package:flutter_buffs/flutter_buffs.dart';

class UserKeys {
  static const collection = 'Users';
  static const fullname = 'fullname';
}

class UserModel {
  // final _firebaseAuth = FirebaseAuth.instance;
  // final _firestore = FirebaseFirestore.instance;

  /// Create Singleton factory for [UserModel]
  ///
  static final _userModel = UserModel._internal();
  factory UserModel() => _userModel;
  UserModel._internal();

  /// End

  // Future<CurrentUser?> get getCurrentUser => AuthFunc.instance.currentUser();

  /*
  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String userId) async {
    return await _firestore.collection(UserKeys.collection).doc(userId).get();
  }*/

  Future<void> authUserAccount({
    // Callback functions for route
    required VoidCallback toHomeScreen,
    required VoidCallback toSignInScreen,
    required VoidCallback toSignUpScreen,
    // required VoidCallback updateLocationScreen,
    // Optional functions called on app start
    VoidCallback? toBlockedScreen,
  }) async {
    final currentUser = await AuthFunc.ins.currentUser();

    /// Check user auth
    if (currentUser != null) {
      /// Get current user in database
      /// Check user account in database
      /// if exists check status and take action
      final String fullname = profileName(currentUser.profile);
      logger.finer(
          'user doc is ${currentUser.id}/$fullname/${currentUser.profile?.toJson()}');

      // Check location data:
      // Get User's latitude & longitude
      // final GeoPoint userGeoPoint = userDoc[USER_GEO_POINT]['geopoint'];
      // final double latitude = userGeoPoint.latitude;
      // final double longitude = userGeoPoint.longitude;

      /// Check User Account Status
      /*if (userDoc[USER_STATUS] == 'blocked') {
        // Go to blocked user account screen
        toBlockedScreen!();
      } else {
        // Update UserModel for current user
        updateUserObject(userDoc.data()!);

        // Update user device token and subscribe to fcm topic
        updateUserDeviceToken();

        /// re-sign in when no wallet address found
        if (walletAddress.trim().isEmpty) {
          signInScreen();
          return;
        }

        if (fullname.trim().isEmpty) {
          signUpScreen();
          return;
        }

        // Check location data
        */ /*if (latitude == 0.0 && longitude == 0.0) {
          // Show Update your current location message
          updateLocationScreen();
          return;
        }*/ /*

        // Go to home screen
        toHomeScreen();
      }*/
      // Debug
      logger.info('user exists');
      toHomeScreen();
    } else {
      logger.info('not logged in');
      toSignInScreen();
    }
  }
}
