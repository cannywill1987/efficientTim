import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/common/database/apis/MongoApisManager.dart';
import 'package:time_hello/com/timehello/config/ENUMS.dart';
import 'package:time_hello/com/timehello/models/FolderModel.dart';
import 'package:time_hello/com/timehello/util/AnalyticsEventsManager.dart';
import 'package:time_hello/com/timehello/util/ChatGroupManager.dart';
import 'package:time_hello/com/timehello/util/DialogManagement.dart';
import 'package:time_hello/com/timehello/util/LoginManager.dart';
import 'package:time_hello/com/timehello/util/TextUtil.dart';
import 'package:time_hello/com/timehello/util/ThemeManager.dart';
import 'package:time_hello/com/timehello/util/Utility.dart';

import '../../../config/Params.dart';

class GroupChatPermissionSharingWidget extends StatefulWidget {
  final FolderModel? folderModel;

  GroupChatPermissionSharingWidget({this.folderModel});

  @override
  _GroupChatPermissionSharingWidgetState createState() =>
      _GroupChatPermissionSharingWidgetState();
}

class _GroupChatPermissionSharingWidgetState
    extends State<GroupChatPermissionSharingWidget> {
  static const Color _accentBlue = Color(0xFF3478F6);
  static const Color _softBlue = Color(0xFFEFF5FF);
  static const Color _softGreen = Color(0xFFECF9F2);
  static const Color _softOrange = Color(0xFFFFF6E4);
  static const Color _softPurple = Color(0xFFF3EEFF);
  static const Color _textPrimary = Color(0xFF1F2329);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _borderColor = Color(0xFFE7E2DC);

  String curRadioIndex = 'only_share_with_friends';
  String curEditableRadioIndex = 'can_visible';
  bool _canEdit = false;
  bool checkedPasswordOrigin = false;
  bool isMyFolder = true;
  CorrectStatusEnum correctStatusEnum = CorrectStatusEnum.normal;

  final TextEditingController _originPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _originPasswordController.dispose();
    super.dispose();
  }

  //0 未分享中 仅仅我自己 1 之后分享中 - 1 私有 - 需要搜索 仅仅好友 2 所有人可查看 3 所有人可编辑
  onClickRadio(String val) {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    switch (val) {
      case 'only_me': // 仅我自己
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "GroupChatPage",
          "eventType": "GroupChatPage_view_edit_permission_self",
          "description": "仅我自己",
        });
        this.widget.folderModel?.isSharing = 0;
        this.widget.folderModel?.isOtherUserEditable = false;
        break;
      case 'only_share_with_friends': // 仅我分享的好友
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "GroupChatPage",
          "eventType": "GroupChatPage_view_edit_permission_friends",
          "description": "仅我分享的好友",
        });
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = _canEdit;
        break;
      case 'everyone_can_view': // 所有人可查看
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "GroupChatPage",
          "eventType": "GroupChatPage_view_edit_permission_all_view",
          "description": "所有人可查看",
        });
        this.widget.folderModel?.isSharing = 2;
        this.widget.folderModel?.isOtherUserEditable = false;
        break;
      case 'everyone_can_edit': // 所有人可编辑
        AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
          "sceneType": "GroupChatPage",
          "eventType": "GroupChatPage_view_edit_permission_all_edit",
          "description": "所有人可编辑",
        });
        this.widget.folderModel?.isSharing = 3;
        this.widget.folderModel?.isOtherUserEditable = true;
        break;
    }
    MongoApisManager.getInstance().update_FolderModelWithFM(
        shouldQueryMissionModel: false,
        folderModel: this.widget.folderModel ?? FolderModel());
    setState(() {});
  }

  onPasswordChange(val) async {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    if (val.length == 6) {
      String pwdEncrypt =
          Utility.encryptCTRAES(val, Params.AES_LISTING_GROUP_PWD);
      // String s = Utility.decryptCTRAES(pwdEncrypt, Params.AES_LISTING_GROUP_PWD);
      this.widget.folderModel?.groupChatPassword = pwdEncrypt;
      await MongoApisManager.getInstance().update_FolderModelWithFM(
          shouldQueryMissionModel: false,
          folderModel: this.widget.folderModel ?? FolderModel());
      this.correctStatusEnum = CorrectStatusEnum.success;
    }
  }

  onClickRadioShareMyFriends(String val) {
    if (ChatGroupManager.isFolderModelEnabled(
            folderId: this.widget.folderModel?.objectId ?? "",
            uid: LoginManager.getInstance().userBean.uid ?? "") ==
        false) {
      Utility.showToastMsg(
          context: Utility.getGlobalContext(), msg: getI18NKey().no_auth);
      return null;
    }
    switch (val) {
      case 'can_visible': // 可查看
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = false;
        _canEdit = false;
        break;
      case 'can_editable': // 可编辑
        this.widget.folderModel?.isSharing = 1;
        this.widget.folderModel?.isOtherUserEditable = true;
        _canEdit = true;
        break;
    }
    curEditableRadioIndex = val;
    MongoApisManager.getInstance().update_FolderModelWithFM(
        shouldQueryMissionModel: false,
        folderModel: this.widget.folderModel ?? FolderModel());
    setState(() {});
  }

  initState() {
    if (ChatGroupManager.isMyFolder(
        folderModel: this.widget.folderModel ?? FolderModel())) {
      isMyFolder = true;
    } else {
      isMyFolder = false;
    }

    if (!TextUtil.isEmpty(this.widget.folderModel?.groupChatPassword)) {
      String s = Utility.decryptCTRAES(
          this.widget.folderModel?.groupChatPassword ?? "",
          Params.AES_LISTING_GROUP_PWD);
      _originPasswordController.text = s;
    }
    curRadioIndex = this.widget.folderModel?.isSharing == 0
        ? 'only_me'
        : this.widget.folderModel?.isSharing == 1
            ? 'only_share_with_friends'
            : this.widget.folderModel?.isSharing == 2
                ? 'everyone_can_view'
                : 'everyone_can_edit';
    _canEdit = this.widget.folderModel?.isOtherUserEditable ?? false;
    curEditableRadioIndex = _canEdit ? 'can_editable' : 'can_visible';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color surfaceColor =
        ThemeManager.getInstance().getCardBackgroundColor();
    final bool isCompact = Utility.isHandsetBySize();
    return Container(
      width: isCompact ? double.infinity : 760,
      constraints: BoxConstraints(maxHeight: isCompact ? 760 : 640),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isCompact ? 24 : 30,
          isCompact ? 24 : 28,
          isCompact ? 24 : 30,
          isCompact ? 22 : 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            const SizedBox(height: 22),
            if (isCompact)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildPermissionOptionsList(),
                  if (isMyFolder) ...<Widget>[
                    const SizedBox(height: 18),
                    _buildPasswordCard(),
                  ],
                  const SizedBox(height: 16),
                  _buildShareCard(),
                  const SizedBox(height: 16),
                  _buildSecurityHint(),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 11,
                    child: _buildPermissionOptionsList(),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 10,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (isMyFolder) ...<Widget>[
                          _buildPasswordCard(),
                          const SizedBox(height: 16),
                        ],
                        _buildShareCard(),
                        const SizedBox(height: 16),
                        _buildSecurityHint(),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionOptionsList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildPermissionOption(
          value: 'only_me',
          title: getI18NKey().only_me,
          subtitle: getI18NKey().can_view,
          icon: Icons.person_outline_rounded,
          iconColor: _accentBlue,
          iconBackground: _softBlue,
        ),
        const SizedBox(height: 10),
        _buildPermissionOption(
          value: 'only_share_with_friends',
          title: getI18NKey().only_share_with_friends,
          subtitle: _canEdit ? getI18NKey().can_edit : getI18NKey().can_view,
          icon: Icons.group_outlined,
          iconColor: const Color(0xFF2EAA70),
          iconBackground: _softGreen,
          child: curRadioIndex == 'only_share_with_friends'
              ? _buildFriendsEditableSwitch()
              : null,
        ),
        const SizedBox(height: 10),
        _buildPermissionOption(
          value: 'everyone_can_view',
          title: getI18NKey().everyone_can_view,
          subtitle: getI18NKey().can_view,
          icon: Icons.groups_2_outlined,
          iconColor: const Color(0xFFF5A623),
          iconBackground: _softOrange,
        ),
        const SizedBox(height: 10),
        _buildPermissionOption(
          value: 'everyone_can_edit',
          title: getI18NKey().everyone_can_edit,
          subtitle: getI18NKey().can_edit,
          icon: Icons.edit_note_rounded,
          iconColor: const Color(0xFF7C5CFF),
          iconBackground: _softPurple,
        ),
      ],
    );
  }

  Widget _buildSecurityHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.verified_user_outlined,
            size: 16, color: _textSecondary.withValues(alpha: 0.85)),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            getI18NKey().password_required_for_sharing,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: _softBlue,
            borderRadius: BorderRadius.circular(23),
          ),
          child: const Icon(Icons.manage_accounts_outlined,
              color: _accentBlue, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                getI18NKey().who_can_view_edit_files,
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                getI18NKey().group_listing,
                style: const TextStyle(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        _buildCloseButton(),
      ],
    );
  }

  Widget _buildCloseButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => DialogManagement.getInstance().hideDialog(context),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        child: const Icon(Icons.close_rounded, size: 22, color: _textPrimary),
      ),
    );
  }

  Widget _buildPermissionOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    Widget? child,
  }) {
    final bool selected = curRadioIndex == value;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _selectPermission(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF8FBFF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? _accentBlue : _borderColor,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: _accentBlue.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _buildRadioDot(selected),
                const SizedBox(width: 16),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: iconColor, size: 25),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (child != null) ...<Widget>[
              const SizedBox(height: 12),
              child,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRadioDot(bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? _accentBlue : const Color(0xFFC8CDD4),
          width: selected ? 6 : 1.6,
        ),
      ),
    );
  }

  Widget _buildFriendsEditableSwitch() {
    return Container(
      margin: const EdgeInsets.only(left: 52),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildEditableChip(
            value: 'can_visible',
            label: getI18NKey().can_view,
            selected: curEditableRadioIndex == 'can_visible',
          ),
          _buildEditableChip(
            value: 'can_editable',
            label: getI18NKey().can_edit,
            selected: curEditableRadioIndex == 'can_editable',
          ),
        ],
      ),
    );
  }

  Widget _buildEditableChip({
    required String value,
    required String label,
    required bool selected,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        onClickRadioShareMyFriends(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _accentBlue : _textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softBlue.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3ECFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE1ECFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock_outline_rounded,
                color: _accentBlue, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  getI18NKey().set_6_digit_password,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  getI18NKey().set_password_for_group,
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildPasswordTextField()),
                    const SizedBox(width: 12),
                    Text(
                      '${_originPasswordController.text.length}/6',
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                getPwdStatusText(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: _originPasswordController,
        obscureText: !checkedPasswordOrigin,
        maxLength: 6,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          suffixIcon: IconButton(
            tooltip: checkedPasswordOrigin
                ? getI18NKey().popup_invisible3
                : getI18NKey().popup_visible2,
            onPressed: () {
              checkedPasswordOrigin = !checkedPasswordOrigin;
              setState(() {});
            },
            icon: Icon(
              checkedPasswordOrigin
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: _textSecondary,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: _borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: BorderSide(color: _borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(11),
            borderSide: const BorderSide(color: _accentBlue, width: 1.2),
          ),
          hintText: getI18NKey().please_origin_password,
          hintStyle: TextStyle(
            color: ThemeManager.getInstance().getInputPlaceholderColor(),
            fontSize: 13,
          ),
        ),
        onChanged: (value) async {
          if (value.length == 6) {
            correctStatusEnum = CorrectStatusEnum.correct;
            await onPasswordChange(value);
          } else {
            correctStatusEnum = value.isEmpty
                ? CorrectStatusEnum.normal
                : CorrectStatusEnum.wrong;
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildShareCard() {
    final String code = widget.folderModel?.folderTeamWorkId ?? '';
    final String shareText = getI18NKey().share_the_link(
      widget.folderModel?.title ?? '',
      code,
      getI18NKey().app_name,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _softGreen.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDF3E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDF7EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.link_rounded,
                    color: Color(0xFF1EA66A), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      getI18NKey().share_to,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: _textSecondary,
                          fontSize: 13,
                          height: 1.35,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: getI18NKey().copy_link_description(code),
                          ),
                          if (code.isNotEmpty)
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD7F2E6),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: Text(
                                  code,
                                  style: const TextStyle(
                                    color: Color(0xFF1E9B62),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: _borderColor),
                  ),
                  child: SelectableText(
                    shareText,
                    maxLines: 1,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: _copyShareText,
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(
                    getI18NKey().copy_link,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _selectPermission(String value) {
    onClickRadio(value);
    setState(() {
      curRadioIndex = value;
      if (value == 'only_share_with_friends') {
        curEditableRadioIndex = _canEdit ? 'can_editable' : 'can_visible';
      }
    });
  }

  void _copyShareText() {
    AnalyticsEventsManager.getInstance().sendAnalyticsEventMap({
      "sceneType": "GroupChatPage",
      "eventType": "GroupChatPage_copy_link",
      "description": "复制链接",
    });
    Utility.copyToClipboard(
      getI18NKey().share_the_link(
        widget.folderModel?.title ?? "",
        widget.folderModel?.folderTeamWorkId ?? "",
        getI18NKey().app_name,
      ),
    );
  }

  Widget getPwdStatusText() {
    if (correctStatusEnum == CorrectStatusEnum.normal) {
      return SizedBox.shrink();
    } else if (correctStatusEnum == CorrectStatusEnum.correct) {
      return Text(
        getI18NKey().password_correct,
        style: TextStyle(color: Colors.green, fontSize: 12),
      );
    } else if (correctStatusEnum == CorrectStatusEnum.wrong) {
      return Text(getI18NKey().please_enter_6_digit_password,
          style: TextStyle(color: Colors.red, fontSize: 12));
    } else if (correctStatusEnum == CorrectStatusEnum.success) {
      return Text(
        getI18NKey().password_set_success,
        style: TextStyle(color: Colors.green, fontSize: 12),
      );
    }
    return Text(getI18NKey().password_required_for_sharing,
        style: TextStyle(color: _textSecondary, fontSize: 12));
  }
}
