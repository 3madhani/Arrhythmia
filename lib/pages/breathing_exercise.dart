import 'package:flutter/material.dart';
import 'dart:async';

class BreathingExercise extends StatefulWidget {
  const BreathingExercise({super.key});
  static String id = "breathing_exercise";

  @override
  _BreathingExerciseState createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise>
    with TickerProviderStateMixin {
  bool _isBreathingIn = false;
  int _seconds = 5;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  Color _pageColor = const Color(0xFF56B4BE); // Initial page color

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.2).animate(_scaleController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _scaleController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _scaleController.forward();
            }
          });

    _rotationAnimation =
        Tween<double>(begin: 0.0, end: 0.0).animate(_rotationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _rotationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _rotationController.forward();
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_pageColor, const Color(0XFF46A3B2)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: _toggleExercise,
                    child: AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: AnimatedBuilder(
                            animation: _rotationAnimation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _rotationAnimation.value,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isBreathingIn
                                        ? const Color.fromARGB(
                                            255, 26, 125, 145)
                                        : const Color(0XFFF86C66),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        spreadRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _isBreathingIn ? 'Hold' : 'Breathe',
                                          style: const TextStyle(
                                            fontSize: 25,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        if (_isBreathingIn)
                                          Text(
                                            '$_seconds seconds',
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _toggleExercise() {
    setState(() {
      if (_isBreathingIn) {
        _pauseExercise();
      } else {
        _startExercise();
      }

      // Change page color when breath button is pressed
      _pageColor =
          _isBreathingIn ? const Color(0XFFF86C66) : const Color(0xFF56B4BE);
    });
  }

  void _startExercise() {
    setState(() {
      _isBreathingIn = true;
      _scaleController.forward();
      _rotationController.forward();
      _startTimer();
    });
  }

  void _pauseExercise() {
    if (mounted) {
      setState(() {
        _isBreathingIn = false;
        _scaleController.stop();
        _rotationController.stop();
        _resetTimer();
      });
    }
  }

  void _resetTimer() {
    setState(() {
      _seconds = 5;
    });
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        if (mounted) {
          setState(() {
            _seconds--;
          });
        } else {
          _pauseExercise();
          timer.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
