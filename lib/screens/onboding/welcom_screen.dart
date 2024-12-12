import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/screens/login_screen.dart';
import 'package:singleeat/screens/onboding/views/onboding_first_view.dart';
import 'package:singleeat/screens/onboding/views/onboding_second_view.dart';
import 'package:singleeat/screens/onboding/views/onboding_third_view.dart';

import '../../core/components/sizing.dart';
import '../../core/constants/colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> pages = [
      const OnbodingFirstView(),
      const OnbodingSecondView(),
      const OnbodingThirdView(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.12,
          ),
          Flexible(
            child: SizedBox(
              height: screenHeight * 0.6,
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
          ),
          DotsIndicator(
            dotsCount: pages.length,
            position: _currentPage,
            decorator: DotsDecorator(
              color: SGColors.gray2,
              activeColor: SGColors.primary,
              size: Size(screenWidth * 0.02, screenWidth * 0.02),
              activeSize: Size(screenWidth * 0.02, screenWidth * 0.02),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.12,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: SGTypography.body(
                "싱그릿 식단 연구소 시작하기",
                size: FontSize.medium,
                weight: FontWeight.w700,
                color: SGColors.white,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          )
        ],
      ),
    );
  }
}
