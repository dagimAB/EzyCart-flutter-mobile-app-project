import 'package:ezycart/common/widgets/appbar/appbar.dart';
import 'package:ezycart/common/widgets/products/ratings/rating_indicator.dart';
import 'package:ezycart/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:ezycart/features/shop/screens/product_reviews/widgets/user_review_card.dart';
import 'package:ezycart/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EAppBar(title: Text('Reviews & Ratings'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ESizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ratings and reviews are verified and are from people who use the same type of device that you use."),
              const SizedBox(height: ESizes.spaceBtwItems),

              // Overall Product Ratings
              const EOverallProductRating(),
              const ERatingBarIndicator(rating: 3.5),
              Text("12,611", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: ESizes.spaceBtwSections),

              // User Reviews List
              const EUserReviewCard(),
              const EUserReviewCard(),
              const EUserReviewCard(),
              const EUserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}
