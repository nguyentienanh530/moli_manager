import 'package:moli_manager/bloc/gallery/gallery_bloc.dart';
import 'package:moli_manager/utils/asset_res.dart';
import 'package:moli_manager/utils/color_res.dart';
import 'package:moli_manager/utils/const_res.dart';
import 'package:moli_manager/utils/custom/custom_widget.dart';
import 'package:moli_manager/utils/style_res.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GalleryBloc(),
      child: Scaffold(
        body: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            GalleryBloc galleryBloc = context.read<GalleryBloc>();
            return Column(
              children: [
                Container(
                  color: ColorRes.smokeWhite,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        CustomCircularInkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 40,
                            width: 55,
                            padding: const EdgeInsets.all(5),
                            child: const Image(
                              image: AssetImage(AssetRes.icBack),
                            ),
                          ),
                        ),
                        ClipOval(
                          child: FadeInImage.assetNetwork(
                            height: 45,
                            width: 45,
                            placeholder: AssetRes.icPlaceHolder,
                            image:
                                '${ConstRes.itemBaseUrl}${galleryBloc.salon?.data?.images?[0].image ?? ''}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${galleryBloc.salon?.data?.salonName}',
                              style: kBoldThemeTextStyle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '${galleryBloc.salon?.data?.salonAddress}',
                              style: kLightWhiteTextStyle.copyWith(
                                color: ColorRes.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SafeArea(
                    top: false,
                    right: false,
                    left: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: DetectableText(
                            text: galleryBloc.gallery?.description ?? '',
                            basicStyle: kRegularTextStyle.copyWith(
                              fontSize: 16,
                            ),
                            detectedStyle: kMediumThemeTextStyle.copyWith(
                              fontSize: 16,
                            ),
                            colorClickableText: ColorRes.themeColor,
                            detectionRegExp: detectionRegExp(
                              hashtag: true,
                              atSign: false,
                              url: false,
                            )!,
                          ),
                        ),
                        FadeInImage.assetNetwork(
                          image:
                              '${ConstRes.itemBaseUrl}${galleryBloc.gallery?.image}',
                          placeholderErrorBuilder: loadingImage,
                          imageErrorBuilder: errorBuilderForImage,
                          placeholder: '1',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
