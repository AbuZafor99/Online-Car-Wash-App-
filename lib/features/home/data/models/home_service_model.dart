class HomeServiceModel {
  final String name;
  final String description;
  final bool isDry;
  final String tag;
  final String note;
  final String imageUrl;
  final Map<String, dynamic> raw;

  HomeServiceModel({
    required this.name,
    required this.description,
    required this.isDry,
    required this.tag,
    required this.note,
    required this.imageUrl,
    required this.raw,
  });

  factory HomeServiceModel.fromMap(Map<String, dynamic> m) {
    final name = (m['serviceName'] ?? m['name'] ?? m['title'] ?? '').toString();
    String description =
        (m['serviceDescription'] ?? m['description'] ?? m['details'] ?? '')
            .toString();

    // detect note fields
    String note = '';
    if (m['note'] != null) note = m['note'].toString();
    if (note.isEmpty && m['notes'] != null) note = m['notes'].toString();
    if (note.isEmpty && m['serviceNote'] != null)
      note = m['serviceNote'].toString();
    if (note.isEmpty && m['noteText'] != null) note = m['noteText'].toString();

    // try extract trailing "Note:" from description
    if (note.isEmpty && description.isNotEmpty) {
      final idx = description.indexOf('Note:');
      if (idx != -1) {
        note = description.substring(idx).trim();
        description = description.substring(0, idx).trim();
      }
    }

    String imageUrl = '';
    if (m['serviceImage'] != null && m['serviceImage'] is Map) {
      imageUrl = (m['serviceImage']['url'] ?? '').toString();
    }
    if (imageUrl.isEmpty && m['icon'] != null) imageUrl = m['icon'].toString();

    final isDry =
        (m['isDry'] != null &&
            (m['isDry'] == true || m['isDry'].toString() == '1')) ||
        name.toLowerCase().contains('dry') ||
        (m['washType'] ?? '').toString().toLowerCase().contains('dry');

    final tag = (m['tag'] ?? '').toString();

    return HomeServiceModel(
      name: name,
      description: description,
      isDry: isDry,
      tag: tag,
      note: note,
      imageUrl: imageUrl,
      raw: m,
    );
  }
}
