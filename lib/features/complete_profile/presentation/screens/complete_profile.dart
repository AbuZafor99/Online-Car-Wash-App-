import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Refer & Earn',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 34),
            Card(
              child: Container(
                height: 250,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refer Friends & Earn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: 250,
                      child: Text(
                        'Your friends get 25%  off their first wash, you get \$10',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      height: 42,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Color(0xFF6DB2CD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(12.5),
                      child: Text(
                        'WASH25',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRoundedButton(Icons.copy),
                        const SizedBox(width: 6),
                        _buildRoundedButton(Icons.account_box_outlined),
                        const SizedBox(width: 6),
                        _buildRoundedButton(Icons.share_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 34),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xFFEFF0F1)),
                  ),
                  child: const Text(
                    'Referral History',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildItem(
                  'Claim',
                  const Color(0xFFB2D6E4),
                  const Color(0xFF4291AF),
                ),
                _buildItem(
                  'Claim',
                  const Color(0xFFB2D6E4),
                  const Color(0xFF4291AF),
                ),
                _buildItem(
                  'Claim',
                  const Color(0xFFB2D6E4),
                  const Color(0xFF4291AF),
                ),
                _buildItem(
                  'Pending',
                  const Color(0xFFE6D793),
                  const Color(0xFFA1830E),
                ),
                _buildItem(
                  'Pending',
                  const Color(0xFFE6D793),
                  const Color(0xFFA1830E),
                ),
              ],
            ),
          ],
        ),
      ),
      showFloatingActionButton: true,
      onFabTap: () => () {},
    );
  }

  Widget _buildRoundedButton(IconData icon) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF6DB2CD),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildItem(String status, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEFF0F1), width: 1),
          left: BorderSide(color: Color(0xFFEFF0F1), width: 1),
          right: BorderSide(color: Color(0xFFEFF0F1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'John D.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Container(
            height: 20,
            width: 68,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(999),
            ),
            alignment: Alignment.center,
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
