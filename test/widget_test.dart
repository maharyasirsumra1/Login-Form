import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mr_yasir_login/main.dart';

void main() {
  testWidgets('welcome splash opens branded login and valid login opens home', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Log in'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(Image), findsNothing);
    expect(find.byType(ImageFiltered), findsNothing);
    expect(find.byType(GlassCard), findsNothing);
    expect(find.byType(BrandMark), findsOneWidget);
    expect(find.byKey(const ValueKey('aesthetic-background')), findsOneWidget);
    expect(find.text('YasirCodes', findRichText: true), findsOneWidget);
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold).first).backgroundColor,
      _testBackgroundColor,
    );

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Log in'), findsNothing);

    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(BrandName), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Welcome'), findsNothing);
    expect(find.text('Welcome back. We missed you!'), findsNothing);
    final loginCard = tester.widget<Container>(
      find.byKey(const ValueKey('glass-card-surface')),
    );
    expect(
      (loginCard.decoration! as BoxDecoration).color!.a,
      closeTo(0.91, 0.01),
      reason: 'The glass card should softly reveal the decorative backdrop.',
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'yasir@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.ensureVisible(find.text('Log in'));
    await tester.tap(find.text('Log in'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('You are in!'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
    expect(find.byKey(const ValueKey('main-navigation')), findsOneWidget);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Discover'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Your profile'), findsOneWidget);
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('sign up and forgot password navigation are available', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 6100));
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.text('Send reset link'), findsOneWidget);
    await tester.tap(find.text('Back to log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
    expect(find.text('Create account'), findsNWidgets(2));
  });
}

const _testBackgroundColor = Color(0xFF101B32);
