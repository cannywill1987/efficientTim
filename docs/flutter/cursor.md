### Selector监听

使用flutter的监听某些继承了ChangeNotifier, DiagnosticableTreeMixin 用这个方法

```dart
  @override
  Widget build(BuildContext context) {
    return Selector<GlobalStateEnv, List<FlomoMissionModel>>(
      selector: (_, globalStateEnv) => globalStateEnv.listFlomoMissionModel,
      builder: (_, listFlomoMissionModel, __) {

        );
      },
    );
}

```

### 多语言文件路径

```
/Users/linzhibin/Desktop/work/project/flutter/efficientTimeFinal/efficientTime5/efficien
tTime/lib/l10n
```

如何使用多语言

```dart
getI18NKey().xxx
```

如果是函数可以带参数

```
getI18NKey().yyy(xxx)
```

