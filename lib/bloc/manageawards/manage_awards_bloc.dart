import 'package:moli_manager/model/user/salon.dart';
import 'package:moli_manager/service/api_service.dart';
import 'package:moli_manager/utils/custom/custom_bottom_sheet.dart';
import 'package:moli_manager/utils/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

part 'manage_awards_event.dart';

part 'manage_awards_state.dart';

class ManageAwardsBloc extends Bloc<ManageAwardsEvent, ManageAwardsState> {
  Salon? salon;

  ManageAwardsBloc() : super(ManageAwardsInitial()) {
    on<FetchAwardsEvent>((event, emit) async {
      emit(LoadingAwardsState());
      SharePref sharePref = await SharePref().init();
      salon = sharePref.getSalon();
      emit(FetchedAwardsState());
    });
    on<DeleteAwardsEvent>((event, emit) async {
      Get.bottomSheet(
        ConfirmationBottomSheet(
          title: AppLocalizations.of(Get.context!)!.deleteService,
          description: event.awards?.title ?? '',
          buttonText: AppLocalizations.of(Get.context!)!.delete,
          onButtonClick: () async {
            emit(LoadingAwardsState());
            await ApiService()
                .deleteSalonAward(awardId: event.awards?.id?.toInt() ?? -1);
            SharePref sharePref = await SharePref().init();
            salon = sharePref.getSalon();
            emit(FetchedAwardsState());
          },
        ),
      );
    });
    add(FetchAwardsEvent());
  }
}
