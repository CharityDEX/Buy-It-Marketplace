import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:eat_it/app_router.dart';
import 'package:eat_it/models/app_error.dart';
import 'package:eat_it/providers/bottom_nav_visible/bottom_nav_visible.dart';
import 'package:eat_it/providers/delete_user/delete_user.dart';
import 'package:eat_it/providers/local_photo/local_photo.dart';
import 'package:eat_it/providers/local_storage_provider/local_storage_provider.dart';
import 'package:eat_it/providers/update_user/update_user.dart';
import 'package:eat_it/providers/user_data/user_data.dart';
import 'package:eat_it/providers/user_photo/user_photo.dart';
import 'package:eat_it/regExp/reg_exp.dart';
import 'package:eat_it/themes/app_theme.dart';
import 'package:eat_it/utils/relative_font_size.dart';
import 'package:eat_it/widgets/avatar_with_button/avatar_with_button.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/error_card/error_card.dart';
import 'package:eat_it/widgets/error_screen_wrapper/error_screen_wrapper.dart';
import 'package:eat_it/widgets/image_picker_modal/image_picker_modal.dart';
import 'package:eat_it/widgets/input/input.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  ConsumerState<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  Image? photo;
  String? mail;
  String? name;
  String? userText;
  bool? isBtnDisable = false;
  bool? deleteErrorVisible = false;

  AppError? updateUserError;

  @override
  void initState() {
    var userData = ref.read(fetchedUserDataProvider.notifier).state.value;
    var userPhoto = ref.read(fetchedUserPhotoProvider.notifier).state.value;
    setState(() {
      mail = userData?.email;
      name = userData?.userName;
      userText = userData?.userText;
      photo = userPhoto?.photo != null
          ? Image.memory(base64Decode(userPhoto?.photo ?? ''))
          : null;
    });

    super.initState();
  }

  void showModal(WidgetRef ref) {
    ref.read(bottomNavVisible.notifier).update((state) => false);
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20), bottom: Radius.zero)),
        context: context,
        builder: (context) => const ImagePickerModal()).whenComplete(() {
      ref.read(bottomNavVisible.notifier).update((state) => true);
    });
  }

  void updateUser() {
    final response = ref.read(updateUserProvider.notifier).updateUser(
          UpdateUserRequestData(
            photo: ref.read(localPhoto.notifier).state,
            userName: name,
            userText: userText,
          ),
        );

    response.then((value) {
      if (value!.status == 'Ok') {
        ref.read(localPhoto.notifier).update((state) => null);
        context.go('/profile');
      } else {
        setState(() {
          updateUserError = value.error;
        });
      }
    }).catchError((e) {
      setState(() {
        updateUserError = AppError(
          title: 'edit-profile.error.title'.tr(),
          message: 'edit-profile.error.message'.tr(),
        );
      });
    });
  }

  void onNameChanged(String str) {
    setState(() {
      name = str;
    });
  }

  void onTextChanged(String str) {
    setState(() {
      userText = str;
    });
  }

  String? textValidation(String? value) {
    if (value == null || value == "") {
      return "login.validations.empty-field".tr();
    }
    return null;
  }

  String? nameValidation(String? value) {
    if (value == null || value == "") {
      return "login.validations.empty-field".tr();
    }
    if (!usernameRegex.hasMatch(value)) {
      return 'login.validations.login'.tr();
    }
    return null;
  }

  void onSave(BuildContext context, WidgetRef ref) async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (formKey.currentState!.validate()) {
      updateUser();
    }
  }

  Widget renderSpinner(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: const Color(0x55FFFFFF),
      child: SpinKitCircle(
        color: Theme.of(context).primaryColor,
        size: 50,
      ),
    );
  }

  void deleteUser() async {
    final response = await ref.read(deleteUserProvider.notifier).deleteUser();
    if (response?.status == 'Ok') {
      ref.read(localStorageProvider).clear();
      context.goNamed(RouteNames.signup.name);
    } else {
      setState(() {
        deleteErrorVisible = true;
      });
    }
  }

  void onDeleteBtnClick() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("delete-user-alert.text".tr()),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              actions: <Widget>[
                Button(
                    text: "delete-user-alert.accept-btn".tr(),
                    onPressed: () {
                      Navigator.pop(context);
                      deleteUser();
                    }),
                Button(
                    text: "delete-user-alert.dis-btn".tr(),
                    onPressed: () => Navigator.pop(context)),
              ],
            ));
  }

  Widget buildErrorCard(String errorText) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 90.fontSize,
          child: Opacity(
            opacity: deleteErrorVisible == true ? 1 : 0,
            child: ErrorCard(
              title: 'edit-profile.delete-account'.tr(),
              message: errorText,
              onClose: () {
                setState(() {
                  deleteErrorVisible = false;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final updateUserRequest = ref.watch(updateUserProvider);
    ref.listen<String?>(localPhoto, (String? old_, String? new_) {
      if (new_ != null) {
        setState(() {
          photo = Image.memory(base64Decode(new_));
          updateUserError = null;
        });
      }
    });

    final deleteUserRequest = ref.watch(deleteUserProvider);

    return ErrorScreenWrapper(
        child: Stack(
      children: [
        SafeArea(
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        20.fontSize,
                        24.fontSize,
                        32.fontSize,
                        0,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                              color: const Color(0xFF22215B),
                              onPressed: () => context.go('/profile'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/editProfile/eng.svg'),
                                SizedBox(width: 5.fontSize),
                                Text(
                                  "English",
                                  style: TextStyle(
                                      color: const Color(0xFF22215B),
                                      fontFamily: 'Hind Siliguri',
                                      fontSize: 14.fontSize),
                                )
                              ],
                            )
                          ]),
                    ),
                    Expanded(
                        child: ListView(
                      padding: EdgeInsets.fromLTRB(
                        32.fontSize,
                        0,
                        32.fontSize,
                        20.fontSize,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        AvatarWithButton(
                          btnColor: const Color(0xFFE1E5FA),
                          btnIcon: const Icon(Icons.add_a_photo_outlined),
                          iconColor: const Color(0xFF5B67CA),
                          avatarRadius: 60,
                          onPressed: () => showModal(ref),
                          image: photo,
                        ),
                        SizedBox(height: 30.fontSize),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "edit-profile.my-details".tr(),
                            style: TextStyle(
                                fontSize: 16.fontSize,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF22215B)),
                          ),
                        ),
                        SizedBox(height: 25.fontSize),
                        Input(
                          validation: (value) => null,
                          isSwitchableMode: false,
                          isEditable: false,
                          icon: SvgPicture.asset(
                              'assets/editProfile/message.svg'),
                          controller: TextEditingController(text: mail),
                        ),
                        SizedBox(height: 10.fontSize),
                        Input(
                          placeholder: "edit-profile.username-placeholder".tr(),
                          icon: SvgPicture.asset('assets/editProfile/lock.svg'),
                          isSwitchableMode: true,
                          isEditable: false,
                          text: name,
                          onChanged: onNameChanged,
                          validation: nameValidation,
                          maxSymbols: 50,
                          controller: nameController,
                        ),
                        SizedBox(height: 10.fontSize),
                        Input(
                          placeholder:
                              "edit-profile.description-placeholder".tr(),
                          text: userText,
                          isSwitchableMode: true,
                          isEditable: false,
                          icon:
                              SvgPicture.asset('assets/editProfile/smile.svg'),
                          onChanged: onTextChanged,
                          maxSymbols: 200,
                          controller: textController,
                          validation: (value) => null,
                        ),
                        Container(
                            child: updateUserError != null
                                ? Container(
                                    margin: EdgeInsets.only(top: 10.fontSize),
                                    child: ErrorCard(
                                      title: updateUserError?.title ?? '',
                                      message: updateUserError?.message ?? '',
                                    ),
                                  )
                                : null),
                        ElevatedButton(
                          onPressed: onDeleteBtnClick,
                          style: const ButtonStyle(
                              shadowColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent)),
                          child: Text(
                            "edit-profile.delete-account".tr(),
                            style: TextStyle(
                                fontSize: 14.fontSize,
                                color: dangerColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 46.fontSize,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "edit-profile.terms-conditions".tr(),
                            style: TextStyle(
                                fontSize: 16.fontSize,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF22215B)),
                          ),
                        ),
                        SizedBox(height: 30.fontSize),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              elevation: 0.0,
                            ),
                            onPressed: () {},
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/editProfile/book-open.svg'),
                                    SizedBox(width: 10.fontSize),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () => context.pushNamed(
                                          RouteNames.termsOfService.name),
                                      child: Text(
                                        "edit-profile.terms-button".tr(),
                                        style: TextStyle(
                                            color: const Color(0xFF101010),
                                            fontFamily: "Hind Siliguri",
                                            fontSize: 14.fontSize,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )),
                                    SizedBox(width: 10.fontSize),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xFF5B67CA),
                                    ),
                                    SizedBox(width: 14.fontSize)
                                  ],
                                ),
                                SizedBox(height: 14.fontSize),
                                Container(
                                  height: 1,
                                  color: const Color(0xFFE3E8F1),
                                ),
                              ],
                            )),
                        SizedBox(height: 35.fontSize),
                        Button(
                          text: "edit-profile.button".tr(),
                          mode: ButtonThemeMode.accountActions,
                          onPressed: () => onSave(context, ref),
                        ),
                      ],
                    ))
                  ],
                ))),
        updateUserRequest.when(
            data: (data) => Container(),
            error: (error, stack) => Container(),
            loading: () => renderSpinner(context)),
        deleteUserRequest.when(
            data: (data) => Container(),
            error: (error, stack) =>
                SafeArea(child: buildErrorCard(error.toString())),
            loading: () => Container())
      ],
    ));
  }
}
