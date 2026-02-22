import 'package:flutter_test/flutter_test.dart';

import 'package:skin_cancer_detector/main.dart';
import 'package:skin_cancer_detector/providers/theme_provider.dart';

void main() {
  testWidgets('App renders with bottom navigation', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      SkinCancerDetectorApp(themeProvider: ThemeProvider()),
    );

    // Verify the four navigation tabs are present.
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Scan'), findsWidgets);
    expect(find.text('History'), findsWidgets);
    expect(find.text('About'), findsWidgets);
  });
}
