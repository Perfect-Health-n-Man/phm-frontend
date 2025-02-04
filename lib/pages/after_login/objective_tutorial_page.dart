import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class ObjectiveTutorialPage extends StatefulWidget {
  final VoidCallback onDonePress;
  const ObjectiveTutorialPage({super.key, required this.onDonePress});
  @override
  State<ObjectiveTutorialPage> createState() => _ObjectiveTutorialPageState(onDonePress);
}

class _ObjectiveTutorialPageState extends State<ObjectiveTutorialPage> {
  List<ContentConfig> listContentConfig = [];
  final VoidCallback onDonePress;

  _ObjectiveTutorialPageState(this.onDonePress);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    listContentConfig.add(
      ContentConfig(
        title: "ようこそ",
        description: "はじめまして！\n初期設定を行ってください！",
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundImageFit: BoxFit.fitHeight,
        styleTitle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        styleDescription: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontFamily: 'RobotoMono',
        ),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title:
        "目標とあなたの情報を設定してください",
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        styleTitle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'RobotoMono',
        ),
        maxLineTitle: 3,
        styleDescription: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontFamily: 'RobotoMono',
        ),
        centerWidget: SizedBox(
          height: 400,
          child: Image.asset("images/tutorial1.png"),
        ),
      ),
    );
    listContentConfig.add(
      ContentConfig(
        title:
        "入力が完了したら\n登録ボタンを押してください",
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundImageFit: BoxFit.fitHeight,
        styleTitle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          fontFamily: 'RobotoMono',
        ),
        styleDescription: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 20,
          fontWeight: FontWeight.normal,
          fontFamily: 'RobotoMono',
        ),
        centerWidget: Image.asset("images/tutorial2.png"),
        maxLineTitle: 3

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      key: UniqueKey(),
      listContentConfig: listContentConfig,
      onDonePress: onDonePress,
    );
  }
}