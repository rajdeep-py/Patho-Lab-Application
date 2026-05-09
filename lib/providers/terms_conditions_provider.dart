import 'package:flutter_riverpod/legacy.dart';
import '../models/terms_conditions.dart';
import '../notifiers/terms_conditions_notifier.dart';

final termsConditionsProvider =
    StateNotifierProvider<TermsConditionsNotifier, List<TermsCondition>>((ref) {
      return TermsConditionsNotifier();
    });
