import 'package:flutter_riverpod/legacy.dart';
import '../models/test.dart';

class TestNotifier extends StateNotifier<List<LabTest>> {
  TestNotifier()
    : super([
        LabTest(
          id: '1',
          name: 'Complete Blood Count (CBC)',
          category: 'Blood Test',
          price: 500.0,
          photoUrl:
              'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop',
          detailedDescription:
              'A complete blood count (CBC) is a blood test used to evaluate your overall health and detect a wide range of disorders, including anemia, infection and leukemia.',
          parameters: [
            'Hemoglobin',
            'RBC Count',
            'WBC Count',
            'Platelet Count',
          ],
          precautions: [
            'Fasting is not required',
            'Avoid alcohol 24 hours prior',
          ],
          sampleCollectionType: 'Blood Sample',
          sampleCollectionTime: 'Within 60 mins',
          reportDeliveryTime: 'Within 24 hours',
        ),
        LabTest(
          id: '2',
          name: 'Lipid Profile',
          category: 'Heart Test',
          price: 800.0,
          photoUrl:
              'https://images.unsplash.com/photo-1579154204601-01588f351e67?q=80&w=2070&auto=format&fit=crop',
          detailedDescription:
              'A lipid profile is a blood test that can measure the amount of cholesterol and triglycerides in your blood.',
          parameters: ['Total Cholesterol', 'HDL', 'LDL', 'Triglycerides'],
          precautions: ['10-12 hours fasting required'],
          sampleCollectionType: 'Blood Sample',
          sampleCollectionTime: 'Within 60 mins',
          reportDeliveryTime: 'Within 24 hours',
        ),
      ]);

  void addTest(LabTest test) {
    state = [...state, test];
  }

  void updateTest(LabTest test) {
    state = [
      for (final t in state)
        if (t.id == test.id) test else t,
    ];
  }

  void deleteTest(String id) {
    state = state.where((t) => t.id != id).toList();
  }
}
