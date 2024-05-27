import 'package:moli_manager/model/cat/categories.dart' as cat;
import 'package:moli_manager/model/service/services.dart';
import 'package:moli_manager/service/api_service.dart';
import 'package:moli_manager/utils/custom/custom_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

part 'manage_service_event.dart';

part 'manage_service_state.dart';

class ManageServiceBloc extends Bloc<ManageServiceEvent, ManageServiceState> {
  ManageServiceBloc() : super(ManageServiceInitial()) {
    on<FetchedCategoryDataEvent>((event, emit) {
      emit(FetchCategoriesState());
    });
    on<CategoryItemClickEvent>((event, emit) async {
      emit(LoadingServiceState());
      services = await ApiService()
          .fetchServicesByCatOfSalon(categoryId: event.categoryId.toString());
      if (services?.data == null || services!.data!.isEmpty) {
        emit(ServiceDataNotFoundState());
      } else {
        emit(ServiceDataFoundState(services?.data));
      }
    });
    on<CategoryAllItemClickEvent>((event, emit) async {
      emit(LoadingServiceState());
      services = await ApiService().fetchAllServicesOfSalon();
      if (services?.data == null || services!.data!.isEmpty) {
        emit(ServiceDataNotFoundState());
      } else {
        emit(ServiceDataFoundState(services?.data));
      }
    });
    on<DeleteItemClickEvent>((event, emit) async {
      Get.bottomSheet(
        ConfirmationBottomSheet(
          title: AppLocalizations.of(Get.context!)!.deleteService,
          description: serviceData?.title ?? '',
          buttonText: AppLocalizations.of(Get.context!)!.delete,
          onButtonClick: () async {
            emit(LoadingServiceState());
            await ApiService().deleteService(serviceId: event.serviceId);
            services = await ApiService().fetchAllServicesOfSalon();
            if (services?.data == null || services!.data!.isEmpty) {
              emit(ServiceDataNotFoundState());
            } else {
              emit(ServiceDataFoundState(services?.data));
            }
          },
        ),
      );
    });

    fetchCategories();
  }

  cat.Categories? categories;
  Services? services;

  void fetchCategories() async {
    categories = await ApiService().fetchSalonCategories();

    add(FetchedCategoryDataEvent());
    add(CategoryAllItemClickEvent());
  }

  void onTapCategory(int categoryId) async {
    if (categoryId == -1) {
      add(CategoryAllItemClickEvent());
    } else {
      add(CategoryItemClickEvent(categoryId));
    }
  }

  ServiceData? serviceData;

  void deleteService(ServiceData? serviceData) {
    this.serviceData = serviceData;
    add(DeleteItemClickEvent(serviceData?.id ?? -1));
  }
}
