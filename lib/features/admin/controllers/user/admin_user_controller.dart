import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/constants/image_strings.dart';
import 'package:ezycart/utils/errors/error_handler.dart';
import 'package:ezycart/utils/popups/full_screen_loader.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUserController extends GetxController {
  static AdminUserController get instance => Get.find();

  final userRepository = UserRepository.instance;
  final RxList<UserModel> allUsers = <UserModel>[].obs;
  final RxList<UserModel> filteredUsers = <UserModel>[].obs;
  final isLoading = false.obs;
  final searchText = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  /// Fetch All Users
  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      final users = await userRepository.fetchAllUsers();
      allUsers.assignAll(users);
      filteredUsers.assignAll(users);
    } catch (e) {
      ErrorHandler.showError(error: e, title: 'Oh Snap!');
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter Users by Search Text
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.assignAll(allUsers);
    } else {
      filteredUsers.assignAll(
        allUsers.where((user) {
          return user.fullName.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  /// Update User Role/Details
  Future<void> updateUser(UserModel user) async {
    try {
      EFullScreenLoader.openLoadingDialog(
        'Updating User...',
        EImages.processingGear,
      );

      await userRepository.updateUserRecord(user);

      // Refresh list
      final index = allUsers.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        allUsers[index] = user;
        filterUsers(searchText.text);
      }

      EFullScreenLoader.stopLoading();
      ELoaders.successSnackBar(
        title: 'Success',
        message: 'User updated successfully',
      );
      Get.back();
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(error: e, title: 'Update Failed');
    }
  }

  /// Delete User from Firestore (Soft or Hard Delete logic depends on reqs, here Hard)
  Future<void> deleteUser(String userId) async {
    try {
      EFullScreenLoader.openLoadingDialog(
        'Deleting User...',
        EImages.processingGear,
      );

      await userRepository.deleteUserRecord(userId);

      allUsers.removeWhere((u) => u.id == userId);
      filterUsers(searchText.text);

      EFullScreenLoader.stopLoading();
      ELoaders.successSnackBar(
        title: 'Success',
        message: 'User deleted from database',
      );
    } catch (e) {
      EFullScreenLoader.stopLoading();
      ErrorHandler.showError(error: e, title: 'Delete Failed');
    }
  }
}
