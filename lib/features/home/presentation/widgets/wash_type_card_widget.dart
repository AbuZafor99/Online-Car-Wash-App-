import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/home/data/models/home_service_model.dart';

class WashTypeCardWidget extends StatelessWidget {
  final HomeServiceModel model;
  const WashTypeCardWidget({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    final isDry = model.isDry;
    String iconPath;
    if (isDry)
      iconPath = 'assets/icons/leaf_circle.png';
    else if (model.name.toLowerCase().contains('water'))
      iconPath = 'assets/icons/water_circle.png';
    else if (model.name.toLowerCase().contains('steam'))
      iconPath = 'assets/icons/stream_circle.png';
    else
      iconPath = 'assets/icons/leaf_circle.png';

    final hasNetworkImage =
        model.imageUrl.isNotEmpty &&
        (model.imageUrl.startsWith('http') ||
            model.imageUrl.startsWith('https'));

    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                hasNetworkImage
                    ? Image.network(
                        model.imageUrl,
                        height: isDry ? 44 : 42,
                        width: isDry ? 44 : 42,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          iconPath,
                          height: isDry ? 44 : 42,
                          width: isDry ? 44 : 42,
                        ),
                      )
                    : Image.asset(
                        iconPath,
                        height: isDry ? 44 : 42,
                        width: isDry ? 44 : 42,
                      ),
                const SizedBox(width: 10),
                Text(
                  model.name.isNotEmpty
                      ? model.name
                      : (isDry ? 'Dry Wash' : 'Water Wash'),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              model.description.isNotEmpty
                  ? model.description
                  : 'Service description',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            if (model.tag.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                height: 20,
                width: 86,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFC8E7CA),
                ),
                child: Center(
                  child: Text(
                    model.tag,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
            if (model.note.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xFFF9F1CD),
                  border: Border.all(color: Color(0xFFFACC15)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Text(
                  model.note,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF854D0E),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
