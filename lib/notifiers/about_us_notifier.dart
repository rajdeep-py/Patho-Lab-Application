import 'package:flutter_riverpod/legacy.dart';
import '../models/about_us.dart';

class AboutUsNotifier extends StateNotifier<AboutUs> {
  AboutUsNotifier() : super(AboutUs.mock());

  void updateAboutUs(AboutUs updated) {
    state = updated;
  }
}
