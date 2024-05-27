import 'package:moli_manager/bloc/mysalon/my_salon_bloc.dart';
import 'package:moli_manager/bloc/review/review_bloc.dart';
import 'package:moli_manager/model/review/salon_review.dart' as salon_review;
import 'package:moli_manager/model/user/salon.dart';
import 'package:moli_manager/utils/app_res.dart';
import 'package:moli_manager/utils/color_res.dart';
import 'package:moli_manager/utils/const_res.dart';
import 'package:moli_manager/utils/custom/custom_widget.dart';
import 'package:moli_manager/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class SalonReviewsPage extends StatelessWidget {
  const SalonReviewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MySalonBloc, MySalonState>(
      builder: (context, state) {
        Salon? salon = state is MySalonDataFetched ? state.salon : null;
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: ColorRes.smokeWhite,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Text(
                      '${salon?.data?.rating?.toStringAsFixed(2)}',
                      style: kThinWhiteTextStyle.copyWith(
                        color: ColorRes.black,
                        fontSize: 30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3),
                      child: RatingBar(
                        initialRating: double.parse(
                            salon?.data?.rating?.toStringAsFixed(2) ?? '0'),
                        ignoreGestures: true,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star_rounded,
                            color: ColorRes.sun,
                          ),
                          half: const Icon(
                            Icons.star_rounded,
                          ),
                          empty: const Icon(
                            Icons.star_rounded,
                            color: ColorRes.darkGray,
                          ),
                        ),
                        onRatingUpdate: (value) {},
                        itemSize: 30,
                      ),
                    ),
                    Text(
                      '${salon?.data?.reviewsCount}  ${AppLocalizations.of(context)!.ratings}',
                      style: kLightWhiteTextStyle.copyWith(
                        color: ColorRes.empress,
                      ),
                    ),
                  ],
                ),
              ),
              BlocProvider(
                create: (context) => ReviewBloc(),
                child: BlocBuilder<ReviewBloc, ReviewState>(
                  builder: (context, state) {
                    if (state is FetchedReviewsState) {
                      ReviewBloc reviewBloc = context.read<ReviewBloc>();
                      return ListView.builder(
                        itemCount: reviewBloc.reviews.length,
                        primary: false,
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        itemBuilder: (context, index) {
                          salon_review.Data salonReview =
                              reviewBloc.reviews[index];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: FadeInImage.assetNetwork(
                                          image:
                                              '${ConstRes.itemBaseUrl}${salonReview.user?.profileImage}',
                                          fit: BoxFit.cover,
                                          placeholderErrorBuilder:
                                              loadingImageForCircle,
                                          imageErrorBuilder:
                                              errorBuilderForCircleImage,
                                          placeholder: '1',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${salonReview.user?.fullname?.capitalize}',
                                                style: kRegularTextStyle,
                                              ),
                                              const Spacer(),
                                              Text(
                                                AppRes.timeAgo(DateTime.parse(
                                                    salonReview.updatedAt ??
                                                        '')),
                                                style: kLightWhiteTextStyle
                                                    .copyWith(
                                                  color: ColorRes.darkGray,
                                                ),
                                              )
                                            ],
                                          ),
                                          RatingBar(
                                            initialRating: 5,
                                            ignoreGestures: true,
                                            ratingWidget: RatingWidget(
                                              full: const Icon(
                                                Icons.star_rounded,
                                                color: ColorRes.sun,
                                              ),
                                              half: const Icon(
                                                Icons.star_rounded,
                                              ),
                                              empty: const Icon(
                                                Icons.star_rounded,
                                                color: ColorRes.darkGray,
                                              ),
                                            ),
                                            onRatingUpdate: (value) {},
                                            itemSize: 20,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                                            style:
                                                kLightWhiteTextStyle.copyWith(
                                              color: ColorRes.empress,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 0.5,
                                width: double.infinity,
                                color: ColorRes.darkGray,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (state is NoReviewsFoundState) {
                      return const DataNotFound();
                    }
                    if (state is ReviewInitial) {
                      context.read<ReviewBloc>().add(FetchReviewsEvent());
                    }
                    return const SizedBox(
                      height: 500,
                      child: LoadingData(
                        color: ColorRes.white,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
