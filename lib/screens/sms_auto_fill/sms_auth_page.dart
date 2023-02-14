import 'package:flutter/material.dart';
import 'package:pagination_vs_sms_fill/screens/pagination/pagination_page.dart';
import 'package:pagination_vs_sms_fill/utils/gradient_text.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:telephony/telephony.dart';

class PinputExample extends StatefulWidget {
  const PinputExample({Key? key}) : super(key: key);

  @override
  State<PinputExample> createState() => _PinputExampleState();
}

class _PinputExampleState extends State<PinputExample> with CodeAutoFill {
  final pinController = TextEditingController();
  final Telephony telephony = Telephony.instance;
  TextEditingController phoneController = TextEditingController();

  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? appSignature;
  @override
  void codeUpdated() {
    setState(() {
      pinController.text = code!;
    });
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      print("MY DEVICE SIGNATURE:$signature");
      setState(() {
        appSignature = signature;
        // phone number
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color focusedBorderColor = Colors.black;
    const fillColor = Colors.white;
    const borderColor = Colors.black;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const GradientText(
          'Enter the Tender',
          style: TextStyle(fontSize: 32),
          gradient: LinearGradient(
            colors: [
              Colors.tealAccent,
              Color(0xFF64FF95),
            ],
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 130),
              Padding(
                padding: const EdgeInsets.all(24),
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (phone) => phone != null && phone.length < 13
                      ? "Yaroqli raqam kiriting"
                      : null,
                  decoration: const InputDecoration(
                    labelText: '+998901234567',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Pinput(
                  controller: pinController,
                  focusNode: focusNode,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsUserConsentApi,
                  listenForMultipleSmsOnAndroid: true,
                  defaultPinTheme: defaultPinTheme,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Parol kiritng";
                    }
                  },
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (pin) {
                    debugPrint('onCompleted: $pin');
                  },
                  onChanged: (value) {
                    debugPrint('onChanged: $value');
                  },
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 9),
                        width: 22,
                        height: 1,
                        color: focusedBorderColor,
                      ),
                    ],
                  ),
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black),
                    ),
                  ),
                  submittedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(19),
                      border: Border.all(color: Colors.tealAccent),
                    ),
                  ),
                  errorPinTheme: defaultPinTheme.copyBorderWith(
                    border: Border.all(color: Colors.redAccent),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  // focusNode.unfocus();
                  telephony.sendSms(
                      to: "+998909343621", message: "Assalomu alaykum");

                  // if (pinController.text.isNotEmpty) {
                  //   Navigator.pushReplacement(context,
                  //       MaterialPageRoute(builder: (_) => PaginationPage()));
                  // }
                },
                child: Container(
                  width: 200,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.tealAccent,
                        Color(0xFF64FF95),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
