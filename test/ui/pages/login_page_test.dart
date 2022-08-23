import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_health/ui/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  late LoginPresenter presenter;
  late Rxn<String> emailError = Rxn<String>();
  late Rxn<String> passwordError = Rxn<String>();
  late Rxn<String> mainError = Rxn<String>();
  late Rxn<bool> isFormValid = Rxn<bool>();
  late Rxn<bool> isLoading = Rxn<bool>();

  void mockStreams() {
    when(() => presenter.emailError).thenAnswer((_) => emailError);
    when(() => presenter.passwordError).thenAnswer((_) => passwordError);
    when(() => presenter.mainError).thenAnswer((_) => mainError);
    when(() => presenter.isFormValid).thenAnswer((_) => isFormValid);
    when(() => presenter.isLoading).thenAnswer((_) => isLoading);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<LoginPresenter>(LoginPresenterSpy());

    mockStreams();

    final loginPage = MaterialApp(home: LoginPage(presenter));
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Deve carregar com os campos validos incialmente',
      (WidgetTester tester) async {
    await loadPage(tester);

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(emailTextChildren, findsOneWidget);

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget);

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Deve chamar a validacao com os valores corretos',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(() => presenter.validateEmail(email));

    final password = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), password);
    verify(() => presenter.validatePassword(password));
  });

  testWidgets('Deve exibir um erro se o email for inválido',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = 'any error';
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Não deve exibir erro se o email for válido',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Não deve exibir erro se o email for válido',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = ('');
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Deve exibir um erro se a senha for inválido',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = 'any error';
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Não deve exibir erro se a senha for válida',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Não deve exibir erro se o senha for válido',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = ('');
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Deve habilitar o button se o form for válido',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Deve desabilitar o button se o form for válido',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = false;
    await tester.pump();

    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Deve chamar o authentication quando submeter o formulário',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    await tester.pump();
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    verify(() => presenter.auth()).called(1);
  });

  testWidgets('Deve exibir o loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Deve remover o loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();

    isLoading.value = false;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Deve exibir a mensagem de erro se a authentication falhar',
      (WidgetTester tester) async {
    await loadPage(tester);

    mainError.value = 'main error';
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });
}
