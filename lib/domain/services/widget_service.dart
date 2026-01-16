import 'package:home_widget/home_widget.dart';
import '../models/quote.dart';

class WidgetService {
  Future<void> updateDailyQuote(Quote quote) async {
    await HomeWidget.saveWidgetData<String>('quote_text', quote.text);
    await HomeWidget.saveWidgetData<String>('quote_author', quote.author);
    await HomeWidget.updateWidget(
      name: 'QuoteWidgetProvider',
      iOSName: 'QuoteWidget',
    );
  }
}
