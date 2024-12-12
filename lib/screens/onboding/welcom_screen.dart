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
    final List<Widget> pages = [
      const OnbodingFirstView(),
      const OnbodingSecondView(),
      const OnbodingThirdView(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: SGSpacing.p32,
          ),
          Flexible(
            child: SizedBox(
              height: SGSpacing.p32 * 3 + SGSpacing.p4 * 6,
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
              size: const Size(10, 10),
              activeSize: const Size(10, 10),
            ),
          ),
          SizedBox(
            height: SGSpacing.p24,
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SGColors.primary,
                padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
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
            height: SGSpacing.p14,
          )
        ],
      ),
    );
  }
}
