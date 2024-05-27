import 'package:moli_manager/model/faq/faqs.dart';
import 'package:moli_manager/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'faqs_event.dart';
part 'faqs_state.dart';

class FaqsBloc extends Bloc<FaqsEvent, FaqsState> {
  Faqs? faqCat;

  FaqsBloc() : super(FaqsInitial()) {
    on<FetchFaqsCatEvent>((event, emit) async {
      emit(FaqsLoadingState());
      faqCat = await ApiService().fetchFaqCats();
      if (faqCat != null && faqCat?.data != null && faqCat!.data!.isNotEmpty) {
        emit(FaqsDataFoundState(faqCat!));
        add(SelectFaqCategoryEvent(faqCat?.data?.first.id?.toInt() ?? 0));
      }
    });
    on<SelectFaqCategoryEvent>((event, emit) async {
      for (Data data in faqCat?.data ?? []) {
        if (data.id == event.catId) {
          List<FaqData> faqs = data.faqs ?? [];
          emit(FaqsCatSelectedState(faqs));
          break;
        }
      }
    });
    add(FetchFaqsCatEvent());
  }
}
