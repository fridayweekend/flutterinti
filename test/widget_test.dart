import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inti_campus/main.dart';

void main() {
  testWidgets('Navigation, saved filters and registration update state', (
    tester,
  ) async {
    await tester.pumpWidget(const IntiCampusApp());
    await tester.tap(find.text('Activities'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Save Build with Flutter'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Saved only'));
    await tester.pumpAndSettle();
    expect(find.text('Campus sports afternoon'), findsNothing);
    await tester.pump(const Duration(seconds: 5));
    await tester.ensureVisible(find.text('Join activity'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join activity'));
    await tester.pumpAndSettle();
    expect(find.text('Joined · Tap to cancel'), findsOneWidget);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Build with Flutter'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Build with Flutter'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('1 joined'), findsOneWidget);
    expect(find.text('1 saved'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Reminder validates, adds and completes', (tester) async {
    await tester.pumpWidget(const IntiCampusApp());
    await tester.tap(find.text('New reminder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required.'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), 'Return library books');
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();
    expect(find.text('1 reminders'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byTooltip('Complete reminder'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byTooltip('Complete reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Return library books'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Profile edits update dashboard and drawer', (tester) async {
    await tester.pumpWidget(const IntiCampusApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Student Test');
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(find.text('Student Test'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Student Test'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.text('Student Test'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Campus activities'));
    await tester.pumpAndSettle();
    expect(find.text('Find your next thing.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Dashboard service cards show feedback and notice is reachable', (
    tester,
  ) async {
    await tester.pumpWidget(const IntiCampusApp());
    expect(find.text('DEMO-2026001'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('3.78'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('3.78'), findsOneWidget);
    for (final title in [
      'Timetable',
      'Results',
      'Library',
      'Student support',
    ]) {
      final card = find.widgetWithText(CampusActionCard, title);
      await tester.scrollUntilVisible(
        card,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(card);
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
    }
    await tester.scrollUntilVisible(
      find.text('View reminder'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('View reminder'));
    await tester.pumpAndSettle();
    expect(find.text('Course registration'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final width in [320.0, 390.0, 1280.0]) {
    testWidgets('Pages fit viewport width $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const IntiCampusApp());
      for (final label in ['Home', 'Activities', 'Profile']) {
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}
