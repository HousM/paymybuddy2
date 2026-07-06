import 'package:boule_et_stats/shared/ball.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ball', () {
    testWidgets('affiche le numéro', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Ball(number: 42)),
      ));
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('label lecteur d\'écran pour un numéro principal', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Ball(number: 7)),
      ));
      expect(
        tester.getSemantics(find.byType(Ball)),
        matchesSemantics(label: 'numéro 7'),
      );
    });

    testWidgets('label différent pour une étoile', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Ball(number: 3, kind: BallKind.star)),
      ));
      expect(
        tester.getSemantics(find.byType(Ball)),
        matchesSemantics(label: 'étoile 3'),
      );
    });

    testWidgets('label différent pour un numéro chance', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: Ball(number: 5, kind: BallKind.chance)),
      ));
      expect(
        tester.getSemantics(find.byType(Ball)),
        matchesSemantics(label: 'numéro chance 5'),
      );
    });
  });
}
