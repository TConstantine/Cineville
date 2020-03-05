import 'package:cineville/resources/translatable_strings.dart';
import 'package:cineville/resources/widget_key.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  test('Add/Remove favorite movies and display them on favorites screen', () async {
    // Favorites screen should be empty initially
    await driver.tap(find.byTooltip('Open navigation menu'));
    await driver.tap(find.byValueKey('drawerItem-favorite'));

    expect(await driver.getText(find.byValueKey('errorMessage')),
        TranslatableStrings.NO_FAVORITE_MOVIES);

    // Favorites screen should display 2 favorite movies
    await driver.tap(find.byTooltip('Open navigation menu'));
    await driver.tap(find.byValueKey('drawerItem-movies'));

    await driver.tap(find.byValueKey('${WidgetKey.DETAILS_BUTTON}_1}'));
    await driver.tap(find.byValueKey('${WidgetKey.FAVORITE_BUTTON}'));
    await driver.tap(find.pageBack());
    await driver.tap(find.byValueKey('${WidgetKey.DETAILS_BUTTON}_2}'));
    await driver.tap(find.byValueKey('${WidgetKey.FAVORITE_BUTTON}'));
    await driver.tap(find.pageBack());

    await driver.tap(find.byTooltip('Open navigation menu'));
    await driver.tap(find.byValueKey('drawerItem-favorite'));

    expect(await driver.getText(find.byValueKey('movieTitle-1')), 'Title 1 (2000)');
    expect(await driver.getText(find.byValueKey('movieTitle-2')), 'Title 2 (2000)');
  });
}
