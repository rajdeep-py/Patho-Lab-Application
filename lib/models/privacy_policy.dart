class PrivacyPolicy {
  final String title;
  final String content;

  PrivacyPolicy({
    required this.title,
    required this.content,
  });

  factory PrivacyPolicy.mock(int index) {
    return PrivacyPolicy(
      title: 'Privacy Section ${index + 1}',
      content: 'We value your privacy. This section explains how we collect, use, and protect your personal information when you use our application. Your data is encrypted and securely stored. We do not sell your personal data to third parties without your explicit consent.',
    );
  }
}
