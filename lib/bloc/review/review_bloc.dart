import 'package:moli_manager/model/review/salon_review.dart';
import 'package:moli_manager/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc() : super(ReviewInitial()) {
    on<ReviewEvent>((even, emit) async {
      SalonReview salonReview =
          await ApiService().fetchMySalonReviews(start: 0);
      reviews = salonReview.data ?? [];
      reviews.isNotEmpty
          ? emit(FetchedReviewsState())
          : emit(NoReviewsFoundState());
    });
  }

  List<Data> reviews = [];
}
