import 'package:flutter/material.dart';
import '../../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "Terms & Conditions",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF505050),
                ),
              ),

              SizedBox(height: 20),

              /// Lorem Ipsum
              Text(
                "Lorem Ipsum",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. ",
                style: TextStyle(fontSize: 14, color: Color(0xFF505050)),
              ),

              SizedBox(height: 16),

              /// Lorem Ipsum
              Text(
                "Lorem Ipsum",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. ",
                style: TextStyle(fontSize: 14, color: Color(0xFF505050)),
              ),

              SizedBox(height: 16),

              /// Lorem Ipsum
              Text(
                "Lorem Ipsum",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. ",
                style: TextStyle(fontSize: 14, color: Color(0xFF505050)),
              ),

              SizedBox(height: 16),

              /// Lorem Ipsum
              Text(
                "Lorem Ipsum",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 8),
              Text(
                "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. ",
                style: TextStyle(fontSize: 14, color: Color(0xFF505050)),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
