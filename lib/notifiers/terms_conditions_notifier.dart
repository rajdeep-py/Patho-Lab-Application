import 'package:flutter_riverpod/legacy.dart';
import '../models/terms_conditions.dart';

class TermsConditionsNotifier extends StateNotifier<List<TermsCondition>> {
  TermsConditionsNotifier() : super(_initialData());

  static List<TermsCondition> _initialData() {
    return List.generate(5, (index) => TermsCondition.mock(index));
  }
}
