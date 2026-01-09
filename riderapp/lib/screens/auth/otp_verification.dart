import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../components/button.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final ConfirmationResult? webConfirmationResult;

  const OTPScreen({
    super.key,
    required this.phoneNumber, 
    required String verificationId, 
    this.webConfirmationResult
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  static const int otpLength = 6;

  final List<TextEditingController> _otpControllers =
      List.generate(otpLength, (ctx) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(otpLength, (ctx) => FocusNode());
  final List<Color> _otpFieldColors =
      List.generate(otpLength, (ctx) => Colors.grey);

  int _resendTimer = 60;
  Timer? _timer;
  bool _isOtpVerified = false;

  final List<String> _enteredDigits = [];

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ---------------- TIMER ----------------
  void _startResendTimer() {
    _timer?.cancel();
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  // ---------------- OTP HANDLING ----------------
  String get _otp => _enteredDigits.join();

  void _validateOTP() {
    if (_otp.length != otpLength) {
      setState(() {
        _isOtpVerified = false;
        for (int i = 0; i < otpLength; i++) {
          _otpFieldColors[i] = Colors.grey;
        }
      });
      return;
    }

    // Replace this with Firebase verification later
    const correctOtp = "123456";

    if (_otp == correctOtp) {
      setState(() {
        _isOtpVerified = true;
        for (int i = 0; i < otpLength; i++) {
          _otpFieldColors[i] = Colors.green;
        }
      });
    } else {
      setState(() {
        _isOtpVerified = false;
        for (int i = 0; i < otpLength; i++) {
          _otpFieldColors[i] = Colors.red;
        }
      });
    }
  }

  void _syncOtpFields() {
    for (int i = 0; i < otpLength; i++) {
      _otpControllers[i].text =
          i < _enteredDigits.length ? _enteredDigits[i] : '';
    }
    _validateOTP();
  }

  // ---------------- KEYPAD ----------------
  void _onDigitPressed(String digit) {
    if (_enteredDigits.length < otpLength) {
      setState(() {
        _enteredDigits.add(digit);
      });
      _syncOtpFields();
    }
  }

  void _onClearPressed() {
    if (_enteredDigits.isNotEmpty) {
      setState(() {
        _enteredDigits.removeLast();
      });
      _syncOtpFields();
    }
  }

  // ---------------- ACTIONS ----------------
  void _resendOTP() {
    setState(() {
      _enteredDigits.clear();
      for (int i = 0; i < otpLength; i++) {
        _otpFieldColors[i] = Colors.grey;
        _otpControllers[i].clear();
      }
      _isOtpVerified = false;
    });

    _startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP resent to ${widget.phoneNumber}',
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _onContinuePressed() {
    if (!_isOtpVerified) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP verified successfully!',
            style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title:
          Text(
            "Enter the code",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Center(
                 child: Text(
                  'A verification code was sent to your number\n${widget.phoneNumber}',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(otpLength, (index) {
                  return Container(
                    width: 52,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: _otpFieldColors[index], width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _otpControllers[index].text,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // Resend row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Resend in 0:${_resendTimer.toString().padLeft(2, '0')}',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: _resendTimer == 0 ? _resendOTP : null,
                    child: Text(
                      "Send OTP",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _resendTimer == 0
                            ? Colors.blue
                            : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Keypad
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row 1: 1, 2, 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(digit: '1', onPressed: () => _onDigitPressed('1')),
                        Button(digit: '2', onPressed: () => _onDigitPressed('2')),
                        Button(digit: '3', onPressed: () => _onDigitPressed('3')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Row 2: 4, 5, 6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(digit: '4', onPressed: () => _onDigitPressed('4')),
                        Button(digit: '5', onPressed: () => _onDigitPressed('5')),
                        Button(digit: '6', onPressed: () => _onDigitPressed('6')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Row 3: 7, 8, 9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(digit: '7', onPressed: () => _onDigitPressed('7')),
                        Button(digit: '8', onPressed: () => _onDigitPressed('8')),
                        Button(digit: '9', onPressed: () => _onDigitPressed('9')),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Row 4: 0 and clear button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 80, height: 80),
                        Button(digit: '0', onPressed: () => _onDigitPressed('0')),
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: IconButton(
                            onPressed: _onClearPressed,
                            icon: const Icon(Icons.backspace_outlined, size: 28),
                            style: IconButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.grey[200],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Continue
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isOtpVerified ? _onContinuePressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isOtpVerified ? Colors.blue : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Continue",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
