import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(
    WidgetTester tester, {
    VoidCallback onSignedIn,
  }) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(
              onSignedIn: onSignedIn,
            ),
          ),
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any)).thenAnswer(
      (_) => Future<User>.value(
        User(uid: '123'),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group(
    'sign in',
    () {
      testWidgets(
        'WHEN user doesn\'t enter the email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is not called'
        'AND user is not signed-in',
        (WidgetTester tester) async {
          var signedIn = false;
          await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);
          final signInButton = find.text('Sign in');
          await tester.tap(signInButton);
          verifyNever(
            mockAuth.signInWithEmailAndPassword(
              any,
              any,
            ),
          );
          expect(signedIn, false);
        },
      );

      testWidgets(
        'WHEN user enters a valid email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is called'
        'AND user is signed-in',
        (WidgetTester tester) async {
          var signedIn = false;
          await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

          stubSignInWithEmailAndPasswordSucceeds();
          const email = 'email@email.com';
          const password = 'password';

          // finds the input by key, uses expect test to make sure widget exists
          // then adds the text to the widget
          final emailField = find.byKey(Key('email'));
          expect(emailField, findsOneWidget);
          await tester.enterText(emailField, email);

          final passwordField = find.byKey(Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, password);

          // rebuilds the widget to make sure the values are entered
          // use tester.pumpAndSettle if animations are in play
          await tester.pump();

          final signInButton = find.text('Sign in');
          await tester.tap(signInButton);
          verify(
            mockAuth.signInWithEmailAndPassword(
              email,
              password,
            ),
          ).called(1);
          expect(signedIn, true);
        },
      );

      testWidgets(
        'WHEN user enters an invalid email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is called'
        'AND PlatformException is thrown',
        (WidgetTester tester) async {
          var signedIn = false;
          await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

          stubSignInWithEmailAndPasswordThrows();
          const email = 'email@email.com';
          const password = 'password';

          // finds the input by key, uses expect test to make sure widget exists
          // then adds the text to the widget
          final emailField = find.byKey(Key('email'));
          expect(emailField, findsOneWidget);
          await tester.enterText(emailField, email);

          final passwordField = find.byKey(Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, password);

          // rebuilds the widget to make sure the values are entered
          // use tester.pumpAndSettle if animations are in play
          await tester.pump();

          final signInButton = find.text('Sign in');
          await tester.tap(signInButton);
          verify(
            mockAuth.signInWithEmailAndPassword(
              email,
              password,
            ),
          ).called(1);
          expect(signedIn, false);
        },
      );
    },
  );

  group(
    'register',
    () {
      testWidgets(
        'WHEN user taps on the secondary button'
        'THEN form toggles to registration mode',
        (WidgetTester tester) async {
          await pumpEmailSignInForm(tester);
          final registerButton = find.text('Need an account? Register');
          await tester.tap(registerButton);

          await tester.pump();

          final createAccountButton = find.text('Create an account');
          expect(createAccountButton, findsOneWidget);
        },
      );

      testWidgets(
        'WHEN user taps on the secondary button'
        'AND user enters the email and password'
        'AND user taps on the register button'
        'THEN createUserWithEmailAndPassword is called',
        (WidgetTester tester) async {
          await pumpEmailSignInForm(tester);

          final registerButton = find.text('Need an account? Register');
          await tester.tap(registerButton);

          await tester.pump();

          const email = 'email@email.com';
          const password = 'password';

          // finds the input by key, uses expect test to make sure widget exists
          // then adds the text to the widget
          final emailField = find.byKey(Key('email'));
          expect(emailField, findsOneWidget);
          await tester.enterText(emailField, email);

          final passwordField = find.byKey(Key('password'));
          expect(passwordField, findsOneWidget);
          await tester.enterText(passwordField, password);

          // rebuilds the widget to make sure the values are entered
          // use tester.pumpAndSettle if animations are in play
          await tester.pump();

          final createAccountButton = find.text('Create an account');
          expect(createAccountButton, findsOneWidget);

          await tester.tap(createAccountButton);

          verify(
            mockAuth.createUserWithEmailAndPassword(
              email,
              password,
            ),
          ).called(1);
        },
      );
    },
  );
}
