import 'package:flutter_test/flutter_test.dart';
 
import 'package:quote_list_app/main.dart';
 
void main() {
  testWidgets('Find the text on screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuoteListApp());
 
    expect(find.text('This is Quote List App'), findsOneWidget);
  });
}