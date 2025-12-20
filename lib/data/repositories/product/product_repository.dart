import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezycart/features/shop/models/product_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  /// Firestore instance for database interactions.
  final _db = FirebaseFirestore.instance;

  /// Get limited featured products
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(4)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get all featured products
  Future<List<ProductModel>> getAllFeaturedProducts() async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Products by Category
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('CategoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get Products by Query
  Future<List<ProductModel>> getFavouriteProducts(
    List<String> productIds,
  ) async {
    if (productIds.isEmpty) return [];
    try {
      final List<ProductModel> products = [];
      // Split into chunks of 10 to avoid Firestore 'whereIn' limit
      for (var i = 0; i < productIds.length; i += 10) {
        final end = (i + 10 < productIds.length) ? i + 10 : productIds.length;
        final chunk = productIds.sublist(i, end);

        if (chunk.isEmpty) continue;

        final snapshot = await _db
            .collection('Products')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        products.addAll(
          snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList(),
        );
      }
      return products;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Get All Products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Search Products
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final snapshot = await _db
          .collection('Products')
          .where('Title', isGreaterThanOrEqualTo: query)
          .where('Title', isLessThan: '$query\uf8ff')
          .get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch (e) {
      throw e.message!;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
