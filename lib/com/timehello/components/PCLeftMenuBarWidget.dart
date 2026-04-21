import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_hello/com/timehello/config/CONSTANTS.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';
import 'package:time_hello/com/timehello/interface/OnTapListener.dart';
import 'package:time_hello/com/timehello/models/SettingModel.dart';

import '../common/provider/Env.dart';
import 'LoginAvatarWidget.dart';

class PCLeftMenuBarWidget extends StatefulWidget {
  final OnTapListener onTapListener;
  final OnTapListener onTapAvatarWidgetListener;

  PCLeftMenuBarWidget(
      {required this.onTapListener, required this.onTapAvatarWidgetListener});

  @override
  State<StatefulWidget> createState() {
      return PCLeftMenuBarWidgetState();
  }


}


class PCLeftMenuBarWidgetState extends State<PCLeftMenuBarWidget> {
  late BuildContext context;
  static const double _railButtonSize = 40;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    this.context = context;
    return Selector<Env, SettingModel>(
        selector: (_, env) => env.settingModel ?? SettingModel(),
        builder: (_, settingModel, __) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsConfig.mineLeftRailBackground,
              border: Border(
                right: BorderSide(
                  color: ColorsConfig.mineLeftRailBorder,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: getItemsList(settingModel),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      this.widget.onTapAvatarWidgetListener({});
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.84),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: ColorsConfig.mineLeftRailAvatarBorder,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsConfig.mineLeftRailItemActiveShadow,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Transform.scale(
                        scale: 0.88,
                        child: LoginAvatarWidget(
                          onTapListener: (data) {
                            this.widget.onTapAvatarWidgetListener(data);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<Widget> getItemsList(SettingModel settingModel) {
    List<Widget> list = [];
    list.add(const SizedBox(height: 6));
    List listTmp = CONSTANTS.getLeftDesktopMenubar(settingModel: settingModel);
    listTmp.forEach((e) {
      list.add(
          getItem(e['icon'], e['iconChecked'], e['title'], e['sceneCode'], settingModel));
      list.add(const SizedBox(height: 14));
    });
    return list;
  }

  Widget getItem(Widget icon, Widget iconChecked, String text, String scene, SettingModel settingModel) {
    // Env? env = context?.watch<Env>();

    return Selector<Env, Map?>(
        selector: (_, env) => env.routerMainContainerData,
        builder: (_, routerMainContainerData, __) {
          String scenePage = (routerMainContainerData != null
              ? (routerMainContainerData['page'] ?? null)
              : CONSTANTS.getLeftDesktopMenubar(settingModel: settingModel)[0]["sceneCode"]) ?? "TomatoPage";
          bool isSelected = scenePage == scene;
          return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                this.widget.onTapListener(scene);
              },
              child: Tooltip(
                message: text,
                waitDuration: const Duration(milliseconds: 250),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: _railButtonSize,
                  height: _railButtonSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsConfig.mineLeftRailItemActiveBackground
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: ColorsConfig.mineLeftRailItemActiveShadow,
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : [],
                  ),
                  child: _buildRailIcon(
                    isSelected ? iconChecked : icon,
                    isSelected: isSelected,
                  ),
                ),
              ));
        });


  }

  Widget _buildRailIcon(Widget icon, {required bool isSelected}) {
    if (icon is Icon) {
      return Icon(
        icon.icon,
        size: icon.size ?? 20,
        color: isSelected
            ? ColorsConfig.mineLeftRailIconActive
            : ColorsConfig.mineLeftRailIcon,
      );
    }
    if (isSelected) {
      return SizedBox(
        width: 22,
        height: 22,
        child: FittedBox(
          fit: BoxFit.contain,
          child: icon,
        ),
      );
    }
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        ColorsConfig.mineLeftRailIcon,
        BlendMode.srcIn,
      ),
      child: SizedBox(
        width: 22,
        height: 22,
        child: FittedBox(
          fit: BoxFit.contain,
          child: icon,
        ),
      ),
    );
  }
}
