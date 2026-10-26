import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const _navy = Color(0xFF101B32);
const _blue = Color(0xFF5478FF);
const _purple = Color(0xFF9A4DFA);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MR Yasir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _blue,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: _navy,
        useMaterial3: true,
      ),
      home: const WelcomeGate(),
    );
  }
}

class WelcomeGate extends StatefulWidget {
  const WelcomeGate({super.key});

  @override
  State<WelcomeGate> createState() => _WelcomeGateState();
}

class _WelcomeGateState extends State<WelcomeGate> {
  Timer? _timer;
  bool _showLogin = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 6100), () {
      if (mounted) setState(() => _showLogin = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 900),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: _showLogin
          ? const LoginScreen(key: ValueKey('login'))
          : const WelcomeScreen(key: ValueKey('welcome')),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 6100),
  )..forward();

  late final Animation<double> _brandOpacity = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 15,
    ),
    TweenSequenceItem(tween: ConstantTween<double>(1), weight: 65),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 1,
        end: 0.24,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 20,
    ),
  ]).animate(_controller);

  late final Animation<double> _brandScale = Tween<double>(begin: 0.92, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0, 0.16, curve: Curves.easeOutBack),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: const ValueKey('welcome-screen'),
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: FadeTransition(
                key: const ValueKey('brand-content-fade'),
                opacity: _brandOpacity,
                child: ScaleTransition(
                  scale: _brandScale,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const BrandMark(size: 88),
                          const SizedBox(height: 24),
                          const BrandName(fontSize: 34),
                          const SizedBox(height: 22),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFFFF2E8),
                                Color(0xFFFFC5D4),
                                Color(0xFFE7C7FF),
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Welcome',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 48,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'A little space made just for you',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 0.3,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.bottomNavigationBar,
    super.key,
  });

  final Widget child;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      extendBody: bottomNavigationBar != null,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const CustomPaint(
            key: ValueKey('aesthetic-background'),
            painter: AestheticBackgroundPainter(),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

class AestheticBackgroundPainter extends CustomPainter {
  const AestheticBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final base = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF020B12), Color(0xFF03121C), Color(0xFF050A13)],
      ).createShader(bounds);
    canvas.drawRect(bounds, base);

    _drawGlow(
      canvas,
      Offset(size.width * 0.48, size.height * 0.48),
      size.shortestSide * 0.62,
      const Color(0xFF006CFF),
      0.11,
    );
    _drawGlow(
      canvas,
      Offset(size.width * 0.85, size.height * 0.34),
      size.shortestSide * 0.35,
      const Color(0xFF00A8FF),
      0.08,
    );

    final waves = [
      Path()
        ..moveTo(-size.width * 0.08, size.height * 0.55)
        ..cubicTo(
          size.width * 0.18,
          size.height * 0.47,
          size.width * 0.36,
          size.height * 0.68,
          size.width * 0.58,
          size.height * 0.51,
        )
        ..cubicTo(
          size.width * 0.77,
          size.height * 0.37,
          size.width * 0.88,
          size.height * 0.23,
          size.width * 1.08,
          size.height * 0.25,
        ),
      Path()
        ..moveTo(-size.width * 0.08, size.height * 0.73)
        ..cubicTo(
          size.width * 0.22,
          size.height * 0.70,
          size.width * 0.37,
          size.height * 0.57,
          size.width * 0.62,
          size.height * 0.65,
        )
        ..cubicTo(
          size.width * 0.82,
          size.height * 0.71,
          size.width * 0.90,
          size.height * 0.47,
          size.width * 1.08,
          size.height * 0.39,
        ),
      Path()
        ..moveTo(size.width * 0.16, -size.height * 0.06)
        ..cubicTo(
          size.width * 0.34,
          size.height * 0.08,
          size.width * 0.47,
          size.height * 0.28,
          size.width * 0.69,
          size.height * 0.12,
        )
        ..cubicTo(
          size.width * 0.82,
          size.height * 0.03,
          size.width * 0.88,
          -size.height * 0.03,
          size.width * 1.04,
          -size.height * 0.10,
        ),
    ];
    for (final wave in waves) {
      canvas.drawPath(
        wave,
        Paint()
          ..color = const Color(0xFF006DFF).withValues(alpha: 0.20)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 22
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
      );
      canvas.drawPath(
        wave,
        Paint()
          ..color = const Color(0xFF008BFF).withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 7),
      );
      canvas.drawPath(
        wave,
        Paint()
          ..shader = const LinearGradient(
            colors: [
              Color(0xFF0755D9),
              Color(0xFF16A9FF),
              Color(0xFF1269FF),
              Color(0xFF063EBA),
            ],
          ).createShader(bounds)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
  }

  void _drawGlow(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: opacity),
          color.withValues(alpha: opacity * 0.32),
          color.withValues(alpha: 0),
        ],
        stops: const [0, 0.52, 1],
      ).createShader(rect);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant AestheticBackgroundPainter oldDelegate) => false;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..forward();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _intro.dispose();
    super.dispose();
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).push(_fadeRoute(const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 410),
            child: FadeTransition(
              opacity: CurvedAnimation(parent: _intro, curve: Curves.easeOut),
              child: SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _intro,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                child: GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const BrandMark(size: 58),
                        const SizedBox(height: 12),
                        const BrandName(),
                        const SizedBox(height: 30),
                        GlassTextField(
                          controller: _emailController,
                          hint: 'Email address',
                          icon: Icons.person_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final email = value?.trim() ?? '';
                            if (email.isEmpty || !email.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 13),
                        GlassTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _hidePassword,
                          validator: (value) {
                            if ((value ?? '').length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          suffix: IconButton(
                            tooltip: _hidePassword
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: () =>
                                setState(() => _hidePassword = !_hidePassword),
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 19,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => Navigator.of(context)
                                .push(_fadeRoute(const ForgotPasswordScreen())),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xFFD6D9FF),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        GradientButton(
                          label: 'Log in',
                          icon: Icons.arrow_forward_rounded,
                          onPressed: _login,
                        ),
                        const SizedBox(height: 21),
                        const OrDivider(),
                        const SizedBox(height: 17),
                        Row(
                          children: [
                            Expanded(
                              child: SocialButton(
                                label: 'Google',
                                icon: const GoogleGlyph(),
                                onPressed: () => _showMessage(
                                  context,
                                  'Google sign-in is ready to connect to your auth provider.',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SocialButton(
                                label: 'Apple',
                                icon: const Icon(
                                  Icons.apple,
                                  color: Colors.white,
                                  size: 21,
                                ),
                                onPressed: () => _showMessage(
                                  context,
                                  'Apple sign-in is ready to connect to your auth provider.',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 21),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.75),
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 5,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () =>
                                  Navigator.of(context)
                                      .push(_fadeRoute(const SignUpScreen())),
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('glass-card-surface'),
      padding: const EdgeInsets.fromLTRB(22, 25, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2940).withValues(alpha: 0.91),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: Colors.white.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.10),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: child,
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({required this.size, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: const BrandMarkPainter()),
    );
  }
}

class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white;
    final blue = Paint()..color = _blue;
    final purple = Paint()..color = _purple;
    final left = Path()
      ..moveTo(size.width * 0.08, size.height * 0.84)
      ..lineTo(size.width * 0.49, size.height * 0.17)
      ..lineTo(size.width * 0.64, size.height * 0.43)
      ..lineTo(size.width * 0.39, size.height * 0.57)
      ..close();
    final right = Path()
      ..moveTo(size.width * 0.55, size.height * 0.54)
      ..lineTo(size.width * 0.77, size.height * 0.24)
      ..lineTo(size.width * 0.96, size.height * 0.84)
      ..lineTo(size.width * 0.67, size.height * 0.84)
      ..lineTo(size.width * 0.48, size.height * 0.68)
      ..close();
    canvas.drawPath(left, white);
    canvas.drawPath(right, blue);
    final accent = Path()
      ..moveTo(size.width * 0.51, size.height * 0.60)
      ..lineTo(size.width * 0.66, size.height * 0.45)
      ..lineTo(size.width * 0.83, size.height * 0.84)
      ..lineTo(size.width * 0.65, size.height * 0.84)
      ..close();
    canvas.drawPath(accent, purple);
  }

  @override
  bool shouldRepaint(covariant BrandMarkPainter oldDelegate) => false;
}

class BrandName extends StatelessWidget {
  const BrandName({this.fontSize = 17, super.key});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontSize > 20 ? FontWeight.w700 : FontWeight.w600,
          letterSpacing: fontSize > 20 ? 0.5 : 0,
        ),
        children: const [
          TextSpan(
            text: 'MR ',
            style: TextStyle(color: Colors.white),
          ),
          TextSpan(
            text: 'Yasir',
            style: TextStyle(color: Color(0xFF9DB2FF)),
          ),
        ],
      ),
    );
  }
}

class GlassTextField extends StatelessWidget {
  const GlassTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffix,
    super.key,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.67)),
        prefixIcon: Icon(icon, size: 20, color: Colors.white70),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.39)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.36)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFB4C2FF), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFFF9292)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFFF9292), width: 1.3),
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_blue, Color(0xFF7658F4), _purple],
          ),
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: _blue.withValues(alpha: 0.27),
              blurRadius: 17,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(icon, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              fontSize: 9,
              letterSpacing: 1.7,
              color: Colors.white.withValues(alpha: 0.68),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.3))),
      ],
    );
  }
}

class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.37)),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
        minimumSize: const Size(0, 46),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class GoogleGlyph extends StatelessWidget {
  const GoogleGlyph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        color: Color(0xFF78A8FF),
      ),
    );
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      _showMessage(context, 'Please enter a valid email address.');
      return;
    }
    _showMessage(context, 'A password reset link is ready for $email.');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 410),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BrandMark(size: 58),
                  const SizedBox(height: 18),
                  const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your email and we will help you get back in.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassTextField(
                    controller: _emailController,
                    hint: 'Email address',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 18),
                  GradientButton(
                    label: 'Send reset link',
                    icon: Icons.send_rounded,
                    onPressed: _sendResetLink,
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Back to log in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context)
        .pushAndRemoveUntil(_fadeRoute(const HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 410),
            child: GlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BrandMark(size: 54),
                    const SizedBox(height: 12),
                    const Text(
                      'Create account',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassTextField(
                      controller: _nameController,
                      hint: 'Your name',
                      icon: Icons.person_outline_rounded,
                      validator: (value) => (value?.trim().isEmpty ?? true)
                          ? 'Please enter your name'
                          : null,
                    ),
                    const SizedBox(height: 13),
                    GlassTextField(
                      controller: _emailController,
                      hint: 'Email address',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value?.contains('@') ?? false)
                          ? null
                          : 'Please enter a valid email address',
                    ),
                    const SizedBox(height: 13),
                    GlassTextField(
                      controller: _passwordController,
                      hint: 'Create a password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: true,
                      validator: (value) => (value?.length ?? 0) >= 6
                          ? null
                          : 'Use at least 6 characters',
                    ),
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Create account',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: _createAccount,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Already have an account? Log in'),
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
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _logOut() {
    Navigator.of(context).pushAndRemoveUntil(
      _fadeRoute(const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: NavigationBar(
              key: const ValueKey('main-navigation'),
              height: 70,
              backgroundColor: const Color(0xDD07131F),
              indicatorColor: const Color(0xFF146DFF).withValues(alpha: 0.24),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() => _selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore_rounded),
                  label: 'Explore',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      child: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [_homePage(), _explorePage(), _profilePage()],
        ),
      ),
    );
  }

  Widget _homePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 410),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandMark(size: 72),
                const SizedBox(height: 20),
                const Text(
                  'You are in!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 9),
                Text(
                  'Welcome to MR Yasir.\nYour local demo login worked.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 25),
                GradientButton(
                  label: 'Log out',
                  icon: Icons.logout_rounded,
                  onPressed: _logOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _explorePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 410),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discover',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'A little inspiration for what you create next.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
              ),
              const SizedBox(height: 24),
              const _ExploreCard(
                icon: Icons.auto_awesome_rounded,
                title: 'Dream it',
                subtitle: 'Every great project starts with an idea.',
              ),
              const SizedBox(height: 12),
              const _ExploreCard(
                icon: Icons.palette_outlined,
                title: 'Make it yours',
                subtitle: 'Add your own colors, style, and personality.',
              ),
              const SizedBox(height: 12),
              const _ExploreCard(
                icon: Icons.favorite_border_rounded,
                title: 'Keep creating',
                subtitle: 'Small steps can turn into lovely things.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profilePage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 410),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF167BFF).withValues(alpha: 0.2),
                    border: Border.all(
                      color: const Color(0xFF6BBEFF).withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 38,
                    color: Color(0xFFB8DEFF),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Your profile',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your MR Yasir space, all in one place.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Log out',
                  icon: Icons.logout_rounded,
                  onPressed: _logOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  const _ExploreCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Icon(icon, size: 26, color: const Color(0xFF8CCBFF)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.70),
                    height: 1.35,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Route<void> _fadeRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 420),
  );
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
}
