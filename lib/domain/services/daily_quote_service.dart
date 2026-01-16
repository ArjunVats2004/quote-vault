import 'package:intl/intl.dart';
import '../models/quote.dart';

class DailyQuoteService {
  Quote pick(List<Quote> all) {
    final seed = int.parse(DateFormat('yyyyMMdd').format(DateTime.now()));
    return all[seed % all.length];
  }
}
