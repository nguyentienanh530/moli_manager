import 'package:moli_manager/bloc/messageuser/message_user_bloc.dart';
import 'package:moli_manager/model/chat/chat.dart';
import 'package:moli_manager/screens/chat/chat_screen.dart';
import 'package:moli_manager/utils/app_res.dart';
import 'package:moli_manager/utils/asset_res.dart';
import 'package:moli_manager/utils/color_res.dart';
import 'package:moli_manager/utils/const_res.dart';
import 'package:moli_manager/utils/custom/custom_widget.dart';
import 'package:moli_manager/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MessagesListWidget extends StatelessWidget {
  const MessagesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageUserBloc, MessageUserState>(
      builder: (context, state) {
        MessageUserBloc messageUserBloc = context.read<MessageUserBloc>();

        return Expanded(
          child: state is MessageUsersDataFoundState
              ? messageUserBloc.userList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: messageUserBloc.userList.length,
                      itemBuilder: (context, index) {
                        Conversation conversation =
                            messageUserBloc.userList[index];
                        return ItemMessagesUsers(
                          conversation: conversation,
                        );
                      },
                    )
                  : const DataNotFound()
              : const LoadingData(),
        );
      },
    );
  }
}

class ItemMessagesUsers extends StatelessWidget {
  const ItemMessagesUsers({
    Key? key,
    required this.conversation,
  }) : super(key: key);
  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return CustomCircularInkWell(
      onTap: () {
        Get.to(() => const ChatScreen(), arguments: [
          conversation,
          context.read<MessageUserBloc>().userData
        ]);
      },
      child: Container(
        decoration: const BoxDecoration(
          color: ColorRes.smokeWhite,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 55,
                height: 55,
                child: FadeInImage.assetNetwork(
                  placeholder: '1',
                  width: 55,
                  height: 55,
                  fit: BoxFit.cover,
                  image: '${ConstRes.itemBaseUrl}${conversation.user?.image}',
                  imageErrorBuilder: (context, error, stackTrace) {
                    return AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        color: ColorRes.smokeWhite1.withOpacity(.5),
                        child: const Center(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 12.0, left: 5, right: 5),
                            child: Image(
                              image: AssetImage(AssetRes.icProfile),
                              color: ColorRes.smokeWhite2,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  placeholderErrorBuilder: loadingImageForCircle,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.user?.username?.capitalize ?? '',
                    style: kSemiBoldTextStyle.copyWith(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    conversation.lastMsg?.capitalizeFirst ?? '',
                    style: kLightWhiteTextStyle.copyWith(
                      color: ColorRes.subTitleText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppRes.timeAgo(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(conversation.time ?? '0'))),
                  style: kLightWhiteTextStyle.copyWith(
                    color: ColorRes.darkGray,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Visibility(
                  visible: (conversation.user?.msgCount ?? 0) > 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: ColorRes.sun,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    height: 26,
                    width: 26,
                    child: Center(
                      child: Text(
                        '${conversation.user?.msgCount}',
                        maxLines: 1,
                        style: kRegularWhiteTextStyle.copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
