class AboutUs {
  final String companyName;
  final String tagline;
  final String description;
  final String mission;
  final String vision;
  final String directorName;
  final String directorMessage;
  final String directorPhotoUrl;
  final String phone;
  final String email;
  final String website;
  final String address;

  const AboutUs({
    required this.companyName,
    required this.tagline,
    required this.description,
    required this.mission,
    required this.vision,
    required this.directorName,
    required this.directorMessage,
    required this.directorPhotoUrl,
    required this.phone,
    required this.email,
    required this.website,
    required this.address,
  });

  factory AboutUs.mock() {
    return const AboutUs(
      companyName: 'Naiyo24 Patho Lab',
      tagline: 'Your Trusted Health Partner',
      description: 'Naiyo24 Patho Lab is a premier diagnostic center committed to providing highly accurate, reliable, and swift medical testing services. Equipped with state-of-the-art technology and a team of highly experienced professionals, we ensure that every test result empowers you with the knowledge to make informed health decisions.',
      mission: 'To deliver precise diagnostic services with unparalleled speed and accuracy, ensuring better healthcare outcomes for our community.',
      vision: 'To be the most trusted and technologically advanced diagnostic network, revolutionizing preventive healthcare accessibility globally.',
      directorName: 'Dr. Sarah Mitchell',
      directorMessage: 'At Naiyo24, we believe that accurate diagnosis is the first and most critical step towards a healthier life. Our commitment is to provide you with seamless, reliable, and advanced healthcare testing because your health is our ultimate priority.',
      directorPhotoUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=2070&auto=format&fit=crop',
      phone: '+91 98765 43210',
      email: 'support@naiyo24.com',
      website: 'www.naiyo24.com',
      address: '123 Health Avenue, Medical District, Tech City 400001',
    );
  }
}
