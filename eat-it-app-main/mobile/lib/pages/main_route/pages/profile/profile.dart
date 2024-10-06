import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/models/user_data.dart';
import 'package:eat_it/providers/leaderboard/leaderboard.dart';
import 'package:eat_it/providers/logout/logout.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_photo/user_photo.dart';
import 'package:eat_it/providers/user_position/user_position.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/avatar_placeholder/avatar_pllaceholder.dart';
import 'package:eat_it/widgets/error_screen_wrapper/error_screen_wrapper.dart';
import 'package:eat_it/widgets/leaderboard_elem/leaderboard_elem.dart';
import 'package:eat_it/widgets/shared/rounded_container.dart';
import 'package:eat_it/widgets/tile/tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      if (ref.read(fetchedLeaderboardProvider.notifier).state.value == null) {
        ref.watch(fetchedLeaderboardProvider.notifier).fetchLeaderboard(20);
      }
      if (ref.watch(userPositionProvider.notifier).state.value == null) {
        ref.watch(userPositionProvider.notifier).fetchUserPosition();
      }
      if (ref.watch(fetchedUserPhotoProvider.notifier).state.value == null) {
        ref.watch(fetchedUserPhotoProvider.notifier).fetchUserPhoto(130);
      }
      if (ref.watch(fetchedUserDataProvider.notifier).state.value == null) {
        ref.watch(fetchedUserDataProvider.notifier).fetchUser();
      }
    });
  }

  Widget renderList(LeaderboardResponce leaders) {
    if (leaders.leaderItems!.isEmpty) {
      return const Text('');
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: leaders.leaderItems!.length,
        itemBuilder: (context, index) {
          return (Column(
            children: [
              LeaderboardElem(
                points: leaders.leaderItems![index].points,
                position: index + 1,
                name: leaders.leaderItems![index].name,
                photo: leaders.leaderItems![index].photo,
              ),
              const SizedBox(height: 10)
            ],
          ));
        });
  }

  void logout(BuildContext context) async {
    ref.read(logoutProvider.notifier).logout();
  }

  void edit(BuildContext context) {
    context.go('/edit-profile');
  }

  String pluralLeaderboardPosition(int position) {
    if (position == 3) {
      return tr(
        'profile.leaderboardPosition.three',
        args: [position.toString()],
      );
    }

    return plural('profile.leaderboardPosition', position,
        args: [position.toString()]);
  }

  Widget renderPositionTile(AsyncValue<UserPositionResponce?> value) {
    return (value.when(
      data: (data) => Expanded(
        child: Tile(
            backgroundColor: const Color(0xFFD6F6D7),
            color: const Color(0xFF196500),
            icon: SvgPicture.asset('assets/icons/award.svg'),
            text: "profile.leaderboardTile".tr(),
            num: data == null
                ? '-'
                : pluralLeaderboardPosition(data.position ?? 0)),
      ),
      error: (error, stack) => Expanded(
        child: Tile(
            backgroundColor: const Color(0xFFD6F6D7),
            color: const Color(0xFF196500),
            icon: SvgPicture.asset('assets/icons/award.svg'),
            text: "profile.leaderboardTile".tr(),
            num: "-"),
      ),
      loading: () => const Expanded(
        child: SpinKitCircle(
          color: Color(0xFF196500),
        ),
      ),
    ));
  }

  Widget renderUserScoreTile(AsyncValue<UserData?> value) {
    return (value.when(
      data: (data) => Expanded(
        child: Tile(
          backgroundColor: const Color.fromARGB(50, 139, 150, 240),
          color: const Color(0xFF5B67CA),
          icon: const Icon(Icons.star, color: Color(0xFF5B67CA)),
          text: "profile.pointsTile".tr(),
          num: data == null
              ? '-'
              : (data.points == null ? '-' : data.points.toString()),
        ),
      ),
      error: (error, stack) => Expanded(
        child: Tile(
          backgroundColor: const Color.fromARGB(50, 139, 150, 240),
          color: const Color(0xFF5B67CA),
          icon: const Icon(Icons.star, color: Color(0xFF5B67CA)),
          text: "profile.pointsTile".tr(),
          num: "-",
        ),
      ),
      loading: () => const Expanded(
        child: SpinKitCircle(
          color: Color(0xFF5B67CA),
        ),
      ),
    ));
  }

  Widget renderLeaderboard(AsyncValue<LeaderboardResponce?> value) {
    return value.when(
        data: (data) {
          if (data != null) {
            return renderList(data);
          }
          return Container();
        },
        error: (error, stack) => Container(),
        loading: () => Align(
            alignment: Alignment.center,
            child: SpinKitCircle(
              size: 100,
              color: Theme.of(context).primaryColor,
            )));
  }

  Future _refreshData() async {
    ref.watch(fetchedLeaderboardProvider.notifier).fetchLeaderboard(20);
    ref.watch(userPositionProvider.notifier).fetchUserPosition();
    ref.watch(fetchedUserDataProvider.notifier).fetchUser();
    ref.watch(fetchedUserPhotoProvider.notifier).fetchUserPhoto(130);
  }

  // TODO: нужен рефактор на компоненты
  @override
  Widget build(BuildContext context) {
    var leaderboardResponce = ref.watch(fetchedLeaderboardProvider);
    var userResponse = ref.watch(fetchedUserDataProvider);
    var photoResponce = ref.watch(fetchedUserPhotoProvider);
    var positionResponce = ref.watch(userPositionProvider);

    return ErrorScreenWrapper(
        child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.fontSize,
              vertical: 10.fontSize,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => {logout(context)},
                  style: const ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(Colors.transparent),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  child: Text(
                    'profile.logout'.tr(),
                    style: TextStyle(
                        fontSize: 14.fontSize,
                        color: dangerColor,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () => {edit(context)},
                ),
              ],
            ),
          ),
          Expanded(
              child: RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 32.fontSize,
                vertical: 20.fontSize,
              ),
              shrinkWrap: true,
              children: [
                RoundedContainer(
                    borerRadius: 20,
                    color: Colors.white,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        32.fontSize,
                        16.fontSize,
                        32.fontSize,
                        24.fontSize,
                      ),
                      child: Column(children: [
                        photoResponce.when(
                            data: (data) {
                              if (data?.photo == null) {
                                return const AvatarPlaceholder();
                              }

                              return CircleAvatar(
                                radius: 64.fontSize,
                                backgroundImage: MemoryImage(base64Decode(
                                    photoResponce.value?.photo ?? '')),
                              );
                            },
                            error: (error, stack) => const AvatarPlaceholder(),
                            loading: () => const AvatarPlaceholder()),
                        userResponse.when(
                          data: (data) => Column(
                            children: [
                              SizedBox(height: 14.fontSize),
                              Text(
                                data?.userName ?? '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.fontSize,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(height: 14.fontSize),
                              Text(
                                data?.userText ?? '',
                                style: TextStyle(
                                  fontSize: 12.fontSize,
                                  color: Colors.black,
                                  height: 1.4.fontSize,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          error: (error, stack) => Container(),
                          loading: () => Column(
                            children: [
                              const SizedBox(height: 14),
                              RoundedContainer(
                                borerRadius: 5,
                                height: 20,
                                color: Colors.grey,
                                child: Container(),
                              ),
                              const SizedBox(height: 14),
                              RoundedContainer(
                                  borerRadius: 5,
                                  height: 40,
                                  color: Colors.grey,
                                  child: Container())
                            ],
                          ),
                        )
                      ]),
                    )),
                const SizedBox(height: 18),
                Text(
                  "profile.scores".tr(),
                  style: TextStyle(
                      fontSize: 16.fontSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF22215B)),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    renderUserScoreTile(userResponse),
                    const SizedBox(width: 16),
                    renderPositionTile(positionResponce)
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  "profile.leaderboard".tr(),
                  style: TextStyle(
                      fontSize: 16.fontSize,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF22215B)),
                ),
                const SizedBox(height: 10),
                renderLeaderboard(leaderboardResponce)
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
