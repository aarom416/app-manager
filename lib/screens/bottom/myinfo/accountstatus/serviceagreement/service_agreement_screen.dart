import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/components/app_bar_with_left_arrow.dart';
import '../../../../../core/components/container.dart';
import '../../../../../core/components/sizing.dart';
import '../../../../../core/components/spacing.dart';
import '../../../../../core/components/typography.dart';
import '../../../../../core/constants/colors.dart';

class ServiceAgreementScreen extends ConsumerStatefulWidget {
  final String title;

  const ServiceAgreementScreen({
    super.key,
    required this.title,
  });

  @override
  ConsumerState<ServiceAgreementScreen> createState() =>
      _ServiceAgreementScreenState();
}

class _ServiceAgreementScreenState extends ConsumerState<ServiceAgreementScreen> {
  final List<Map<String, String>> agreementList = [
    {
      "title": "서비스 이용약관",
      "url": "https://octagonal-expansion-359.notion.site/146e8511142480319139d2865e99063a?pvs=4",
    },
    {
      "title": "개인정보 처리방침",
      "url": "https://octagonal-expansion-359.notion.site/159e85111424809a9622ddf5d6cf6dd9?pvs=4",
    },
    {
      "title": "전자금융거래 이용약관",
      "url": "https://octagonal-expansion-359.notion.site/145e8511142480cbbe03fd7bf7326bed?pvs=4",
    },
    {
      "title": "싱그릿 식단 연구소 수신 동의",
      "url": "https://octagonal-expansion-359.notion.site/159e8511142480d5a3b6cc5f520969e3?pvs=4",
    },
    {
      "title": "부가 서비스 및 혜택 안내 동의",
      "url": "https://octagonal-expansion-359.notion.site/159e85111424807bb2f1eac76f44bcc2?pvs=4",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithLeftArrow(
        title: widget.title,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SGContainer(
        color: Colors.white,
        child: ListView.builder(
          itemCount: agreementList.length,
          itemBuilder: (context, index) {
            final agreement = agreementList[index];
            return Container(
              height: SGSpacing.p18,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: SGSpacing.p4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: SGColors.line1,
                    width: 1.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    agreement["title"]!,
                    style: const TextStyle(
                      fontSize: FontSize.normal,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final url = Uri.parse(agreement["url"]!);
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: SGColors.gray3,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
