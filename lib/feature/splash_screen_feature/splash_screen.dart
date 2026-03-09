import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/constant/my_string.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/helper/secure_storage_helper .dart';
import 'package:liness/core/utils/helper/user_data/access_user_data.dart';
import 'package:liness/core/utils/helper/user_data/caching_user_data.dart';
import 'package:liness/core/utils/networking/api_consumer.dart';
import 'package:liness/feature/auth/login/data/model/token_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _hasChecked = false;

  // ── Phase Controllers ──
  // Phase 1: Center dot appears & pulses (0 → 800ms)
  // Phase 2: Orbital rings expand + particles orbit (800ms → 2200ms)
  // Phase 3: Convergence burst (2200ms → 2800ms)
  // Phase 4: Logo materializes (2800ms → 3500ms)
  // Phase 5: Text reveal (3500ms → 4200ms)
  // Phase 6: Tagline + loader (4200ms+)

  late AnimationController _dotController;       // center dot pulse
  late AnimationController _orbitController;      // orbital rings
  late AnimationController _burstController;      // convergence burst
  late AnimationController _logoRevealController; // logo appear
  late AnimationController _textRevealController; // text + tagline
  late AnimationController _loaderController;     // loading dots

  late Animation<double> _dotScale;
  late Animation<double> _dotOpacity;
  late Animation<double> _orbitProgress;
  late Animation<double> _burstProgress;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _loaderOpacity;

  // Continuous orbit spin (never stops)
  late AnimationController _spinController;
  late Animation<double> _spinAngle;

  // Typing effect
  String _displayedText = '';
  final String _fullText = 'Liness';
  Timer? _typingTimer;
  int _charIndex = 0;

  // Phase tracking
  int _phase = 0;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
    _initAnimations();
    _runSequence();
    _scheduleUserCheck();
  }

  void _initializeScreen() {
    try {
      FirebaseCrashlytics.instance.log('بدء تهيئة شاشة التحميل الجديدة');
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive).then((_) {
        FirebaseCrashlytics.instance.log('تم تفعيل وضع الشاشة الكاملة بنجاح');
      }).catchError((e, stack) {
        FirebaseCrashlytics.instance.recordError(
          e, stack,
          reason: 'فشل في تفعيل وضع الشاشة الكاملة',
          fatal: false,
        );
      });
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e, stack,
        reason: 'خطأ في تهيئة النظام',
        fatal: false,
      );
    }
  }

  void _initAnimations() {
    // ── 1. Center dot ──
    _dotController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _dotScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: Curves.elasticOut),
    );
    _dotOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dotController, curve: const Interval(0.0, 0.4)),
    );

    // ── 2. Orbital rings expand ──
    _orbitController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1400),
    );
    _orbitProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _orbitController, curve: Curves.easeOutCubic),
    );

    // ── Continuous spin ──
    _spinController = AnimationController(
      vsync: this, duration: const Duration(seconds: 4),
    )..repeat();
    _spinAngle = Tween<double>(begin: 0.0, end: math.pi * 2).animate(
      _spinController,
    );

    // ── 3. Burst / convergence ──
    _burstController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    );
    _burstProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _burstController, curve: Curves.easeInOutCubic),
    );

    // ── 4. Logo reveal ──
    _logoRevealController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoRevealController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoRevealController,
          curve: const Interval(0.0, 0.3)),
    );

    // ── 5. Text reveal ──
    _textRevealController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textRevealController, curve: Curves.easeIn),
    );

    // ── 6. Loader ──
    _loaderController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 600),
    );
    _loaderOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      _loaderController,
    );
  }

  void _runSequence() {
    // Phase 1: dot appears
    setState(() => _phase = 1);
    _dotController.forward();

    // Phase 2: orbits expand
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _phase = 2);
      _orbitController.forward();
    });

    // Phase 3: burst
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() => _phase = 3);
      _burstController.forward();
    });

    // Phase 4: logo
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      setState(() => _phase = 4);
      _logoRevealController.forward();
    });

    // Phase 5: text
    Future.delayed(const Duration(milliseconds: 3400), () {
      if (!mounted) return;
      setState(() => _phase = 5);
      _textRevealController.forward();
      _startTypingEffect();
    });

    // Phase 6: loader
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (!mounted) return;
      setState(() => _phase = 6);
      _loaderController.forward();
    });
  }

  void _startTypingEffect() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (_charIndex < _fullText.length && mounted) {
        setState(() {
          _charIndex++;
          _displayedText = _fullText.substring(0, _charIndex);
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _scheduleUserCheck() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!_hasChecked && mounted) {
        _hasChecked = true;
        _checkUserStatus();
      }
    });
    Future.delayed(const Duration(seconds: 10), () {
      if (!_hasChecked && mounted) {
        _hasChecked = true;
        _checkUserStatus();
      }
    });
  }

  @override
  void dispose() {
    _dotController.dispose();
    _orbitController.dispose();
    _spinController.dispose();
    _burstController.dispose();
    _logoRevealController.dispose();
    _textRevealController.dispose();
    _loaderController.dispose();
    _typingTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ══════════════════════════════════════════════
  // ██  BUILD
  // ══════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = Offset(size.width / 2, size.height * 0.38);

    return Scaffold(
      backgroundColor: ColorsManger.scaffolColor,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _dotController, _orbitController, _spinController,
          _burstController, _logoRevealController,
          _textRevealController, _loaderController,
        ]),
        builder: (context, _) {
          return Stack(
            children: [
              // ── Full-screen CustomPaint (all phases) ──
              Positioned.fill(
                child: CustomPaint(
                  painter: _SplashPainter(
                    phase: _phase,
                    dotScale: _dotScale.value,
                    dotOpacity: _dotOpacity.value,
                    orbitProgress: _orbitProgress.value,
                    spinAngle: _spinAngle.value,
                    burstProgress: _burstProgress.value,
                    center: center,
                    accent: ColorsManger.mainBlue,
                  ),
                ),
              ),

              // ── Logo (Phase 4+) ──
              if (_phase >= 4)
                Positioned(
                  left: center.dx - size.width * 0.14,
                  top: center.dy - size.width * 0.14,
                  child: _buildLogo(size, center),
                ),

              // ── Text + tagline (Phase 5+) ──
              if (_phase >= 5)
                Positioned(
                  top: center.dy + size.width * 0.2,
                  left: 0, right: 0,
                  child: _buildTextSection(size),
                ),

              // ── Loader (Phase 6+) ──
              if (_phase >= 6)
                Positioned(
                  bottom: size.height * 0.08,
                  left: 0, right: 0,
                  child: _buildLoader(size),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogo(Size size, Offset center) {
    final double s = size.width * 0.28;
    return Opacity(
      opacity: _logoOpacity.value,
      child: Transform.scale(
        scale: _logoScale.value,
        child: Container(
          width: s,
          height: s,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsManger.mainBlue.withOpacity(0.12),
            border: Border.all(
              color: ColorsManger.mainBlue.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: ColorsManger.mainBlue.withOpacity(0.35),
                blurRadius: 50,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: ColorsManger.lightBlue.withOpacity(0.15),
                blurRadius: 80,
                spreadRadius: 15,
              ),
            ],
          ),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      size: s * 0.38,
                      color: ColorsManger.white.withOpacity(0.95),
                    ),
                    SizedBox(height: s * 0.02),
                    Icon(
                      Icons.menu_book_rounded,
                      size: s * 0.2,
                      color: ColorsManger.white.withOpacity(0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(Size size) {
    return FadeTransition(
      opacity: _textOpacity,
      child: Column(
        children: [
          // Typing text with glow
          SizedBox(
            height: size.width * 0.15,
            child: Text(
              _displayedText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.11,
                fontWeight: FontWeight.w700,
                color: ColorsManger.white,
                letterSpacing: 6,
                shadows: [
                  Shadow(
                    color: ColorsManger.mainBlue.withOpacity(0.8),
                    blurRadius: 20,
                  ),
                  Shadow(
                    color: ColorsManger.lightBlue.withOpacity(0.4),
                    blurRadius: 40,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.012),
          // Tagline
          Text(
            'رحلتك التعليمية تبدأ هنا',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.038,
              fontWeight: FontWeight.w300,
              color: ColorsManger.white.withOpacity(0.4),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          // Education tags
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _eduTag(Icons.school_outlined, 'تعليم', size),
              _dot(size),
              _eduTag(Icons.play_lesson_outlined, 'كورسات', size),
              _dot(size),
              _eduTag(Icons.emoji_events_outlined, 'نجاح', size),
            ],
          ),
        ],
      ),
    );
  }

  Widget _eduTag(IconData icon, String label, Size size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: size.width * 0.028,
          color: ColorsManger.mainBlue.withOpacity(0.5)),
        SizedBox(width: size.width * 0.01),
        Text(label, style: TextStyle(
          fontSize: size.width * 0.026,
          color: ColorsManger.white.withOpacity(0.3),
          fontWeight: FontWeight.w300,
        )),
      ],
    );
  }

  Widget _dot(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
      child: Text('•', style: TextStyle(
        fontSize: size.width * 0.025,
        color: ColorsManger.mainBlue.withOpacity(0.3),
      )),
    );
  }

  Widget _buildLoader(Size size) {
    return FadeTransition(
      opacity: _loaderOpacity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final double phase = ((_spinAngle.value / (math.pi * 2)) * 3 - i * 0.3) % 1.0;
              final double scale = 0.5 + (math.sin(phase * math.pi) * 0.5);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorsManger.mainBlue.withOpacity(0.4 + scale * 0.6),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManger.mainBlue.withOpacity(0.3 * scale),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: size.height * 0.015),
          Text(
            'جاري التحميل...',
            style: TextStyle(
              fontSize: size.width * 0.028,
              color: ColorsManger.white.withOpacity(0.25),
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // LOGIC SECTION (Preserved from Original)
  // ==========================================

  Future<void> _checkUserStatus() async {
    try {
      debugPrint("🔍 Checking user status...");
      final tokenString =
          await getIt<SecureStorageHelper>().getData(key: MyString.token);
      final refreshTokenString = await getIt<SecureStorageHelper>()
          .getData(key: MyString.refreshToken);

      if (tokenString != null && tokenString.isNotEmpty) {
        final tokenModel = TokenModel.fromJson(jsonDecode(tokenString));
        final refreshTokenModel = refreshTokenString != null
            ? TokenModel.fromJson(jsonDecode(refreshTokenString))
            : null;

        DateTime? expiryTime;
        try {
          expiryTime = DateTime.tryParse(tokenModel.time);
          if (expiryTime == null) {
            final timestamp = int.tryParse(tokenModel.time);
            if (timestamp != null) {
              expiryTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
            }
          }
        } catch (e) {
          debugPrint("❌ Failed to parse token time: $e");
        }

        final now = DateTime.now();
        final isTokenExpired = expiryTime != null && now.isAfter(expiryTime);

        if (isTokenExpired) {
          if (refreshTokenModel != null) {
            final newToken = await _refreshToken(refreshTokenModel.token);
            if (newToken != null) {
              final updatedTokenModel = TokenModel(
                token: newToken['token'],
                time: newToken['time'],
              );
              await getIt<SecureStorageHelper>().saveData(
                key: MyString.token,
                value: jsonEncode(updatedTokenModel),
              );
              gLoginUserModel?.token = updatedTokenModel;
              CahcingUserData.cachingLoginUserModel(
                  userLoginModel: gLoginUserModel!);

              if (mounted) {
                context.pushReplacementNamed(Routes.bottomNavigationBarScreen);
              }
              return;
            }
          }
          _goToLoginOrOnboarding();
          return;
        }

        gLoginUserModel ??= await AccessUserData.getCachingLoginUserModel();
        gLoginUserModel?.token = tokenModel;
        if (refreshTokenModel != null) {
          gLoginUserModel?.refreshToken = refreshTokenModel;
        }

        if (mounted) {
          context.pushReplacementNamed(Routes.bottomNavigationBarScreen);
        }
        return;
      }

      _goToLoginOrOnboarding();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: 'فشل أثناء التحقق من حالة المستخدم',
      );
      _goToLoginOrOnboarding();
    }
  }

  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final response = await getIt<ApiConsumer>().post(
        'user/refresh-token',
        data: {'refreshToken': refreshToken},
      ).timeout(const Duration(seconds: 10));

      if (response != null && response['token'] != null) {
        final tokenData = response['token'];
        final tokenString = tokenData['token'] ?? tokenData.toString();

        dynamic timeValue = tokenData['time'];
        String timeString;

        if (timeValue is int) {
          timeString =
              DateTime.fromMillisecondsSinceEpoch(timeValue).toIso8601String();
        } else if (timeValue is String) {
          timeString = timeValue;
        } else {
          return null;
        }

        if (response['refreshToken'] != null) {
          final refreshTokenData = response['refreshToken'];
          final refreshTokenString =
              refreshTokenData['token'] ?? refreshTokenData.toString();
          dynamic refreshTimeValue = refreshTokenData['time'];
          String refreshTimeString = '';
          if (refreshTimeValue is int) {
            refreshTimeString =
                DateTime.fromMillisecondsSinceEpoch(refreshTimeValue)
                    .toIso8601String();
          } else {
            refreshTimeString = refreshTimeValue?.toString() ??
                DateTime.now().toIso8601String();
          }

          final updatedRefreshTokenModel = TokenModel(
            token: refreshTokenString,
            time: refreshTimeString,
          );

          await getIt<SecureStorageHelper>().saveData(
            key: MyString.refreshToken,
            value: jsonEncode(updatedRefreshTokenModel.toJson()),
          );

          gLoginUserModel?.refreshToken = updatedRefreshTokenModel;
        }

        return {
          'token': tokenString,
          'time': timeString,
        };
      }
    } catch (e) {
      // Silent fail -> trigger login
    }
    return null;
  }

  void _goToLoginOrOnboarding() {
    try {
      final isOnboardingDone =
          getIt<CacheHelper>().getData(key: 'onboarding') ?? false;
      final route =
          isOnboardingDone ? Routes.loginScreen : Routes.onBardingScreen;
      if (mounted) {
        context.pushReplacementNamed(route);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.loginScreen);
      }
    }
  }
}

// ══════════════════════════════════════════════════════════
// ██  THE MAIN CINEMATIC PAINTER — ALL PHASES
// ══════════════════════════════════════════════════════════

class _SplashPainter extends CustomPainter {
  final int phase;
  final double dotScale;
  final double dotOpacity;
  final double orbitProgress;
  final double spinAngle;
  final double burstProgress;
  final Offset center;
  final Color accent;

  static final math.Random _rng = math.Random(42);

  _SplashPainter({
    required this.phase,
    required this.dotScale,
    required this.dotOpacity,
    required this.orbitProgress,
    required this.spinAngle,
    required this.burstProgress,
    required this.center,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ─────────────────────────────────────
    // Phase 1+: Center glowing dot
    // ─────────────────────────────────────
    if (phase >= 1) {
      _drawCenterDot(canvas, size);
    }

    // ─────────────────────────────────────
    // Phase 2+: Orbital rings + particles
    // ─────────────────────────────────────
    if (phase >= 2) {
      _drawOrbitalSystem(canvas, size);
    }

    // ─────────────────────────────────────
    // Phase 3: Convergence burst rays
    // ─────────────────────────────────────
    if (phase >= 3 && burstProgress > 0) {
      _drawBurst(canvas, size);
    }

    // ─────────────────────────────────────
    // Phase 4+: Ambient floating particles
    // ─────────────────────────────────────
    if (phase >= 4) {
      _drawAmbientParticles(canvas, size);
    }
  }

  // ── CENTER DOT ──
  void _drawCenterDot(Canvas canvas, Size size) {
    final double radius = 6 * dotScale;
    final double glowRadius = 40 * dotScale;

    // Outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accent.withOpacity(0.4 * dotOpacity),
          accent.withOpacity(0.0),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: glowRadius),
      );
    canvas.drawCircle(center, glowRadius, glowPaint);

    // Core dot
    final dotPaint = Paint()
      ..color = accent.withOpacity(dotOpacity)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, dotPaint);

    // White hot center
    final whitePaint = Paint()
      ..color = Colors.white.withOpacity(dotOpacity * 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.4, whitePaint);
  }

  // ── ORBITAL SYSTEM ──
  void _drawOrbitalSystem(Canvas canvas, Size size) {
    final double maxRadius = size.width * 0.42;

    // Convergence factor: in phase 3, rings shrink back
    double convergeFactor = 1.0;
    if (phase >= 3) {
      convergeFactor = 1.0 - (burstProgress * 0.85);
    }

    // 5 orbital rings at different radii, speeds, tilts
    final List<_OrbitData> orbits = [
      _OrbitData(radiusFraction: 0.25, speed: 1.0,  tiltX: 0.0,   tiltY: 0.0,   particles: 6,  dashGap: 8),
      _OrbitData(radiusFraction: 0.45, speed: -0.7, tiltX: 0.3,   tiltY: 0.15,  particles: 8,  dashGap: 12),
      _OrbitData(radiusFraction: 0.65, speed: 0.5,  tiltX: -0.15, tiltY: 0.3,   particles: 10, dashGap: 16),
      _OrbitData(radiusFraction: 0.82, speed: -0.35, tiltX: 0.2,  tiltY: -0.2,  particles: 12, dashGap: 20),
      _OrbitData(radiusFraction: 1.0,  speed: 0.25,  tiltX: -0.1, tiltY: 0.1,   particles: 8,  dashGap: 24),
    ];

    for (final orbit in orbits) {
      final double r = maxRadius * orbit.radiusFraction * orbitProgress * convergeFactor;
      if (r < 2) continue;

      final double angle = spinAngle * orbit.speed;

      // ── Draw the ring (dashed arc) ──
      final ringPaint = Paint()
        ..color = accent.withOpacity(0.08 + (orbit.radiusFraction * 0.06))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8;

      canvas.save();
      canvas.translate(center.dx, center.dy);
      // Apply 3D perspective tilt
      final Matrix4 tilt = Matrix4.identity()
        ..rotateX(orbit.tiltX)
        ..rotateY(orbit.tiltY);
      canvas.transform(tilt.storage);

      // Draw dashed circle
      final int segments = 36;
      for (int i = 0; i < segments; i++) {
        if (i % 2 == 0) {
          final double startAngle = (i / segments) * math.pi * 2;
          final double sweepAngle = (1 / segments) * math.pi * 2;
          canvas.drawArc(
            Rect.fromCircle(center: Offset.zero, radius: r),
            startAngle + angle,
            sweepAngle,
            false,
            ringPaint,
          );
        }
      }

      // ── Draw orbiting particles ──
      for (int p = 0; p < orbit.particles; p++) {
        final double pAngle = angle + (p / orbit.particles) * math.pi * 2;
        final double px = math.cos(pAngle) * r;
        final double py = math.sin(pAngle) * r;
        final double pRadius = 1.5 + (p % 3) * 0.8;
        final double pOpacity = 0.15 + (math.sin(spinAngle * 2 + p) * 0.1).abs();

        final particlePaint = Paint()
          ..color = accent.withOpacity(pOpacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(px, py), pRadius, particlePaint);

        // Connecting whiskers (lines from particle toward center)
        if (p % 2 == 0) {
          final whiskerPaint = Paint()
            ..color = accent.withOpacity(0.04)
            ..strokeWidth = 0.5;
          canvas.drawLine(
            Offset(px, py),
            Offset(px * 0.7, py * 0.7),
            whiskerPaint,
          );
        }
      }

      canvas.restore();
    }

    // ── Education icons floating on orbits (drawn simply) ──
    if (phase == 2 && orbitProgress > 0.5) {
      _drawFloatingEduIcons(canvas, size, maxRadius * orbitProgress * convergeFactor);
    }
  }

  // ── FLOATING EDUCATION ICONS on orbits ──
  void _drawFloatingEduIcons(Canvas canvas, Size size, double maxR) {
    final iconPaint = Paint()
      ..color = accent.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    // Book at angle 0
    final double bAngle = spinAngle * 0.4;
    final double bR = maxR * 0.55;
    _drawMiniBook(canvas, Offset(
      center.dx + math.cos(bAngle) * bR,
      center.dy + math.sin(bAngle) * bR,
    ), 12, iconPaint);

    // Graduation cap at angle 120°
    final double gAngle = spinAngle * 0.4 + math.pi * 2 / 3;
    final double gR = maxR * 0.7;
    _drawMiniCap(canvas, Offset(
      center.dx + math.cos(gAngle) * gR,
      center.dy + math.sin(gAngle) * gR,
    ), 10, iconPaint);

    // Pencil at angle 240°
    final double pAngle = spinAngle * 0.4 + math.pi * 4 / 3;
    final double pR = maxR * 0.85;
    _drawMiniPencil(canvas, Offset(
      center.dx + math.cos(pAngle) * pR,
      center.dy + math.sin(pAngle) * pR,
    ), 14, iconPaint);
  }

  void _drawMiniBook(Canvas canvas, Offset c, double s, Paint paint) {
    // Simple open book shape
    final left = Path()
      ..moveTo(c.dx, c.dy - s * 0.3)
      ..quadraticBezierTo(c.dx - s * 0.5, c.dy - s * 0.4, c.dx - s, c.dy - s * 0.2)
      ..lineTo(c.dx - s, c.dy + s * 0.3)
      ..quadraticBezierTo(c.dx - s * 0.4, c.dy + s * 0.2, c.dx, c.dy + s * 0.3);
    canvas.drawPath(left, paint);
    final right = Path()
      ..moveTo(c.dx, c.dy - s * 0.3)
      ..quadraticBezierTo(c.dx + s * 0.5, c.dy - s * 0.4, c.dx + s, c.dy - s * 0.2)
      ..lineTo(c.dx + s, c.dy + s * 0.3)
      ..quadraticBezierTo(c.dx + s * 0.4, c.dy + s * 0.2, c.dx, c.dy + s * 0.3);
    canvas.drawPath(right, paint);
    canvas.drawLine(Offset(c.dx, c.dy - s * 0.3), Offset(c.dx, c.dy + s * 0.3), paint);
  }

  void _drawMiniCap(Canvas canvas, Offset c, double s, Paint paint) {
    // Diamond top
    final top = Path()
      ..moveTo(c.dx, c.dy - s * 0.4)
      ..lineTo(c.dx + s, c.dy)
      ..lineTo(c.dx, c.dy + s * 0.15)
      ..lineTo(c.dx - s, c.dy)
      ..close();
    canvas.drawPath(top, paint);
    // Tassel
    canvas.drawLine(Offset(c.dx + s * 0.6, c.dy - s * 0.05), Offset(c.dx + s * 0.8, c.dy + s * 0.4), paint);
  }

  void _drawMiniPencil(Canvas canvas, Offset c, double s, Paint paint) {
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(math.pi / 6);
    // Body
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: s * 0.18, height: s), paint);
    // Tip
    final tip = Path()
      ..moveTo(-s * 0.09, s * 0.5)
      ..lineTo(s * 0.09, s * 0.5)
      ..lineTo(0, s * 0.72)
      ..close();
    canvas.drawPath(tip, paint);
    canvas.restore();
  }

  // ── BURST ──
  void _drawBurst(Canvas canvas, Size size) {
    // Expanding ring of light
    final double maxR = size.width * 0.5 * burstProgress;
    final double opacity = (1.0 - burstProgress) * 0.5;

    // Central flash
    final flashPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(opacity * 0.8),
          accent.withOpacity(opacity * 0.3),
          accent.withOpacity(0.0),
        ],
        stops: const [0.0, 0.3, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: maxR),
      );
    canvas.drawCircle(center, maxR, flashPaint);

    // Expanding ring
    final ringPaint = Paint()
      ..color = accent.withOpacity(opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * (1 - burstProgress);
    canvas.drawCircle(center, maxR, ringPaint);

    // Burst rays
    final rayPaint = Paint()
      ..color = accent.withOpacity(opacity * 0.3)
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final double angle = (i / 12) * math.pi * 2;
      final double innerR = maxR * 0.3;
      final double outerR = maxR * 0.9;
      canvas.drawLine(
        Offset(
          center.dx + math.cos(angle) * innerR,
          center.dy + math.sin(angle) * innerR,
        ),
        Offset(
          center.dx + math.cos(angle) * outerR,
          center.dy + math.sin(angle) * outerR,
        ),
        rayPaint,
      );
    }
  }

  // ── AMBIENT PARTICLES (post-burst) ──
  void _drawAmbientParticles(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
      // Deterministic pseudo-random positions based on seed
      final double seedX = _seededRandom(i * 7 + 1);
      final double seedY = _seededRandom(i * 13 + 3);
      final double seedSpeed = _seededRandom(i * 5 + 7);

      final double x = seedX * size.width +
          math.sin(spinAngle * (0.3 + seedSpeed * 0.4) + i) * 15;
      final double y = seedY * size.height +
          math.cos(spinAngle * (0.2 + seedSpeed * 0.3) + i * 0.7) * 12;

      final double radius = 1.0 + (i % 4) * 0.5;
      final double opacity = 0.03 + (math.sin(spinAngle + i * 0.8) * 0.025).abs();

      paint.color = accent.withOpacity(opacity);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Subtle education shapes floating
    final shapePaint = Paint()
      ..color = accent.withOpacity(0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round;

    // Floating atom
    final double atomX = size.width * 0.85 + math.sin(spinAngle * 0.15) * 10;
    final double atomY = size.height * 0.2 + math.cos(spinAngle * 0.12) * 8;
    for (int i = 0; i < 3; i++) {
      canvas.save();
      canvas.translate(atomX, atomY);
      canvas.rotate(spinAngle * 0.1 + i * math.pi / 3);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 28, height: 10),
        shapePaint,
      );
      canvas.restore();
    }

    // Floating book
    final double bookX = size.width * 0.12 + math.sin(spinAngle * 0.18) * 8;
    final double bookY = size.height * 0.75 + math.cos(spinAngle * 0.14) * 10;
    _drawMiniBook(canvas, Offset(bookX, bookY), 14, shapePaint);

    // Floating cap
    final double capX = size.width * 0.88 + math.cos(spinAngle * 0.12) * 6;
    final double capY = size.height * 0.7 + math.sin(spinAngle * 0.16) * 9;
    _drawMiniCap(canvas, Offset(capX, capY), 10, shapePaint);
  }

  double _seededRandom(int seed) {
    return ((seed * 1103515245 + 12345) % (1 << 30)) / (1 << 30).toDouble();
  }

  @override
  bool shouldRepaint(_SplashPainter oldDelegate) => true;
}

class _OrbitData {
  final double radiusFraction;
  final double speed;
  final double tiltX;
  final double tiltY;
  final int particles;
  final double dashGap;

  const _OrbitData({
    required this.radiusFraction,
    required this.speed,
    required this.tiltX,
    required this.tiltY,
    required this.particles,
    required this.dashGap,
  });
}
