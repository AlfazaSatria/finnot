import 'package:finnot/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the users screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FinnotApp());

    expect(find.text('Finnot'), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Add a user'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 50));
  });
}
