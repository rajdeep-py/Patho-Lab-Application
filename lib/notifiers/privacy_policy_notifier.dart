import 'package:flutter_riverpod/legacy.dart';
import '../models/privacy_policy.dart';

class PrivacyPolicyNotifier extends StateNotifier<List<PrivacyPolicy>> {
  PrivacyPolicyNotifier() : super(_initialData());

  static List<PrivacyPolicy> _initialData() {
    return List.generate(5, (index) => PrivacyPolicy.mock(index));
  }
}
