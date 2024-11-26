// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/login_screen.dart';

class OnbodingPage extends StatefulWidget {
  @override
  _OnbodingPageState createState() => _OnbodingPageState();
}

class _OnbodingPageState extends State<OnbodingPage> {
  CarouselController carouselController = CarouselController();

  final PageController _controller = PageController();


  Widget _finalBottom(BuildContext context){

    return Container(
      width: double.infinity,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () async {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (BuildContext context) =>
              const LoginScreen()), (route) => false);
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: SGColors.primary
          ),
          child: Text(
              '싱그릿 시작하기',
              style: Fonts.bold16.copyWith(color: Colors.white)
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context){
    double hfem = MediaQuery.of(context).size.height;
    final loginViewModel = Provider.of<LoginViewModel>(context);

    final List<Widget> itemList = [
      const OnbodingFirstView(),
      const OnbodingSecondView(),
      const OnbodingThirdView(),
      const OnbodingFourthView(),
    ];

    return Material(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PageView.builder(
                controller: _controller,
                itemBuilder : (BuildContext context, int index){
                  return itemList[index];
                },
                itemCount: itemList.length,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          Positioned(
              bottom: hfem * 0.055,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, _){
                      if(_controller.page?.round() == itemList.length - 1){
                        return _finalBottom(context);
                      } else {
                        return Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: () async {
                                  await loginViewModel.saveOnBodingState();
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      const LoginPage()), (route) => false);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 30),
                                  child: Text(
                                      '건너뛰기',
                                      style: Fonts.bold18.copyWith(color: colors.BaseGrey3)
                                  ),
                                ),
                              ),
                              DotsIndicator(
                                dotsCount: itemList.length,
                                position: _controller.page?.round() ?? 0,
                                decorator: DotsDecorator(
                                  color: colors.BaseGrey4,
                                  activeColor: colors.ThemeMain,
                                  size: const Size(7,7),
                                  activeSize: const Size(10, 10),
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                onTap: (){
                                  _controller.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                          '다음',
                                          style: Fonts.bold18.copyWith(color: colors.ThemeMain)
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: colors.ThemeMain,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                ),
              )
          )
        ],
      ),
    );
  }
}