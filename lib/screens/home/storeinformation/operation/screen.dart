import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/multiple_information_box.dart';
import 'package:singleeat/core/components/selection_bottom_sheet.dart';
import 'package:singleeat/core/components/single_information_box.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/text_field_wrapper.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/screens/home/storeinformation/operation/emailchange/screen.dart';
import 'package:singleeat/screens/home/storeinformation/operation/phonechange/screen.dart';
import 'package:singleeat/screens/home/storeinformation/operation/provider.dart';

class StoreInformationScreen extends ConsumerStatefulWidget {
  const StoreInformationScreen({super.key});

  @override
  ConsumerState<StoreInformationScreen> createState() =>
      _StoreInformationScreenState();


}

class BusinessInformationDataTableRow extends StatelessWidget {
  const BusinessInformationDataTableRow({super.key, required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SGTypography.body(
          left,
          color: SGColors.gray4,
          weight: FontWeight.w500,
          size: FontSize.small,
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 129,
          child: SGTypography.body(
            right,
            color: SGColors.gray5,
            weight: FontWeight.w500,
            size: FontSize.small,
            align: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _StoreInformationScreenState
    extends ConsumerState<StoreInformationScreen> {
  String phoneNumber = "010-1234-5678";
  String email = "no-reply@aaa.bbb";

  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(storeInformationNotifierProvider.notifier)
          .getBusinessInformation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeInformationNotifierProvider);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWithLeftArrow(title: '사업자 정보'),
        body: SGContainer(
          color: Color(0xFFFAFAFA),
          padding: EdgeInsets.symmetric(
              horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
          child: Builder(builder: (ctx) {
            return ListView(
              shrinkWrap: true,
              children: [
                SGTypography.label("운영 상태"),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                SingleInformationBox(label: '영업', editable: false),
                SizedBox(height: SGSpacing.p8),
                SGTypography.label("대표님 연락처"),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                GestureDetector(
                    child: SingleInformationBox(
                        label: '전화번호',
                        value: state.storeInformation.ownerPhoneNumber,
                        editable: true),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhoneEditScreen(
                              value: state.storeInformation.ownerPhoneNumber,
                              title: "사장님 전화번호 변경",
                              hintText: "연락처를 입력해주세요.",
                              buttonText: "변경하기",
                              onSubmit: (value) {
                                setState(() {
                                  phoneNumber = value;
                                });
                              })));
                    }),
                SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
                GestureDetector(
                    child: SingleInformationBox(
                        label: '이메일',
                        value: state.storeInformation.ownerEmail,
                        editable: true),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EmailEditScreen(
                              value: state.storeInformation.ownerEmail,
                              title: "이메일 변경",
                              hintText: "이메일을 입력해주세요.",
                              buttonText: "변경하기",
                              onSubmit: (value) {
                                setState(() {
                                  email = value;
                                });
                              })));
                    }),
                SizedBox(height: SGSpacing.p8),
                MultipleInformationBox(children: [
                  Row(children: [
                    SGTypography.body("사업자 정보",
                        size: FontSize.normal, weight: FontWeight.w700),
                    SizedBox(width: SGSpacing.p1),
                    GestureDetector(
                        child: const Icon(Icons.edit, size: FontSize.small),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => _EditBusinessProfileScreen()));
                        }),
                  ]),
                  SizedBox(height: SGSpacing.p5),
                  BusinessInformationDataTableRow(
                      left: "대표자 구분",
                      right: state.storeInformation.representativeType),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "사업자 이름",
                      right: state.storeInformation.businessName),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "사업자등록번호",
                      right: state.storeInformation.businessNumber),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "세금신고자료 발행정보",
                      right: state.storeInformation.taxReportingInformation),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "매출 규모 분류",
                      right: state.storeInformation.salesScaleClassification),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "사업자 구분",
                      right: state.storeInformation.businessType),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "업태",
                      right: state.storeInformation.businessActivityStatus),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "종목",
                      right: state.storeInformation.businessCategory),
                  DATA_TABLE_DIVIDER(),
                  SGTypography.body("소재지",
                      size: FontSize.small, weight: FontWeight.w600),
                  SizedBox(height: SGSpacing.p5),
                  BusinessInformationDataTableRow(
                      left: "우편번호", right: state.storeInformation.postalCode),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "기본 주소", right: state.storeInformation.baseAddress),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "지번 주소", right: state.storeInformation.lotAddress),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "상세 주소",
                      right: state.storeInformation.detailAddress),
                ]),
                SizedBox(height: SGSpacing.p8),
                MultipleInformationBox(children: [
                  SGTypography.body("영업신고증 정보",
                      size: FontSize.normal, weight: FontWeight.w700),
                  SizedBox(height: SGSpacing.p5),
                  BusinessInformationDataTableRow(
                      left: "영업신고증 고유번호",
                      right: state.storeInformation.businessRegistrationNumber),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "대표자명", right: state.storeInformation.ceoName),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "영업소 명칭", right: state.storeInformation.storeName),
                  DATA_TABLE_DIVIDER(),
                  SGTypography.body("소재지",
                      size: FontSize.small, weight: FontWeight.w600),
                  SizedBox(height: SGSpacing.p5),
                  BusinessInformationDataTableRow(
                      left: "우편번호", right: state.storeInformation.postalCode),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "기본 주소", right: state.storeInformation.baseAddress),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "지번 주소", right: state.storeInformation.lotAddress),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "상세 주소",
                      right: state.storeInformation.detailAddress),
                  DATA_TABLE_DIVIDER(),
                  BusinessInformationDataTableRow(
                      left: "영업의 종류",
                      right: state.storeInformation.operationType),
                  SizedBox(height: SGSpacing.p4),
                  BusinessInformationDataTableRow(
                      left: "통신판매신고증 정보",
                      right: state
                          .storeInformation.ecommerceRegistrationInformation),
                ]),
                SizedBox(height: SGSpacing.p20),
              ],
            );
          }),
        ));
  }
}

class _EditBusinessProfileScreen extends ConsumerStatefulWidget {
  const _EditBusinessProfileScreen({super.key});

  @override
  ConsumerState<_EditBusinessProfileScreen> createState() =>
      _EditBusinessProfileScreenState();
}

class _EditBusinessProfileScreenState
    extends ConsumerState<_EditBusinessProfileScreen> {
  String businessType = "0";
  var selectionOption;
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(storeInformationNotifierProvider.notifier)
          .getBusinessInformation();
    });
  }

  List<SelectionOption<String>> businessTypeOptions = [
    SelectionOption(label: "일반 과세자", value: "0"),
    SelectionOption(label: "간이 과세자", value: "1"),
    SelectionOption(label: "법인 과세자", value: "2"),
    SelectionOption(label: "부가가치세 면세 사업자", value: "3"),
    SelectionOption(label: "면세법인 사업자", value: "4"),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeInformationNotifierProvider);
    final provider = ref.read(storeInformationNotifierProvider.notifier);
    return Scaffold(
        appBar: AppBarWithLeftArrow(title: "사업자 정보"),
        body: SGContainer(
            color: Color(0xFFFAFAFA),
            padding: EdgeInsets.symmetric(
                horizontal: SGSpacing.p4, vertical: SGSpacing.p5),
            child: ListView(children: [
              SGTypography.label("사업자 등록 번호"),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4,
                    vertical: SGSpacing.p4 + SGSpacing.p05),
                child: SGTypography.body(state.storeInformation.businessNumber,
                    size: FontSize.normal,
                    weight: FontWeight.w400,
                    color: SGColors.gray3),
              )),
              // TODO:
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("사업자 구분 변경"),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              GestureDetector(
                onTap: () {
                  showSelectionBottomSheet<String>(
                      context: context,
                      title: "사업자 구분을 선택해주세요.",
                      options: businessTypeOptions,
                      onSelect: (value) {
                        setState(() {
                          businessType = value;
                        });
                      },
                      selected: businessType);
                },
                child: SGTextFieldWrapper(
                    child: SGContainer(
                  padding: EdgeInsets.symmetric(
                      horizontal: SGSpacing.p4,
                      vertical: SGSpacing.p4 + SGSpacing.p05),
                  child: Row(children: [
                    SGTypography.body(
                        businessTypeOptions[int.parse(businessType)].label,
                        color: SGColors.black,
                        size: FontSize.normal,
                        weight: FontWeight.w500),
                    Spacer(),
                    Image.asset('assets/images/dropdown-arrow.png',
                        width: 16, height: 16),
                  ]),
                )),
              ),
              // TODO:
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("업태"),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4,
                    vertical: SGSpacing.p4 + SGSpacing.p05),
                child: Row(children: [
                  SGTypography.body(
                      state.storeInformation.businessActivityStatus,
                      size: FontSize.normal,
                      weight: FontWeight.w400,
                      color: SGColors.gray3),
                ]),
              )),
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("종목"),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              SGTextFieldWrapper(
                  child: SGContainer(
                padding: EdgeInsets.symmetric(
                    horizontal: SGSpacing.p4,
                    vertical: SGSpacing.p4 + SGSpacing.p05),
                child: Row(children: [
                  SGTypography.body(state.storeInformation.businessCategory,
                      size: FontSize.normal,
                      weight: FontWeight.w400,
                      color: SGColors.gray3),
                ]),
              )),
              // TODO:
              SizedBox(height: SGSpacing.p8),
              SGTypography.label("소재지"),
              SizedBox(height: SGSpacing.p2 + SGSpacing.p05),
              MultipleInformationBox(children: [
                BusinessInformationDataTableRow(
                    left: "우편번호", right: state.storeInformation.postalCode),
                SizedBox(height: SGSpacing.p4),
                BusinessInformationDataTableRow(
                    left: "기본 주소", right: state.storeInformation.baseAddress),
                SizedBox(height: SGSpacing.p4),
                BusinessInformationDataTableRow(
                    left: "지번 주소", right: state.storeInformation.lotAddress),
                SizedBox(height: SGSpacing.p4),
                BusinessInformationDataTableRow(
                    left: "상세 주소", right: state.storeInformation.detailAddress),
              ]),
              SizedBox(height: SGSpacing.p15),
              SGActionButton(
                  onPressed: () {
                    provider.updateBusinessInformation(int.parse(businessType));
                  },
                  label: "변경하기")
            ])));
  }
}
