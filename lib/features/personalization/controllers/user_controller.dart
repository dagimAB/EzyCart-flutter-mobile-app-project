import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/data/repositories/user/user_repository.dart';
import 'package:ezycart/features/personalization/models/user_model.dart';
import 'package:ezycart/utils/popups/loaders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ezycart/services/cloudinary_service.dart';
import 'package:ezycart/utils/errors/error_handler.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  final imageUploading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDocument = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();

        if (userDocument.exists) {
          // 1. Get data from Firestore
          var dbUser = UserModel.fromSnapshot(userDocument);

          // 2. Fill in missing fields from Firebase Auth
          String email = dbUser.email.isNotEmpty
              ? dbUser.email
              : (currentUser.email ?? '');
          String phone = dbUser.phoneNumber.isNotEmpty
              ? dbUser.phoneNumber
              : (currentUser.phoneNumber ?? '');
          String pic = dbUser.profilePicture.isNotEmpty
              ? dbUser.profilePicture
              : (currentUser.photoURL ?? '');

          String first = dbUser.firstName;
          String last = dbUser.lastName;

          // Try to parse name from Auth if missing in DB
          if (first.isEmpty &&
              last.isEmpty &&
              currentUser.displayName != null &&
              currentUser.displayName!.isNotEmpty) {
            List<String> parts = currentUser.displayName!.split(' ');
            first = parts[0];
            if (parts.length > 1) last = parts.sublist(1).join(' ');
          }

          // 3. Update the observable user
          user.value = UserModel(
            id: dbUser.id,
            firstName: first,
            lastName: last,
            username: dbUser.username,
            email: email,
            phoneNumber: phone,
            profilePicture: pic,
            role: dbUser.role,
          );
        } else {
          user.value = UserModel.empty();
        }
      }
    } catch (e) {
      user.value = UserModel.empty();
    } finally {
      profileLoading.value = false;
    }
  }

  bool get isAdmin => user.value.role == 'Admin';

  /// Upload Profile Picture
  uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512,
      );
      if (image != null) {
        imageUploading.value = true;
        // Upload Image
        final userAuth = FirebaseAuth.instance.currentUser;
        if (userAuth == null) return;

        final ref = FirebaseStorage.instance.ref().child(
          'Users/Images/Profile/${userAuth.uid}.jpg',
        );

        final imageBytes = await image.readAsBytes();
        final uploadTask = ref.putData(
          imageBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );

        final snapshot = await uploadTask;
        final imageUrl = await snapshot.ref.getDownloadURL();

        // Update User Image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleField(json);

        // Update User Model
        user.value.profilePicture = imageUrl;
        user.refresh();

        ELoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your Profile Image has been updated!',
        );
      }
    } catch (e) {
      ErrorHandler.showError(
        error: e,
        title: 'Oh Snap!',
        fallbackMessage:
            'Failed to upload profile picture. Check your network and try again.',
      );
    } finally {
      imageUploading.value = false;
    }
  }

  /// Upload Profile Picture to Cloudinary (unsigned)
  Future<void> uploadUserProfilePictureToCloudinary() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 1024,
        maxWidth: 1024,
      );
      if (image == null) return;
      imageUploading.value = true;

      final imageUrl = await CloudinaryService.uploadImage(
        image.path,
        file: image,
      );

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception('Cloudinary upload failed.');
      }

      // Update User Image Record
      Map<String, dynamic> json = {'ProfilePicture': imageUrl};
      await userRepository.updateSingleField(json);

      // Update User Model
      user.value.profilePicture = imageUrl;
      user.refresh();

      ELoaders.successSnackBar(
        title: 'Congratulations',
        message: 'Your Profile Image has been updated!',
      );
    } catch (e) {
      ErrorHandler.showError(error: e, title: 'Oh Snap!');
    } finally {
      imageUploading.value = false;
    }
  }
}
