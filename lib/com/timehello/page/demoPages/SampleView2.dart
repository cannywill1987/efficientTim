import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_hello/com/timehello/config/ColorsConfig.dart';

import '../../../../r.dart';
import '../../components/CreditCardWidget/src/credit_card_form.dart';
import '../../components/CreditCardWidget/src/credit_card_widget.dart';
import '../../components/CreditCardWidget/src/models/credit_card_brand.dart';
import '../../components/CreditCardWidget/src/models/credit_card_model.dart';
import '../../components/CreditCardWidget/src/models/custom_card_type_icon.dart';
import '../../components/CreditCardWidget/src/models/glassmorphism_config.dart';
import '../../components/CreditCardWidget/src/models/input_configuration.dart';
import '../../components/CreditCardWidget/src/utils/enumerations.dart';
import '../../util/ThemeManager.dart';

void main() => runApp(const MySample());

class MySample extends StatefulWidget {
  const MySample({super.key});

  @override
  State<StatefulWidget> createState() => MySampleState();
}

class MySampleState extends State<MySample> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: ThemeManager.getInstance().getInputBorderColor(defaultColor: Colors.grey.withOpacity(0.7)),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      theme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.black, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.white,
          background: Colors.black,
          // Defines colors like cursor color of the text fields.
          primary: Colors.black,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.black),
          labelStyle: const TextStyle(color: Colors.black),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      darkTheme: ThemeData(
        textTheme: const TextTheme(
          // Text style for text fields' input.
          titleMedium: TextStyle(color: Colors.white, fontSize: 18),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.black,
          background: Colors.white,
          // Defines colors like cursor color of the text fields.
          primary: Colors.white,
        ),
        // Decoration theme for the text fields.
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   // image: ExactAssetImage(
                //   //   isLightTheme ? 'assets/bg_light.png' : 'assets/bg_dark.png',
                //   // ),
                //   fit: BoxFit.fill,
                // ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => setState(() {
                        isLightTheme = !isLightTheme;
                      }),
                      icon: Icon(
                        isLightTheme ? Icons.light_mode : Icons.dark_mode,
                      ),
                    ),
                    CreditCardWidget(
                      enableFloatingCard: useFloatingAnimation,
                      glassmorphismConfig: _getGlassmorphismConfig(),
                      cardNumber: cardNumber,
                      expiryDate: expiryDate,
                      cardHolderName: cardHolderName,
                      cvvCode: cvvCode,
                      bankName: '',
                      frontCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      backCardBorder: useGlassMorphism
                          ? null
                          : Border.all(color: Colors.grey),
                      showBackView: isCvvFocused,
                      obscureCardNumber: true,
                      obscureCardCvv: true,
                      isHolderNameVisible: true,
                      cardBgColor: isLightTheme
                          ? ColorsConfig.cardBgLightColor
                          : ColorsConfig.cardBgColor,
                      backgroundImage:
                      useBackgroundImage ? R.assetsImgCardBg : null,
                      isSwipeGestureEnabled: true,
                      onCreditCardWidgetChange:
                          (CreditCardBrand creditCardBrand) {},
                      customCardTypeIcons: <CustomCardTypeIcon>[
                        CustomCardTypeIcon(
                          cardType: CardType.mastercard,
                          cardImage: Image.asset(
                            R.assetsImgMastercard,
                            height: 48,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                    //输入框
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // 信用卡
                            CreditCardForm(
                              formKey: formKey,
                              obscureCvv: true,
                              obscureNumber: true,
                              cardNumber: cardNumber,
                              cvvCode: cvvCode,
                              isHolderNameVisible: true,
                              isCardNumberVisible: true,
                              isExpiryDateVisible: true,
                              cardHolderName: cardHolderName,
                              expiryDate: expiryDate,
                              inputConfiguration: const InputConfiguration(
                                cardNumberDecoration: InputDecoration(
                                  labelText: 'Number',
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                expiryDateDecoration: InputDecoration(
                                  labelText: 'Expired Date',
                                  hintText: 'XX/XX',
                                ),
                                cvvCodeDecoration: InputDecoration(
                                  labelText: 'CVV',
                                  hintText: 'XXX',
                                ),
                                cardHolderDecoration: InputDecoration(
                                  labelText: 'Card Holder',
                                ),
                              ),
                              onCreditCardModelChange: onCreditCardModelChange,
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('Glassmorphism'),
                                  const Spacer(),
                                  Switch(
                                    value: useGlassMorphism,
                                    inactiveTrackColor: Colors.grey,
                                    activeColor: Colors.white,
                                    activeTrackColor: ColorsConfig.colorE5D1B2,
                                    onChanged: (bool value) => setState(() {
                                      useGlassMorphism = value;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('Card Image'),
                                  const Spacer(),
                                  Switch(
                                    value: useBackgroundImage,
                                    inactiveTrackColor: Colors.grey,
                                    activeColor: Colors.white,
                                    activeTrackColor: ColorsConfig.colorE5D1B2,
                                    onChanged: (bool value) => setState(() {
                                      useBackgroundImage = value;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('Floating Card'),
                                  const Spacer(),
                                  Switch(
                                    value: useFloatingAnimation,
                                    inactiveTrackColor: Colors.grey,
                                    activeColor: Colors.white,
                                    activeTrackColor: ColorsConfig.colorE5D1B2,
                                    onChanged: (bool value) => setState(() {
                                      useFloatingAnimation = value;
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _onValidate,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      ColorsConfig.colorB58D67,
                                      ColorsConfig.colorB58D67,
                                      ColorsConfig.colorE5D1B2,
                                      ColorsConfig.colorF9EED2,
                                      ColorsConfig.colorEFEFED,
                                      ColorsConfig.colorF9EED2,
                                      ColorsConfig.colorB58D67,
                                    ],
                                    begin: Alignment(-1, -4),
                                    end: Alignment(1, 4),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding:
                                const EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Validate',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'halter',
                                    fontSize: 14,
                                    package: 'flutter_credit_card',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}