class Guide {
  final String id;
  final String title;
  final String cpu;
  final String cpuUrl;
  final String gpu;
  final String gpuUrl;
  final String ram;
  final String ramUrl;
  final String cooler;
  final String coolerUrl;
  final String pcCase;
  final String caseUrl;
  final String price;
  final String level;
  final String tier;
  final String buyLink;

  Guide({
    this.id = '',
    required this.title,
    required this.cpu,
    required this.cpuUrl,
    required this.gpu,
    required this.gpuUrl,
    required this.ram,
    required this.ramUrl,
    this.cooler = '',
    this.coolerUrl = '',
    this.pcCase = '',
    this.caseUrl = '',
    required this.price,
    required this.level,
    required this.tier,
    this.buyLink = '',
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    print('Creating Guide from JSON: $json');

    // Determine tier from document ID or level if tier is not present
    String documentId = json['id'] ?? '';
    String level = json['level'] ?? '';
    String tier = json['tier'] ?? '';

    if (tier.isEmpty) {
      // Try to determine tier from document ID
      if (documentId.contains('Entry')) {
        tier = 'Entry Level';
      } else if (documentId.contains('Mid')) {
        tier = 'Mid Range';
      } else if (documentId.contains('High')) {
        tier = 'High End';
      } else {
        // Fall back to level
        tier = _getTierFromLevel(level);
      }
    }

    print('Determined tier: $tier for document: $documentId');

    return Guide(
      id: documentId,
      title: json['title'] ?? '',
      cpu: json['cpu'] ?? '',
      cpuUrl: json['cpu_url'] ?? '',
      gpu: json['gpu'] ?? '',
      gpuUrl: json['gpu_url'] ?? '',
      ram: json['ram'] ?? '',
      ramUrl: json['ram_url'] ?? '',
      cooler: json['cooler'] ?? '',
      coolerUrl: json['cooler_url'] ?? '',
      pcCase: json['case'] ?? '',
      caseUrl: json['case_url'] ?? '',
      price: json['price'] ?? '',
      level: level,
      tier: tier,
      buyLink: json['buy_link'] ?? '',
    );
  }

  // Helper method to determine tier from level
  static String _getTierFromLevel(String? level) {
    if (level == null || level.isEmpty) return '';

    String upperLevel = level.toUpperCase();
    if (upperLevel == 'ENTRY') return 'Entry Level';
    if (upperLevel.contains('ENTRY')) return 'Entry Level';

    if (upperLevel == 'MID') return 'Mid Range';
    if (upperLevel.contains('MID')) return 'Mid Range';

    if (upperLevel == 'HIGH') return 'High End';
    if (upperLevel.contains('HIGH')) return 'High End';

    return '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cpu': cpu,
      'cpu_url': cpuUrl,
      'gpu': gpu,
      'gpu_url': gpuUrl,
      'ram': ram,
      'ram_url': ramUrl,
      'cooler': cooler,
      'cooler_url': coolerUrl,
      'case': pcCase,
      'case_url': caseUrl,
      'price': price,
      'level': level,
      'tier': tier,
      'buy_link': buyLink,
    };
  }
}
