import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/data/repositories/authentication/authentication_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore.
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on User ID.
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(Get.find<AuthenticationRepository>().authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to update a single field in user record.
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(Get.find<AuthenticationRepository>().authUser?.uid)
          .set(json, SetOptions(merge: true));
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Admin] Function to fetch all users.
  Future<List<UserModel>> fetchAllUsers() async {
    try {
      final snapshot = await _db.collection("Users").get();
      return snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Admin] Function to update any user record.
  Future<void> updateUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).update(user.toJson());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Admin] Function to delete user record from Firestore.
  /// Note: This does not delete the user from Firebase Auth (requires Admin SDK).
  Future<void> deleteUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
