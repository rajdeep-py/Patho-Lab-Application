class TermsCondition {
  final String title;
  final String content;

  TermsCondition({
    required this.title,
    required this.content,
  });

  factory TermsCondition.mock(int index) {
    return TermsCondition(
      title: '${index + 1}. General Terms and Conditions',
      content: 'These terms constitute a legally binding agreement made between you, whether personally or on behalf of an entity and Patho Lab Admin Panel, concerning your access to and use of the application. You agree that by accessing the application, you have read, understood, and agreed to be bound by all of these terms and conditions. If you do not agree with all of these terms, then you are expressly prohibited from using the application and must discontinue use immediately.',
    );
  }
}
