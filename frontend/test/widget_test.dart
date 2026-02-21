import 'package:flutter_test/flutter_test.dart';

import 'package:skin_cancer_detector/main.dart';

void main() {
  testWidgets('App renders with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SkinCancerDetectorApp());

    // Verify the four navigation tabs are present.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Scan'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('About'), findsWidgets);
  });
}
