import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:benjivet/screens/login.dart';

void main() {
  testWidgets('Login screen loads', (WidgetTester tester) async {
    // Build a tela de Login
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Verifica se o título "Login" aparece
    expect(find.text('Login'), findsOneWidget);

    // Verifica se os campos de Email e Senha existem
    expect(find.byType(TextField), findsNWidgets(2));

    // Verifica se o botão "Entrar" existe
    expect(find.text('Entrar'), findsOneWidget);

    // Verifica se o botão de cadastro existe
    expect(find.text('Não tem conta? Cadastre-se'), findsOneWidget);
  });
}
