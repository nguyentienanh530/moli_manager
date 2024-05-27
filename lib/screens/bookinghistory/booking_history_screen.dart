import 'package:moli_manager/bloc/bookinghistory/booking_history_bloc.dart';
import 'package:moli_manager/screens/bookinghistory/history_widget.dart';
import 'package:moli_manager/screens/main/main_screen.dart';
import 'package:moli_manager/utils/asset_res.dart';
import 'package:moli_manager/utils/color_res.dart';
import 'package:moli_manager/utils/custom/custom_widget.dart';
import 'package:moli_manager/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BookingHistoryBloc(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: ColorRes.themeColor5,
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 15),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    BgRoundImageWidget(
                      image: AssetRes.icBack,
                      imagePadding: 8,
                      onTap: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      AppLocalizations.of(context)!.bookingHistory,
                      style: kLightWhiteTextStyle.copyWith(
                        fontSize: 20,
                        color: ColorRes.themeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
                builder: (context, state) {
                  BookingHistoryBloc bookingHistoryBloc =
                      context.read<BookingHistoryBloc>();
                  return state is BookingHistoryInitial
                      ? const LoadingData()
                      : bookingHistoryBloc.bookings.isEmpty
                          ? const DataNotFound()
                          : SingleChildScrollView(
                              controller: bookingHistoryBloc.scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BookingHistoryWidget(
                                    bookings:
                                        bookingHistoryBloc.bookings.toList(),
                                  ),
                                ],
                              ),
                            );
                },
              ),
            ),
            // const UpcomingBookingWidget(),
          ],
        ),
      ),
    );
  }
}
