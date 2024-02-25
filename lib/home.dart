import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:phone_auth/provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final pProvider = Provider.of<PhoneProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'PK',
              onChanged: (phone) {
                pProvider.phoneUpdate(phone.completeNumber);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  debugPrint(pProvider.phone);
                  if (pProvider.phone.isNotEmpty) {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      verificationCompleted:
                          (PhoneAuthCredential phoneAuthCredential) {},
                      verificationFailed: (error) {},
                      codeSent: (verificationId, forceResendingToken) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPScreen(
                                verifyId: verificationId,
                              ),
                            ));
                      },
                      codeAutoRetrievalTimeout: (verificationId) {},
                      phoneNumber: pProvider.phone,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Please enter number'),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: const Text('Send code')),
          ],
        ),
      ),
    );
  }
}

class OTPScreen extends StatelessWidget {
  String verifyId;
  OTPScreen({super.key, required this.verifyId});
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pinput(
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
              length: 6,
              controller: otpController,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verifyId,
                            smsCode: otpController.text);
                    FirebaseAuth.instance
                        .signInWithCredential(credential)
                        .then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    });
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: const Text('Send code')),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Text("data"),
      ),
    );
  }
}
