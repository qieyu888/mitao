import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pinkgirl/app.dart';
import 'package:pinkgirl/services/storage_service.dart';

void main() {
  testWidgets('Bubble Pop shows agreement when not logged in',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
    await StorageService.instance.setOnboardingDone();

    await tester.pumpWidget(const BubblePopApp());
    await tester.pumpAndSettle();

    expect(find.text('同意并进入'), findsOneWidget);
  });
}
