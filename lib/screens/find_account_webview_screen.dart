import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/core/utils/file.dart';
import 'package:singleeat/main.dart';
import 'package:singleeat/office/providers/find_account_webview_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class FindAccountWebViewScreen extends ConsumerStatefulWidget {
  const FindAccountWebViewScreen({super.key});

  @override
  ConsumerState<FindAccountWebViewScreen> createState() =>
      _FindAccountWebViewScreenState();
}

class _FindAccountWebViewScreenState
    extends ConsumerState<FindAccountWebViewScreen> {
  late WebViewController controller = WebViewController();

  @override
  void initState() {
    PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    controller = WebViewController.fromPlatformCreationParams(params);

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (error) => logger.e(error.request?.uri),
          onPageFinished: (url) {},
          onNavigationRequest: (NavigationRequest request) {
            String url = request.url;
            final uri = Uri.parse(url);
            String identityVerificationId =
                uri.queryParameters['identityVerificationId'] ?? '';

            if (identityVerificationId.isNotEmpty) {
              ref
                  .read(findAccountWebViewNotifierProvider.notifier)
                  .onChangeIdentityVerificationId(identityVerificationId);
            } else if (url.contains(
                'identity/identity-verification-success-account-redirect')) {
              ref
                  .read(findAccountWebViewNotifierProvider.notifier)
                  .onChangeStatus(FindAccountWebViewStatus.success);
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    Future.microtask(() async {
      ref
          .read(findAccountWebViewNotifierProvider.notifier)
          .onChangeStatus(FindAccountWebViewStatus.init);

      final state = ref.watch(findAccountWebViewNotifierProvider);
      controller.loadFile(await saveHtmlFile(state.html));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(findAccountWebViewNotifierProvider);
    return Scaffold(
      appBar: AppBarWithLeftArrow(
        title: "아이디 찾기",
        onTap: () {
          context.pop(context);
        },
      ),
      floatingActionButton: (state.status == FindAccountWebViewStatus.success)
          ? Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                  maxHeight: 58),
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.findByPassword);
                    },
                    child: SGContainer(
                        color: SGColors.gray1,
                        padding: EdgeInsets.all(SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        child: Center(
                            child: SGTypography.body("비밀번호 찾기",
                                size: FontSize.large,
                                color: SGColors.gray5,
                                weight: FontWeight.w700))),
                  )),
                  SizedBox(width: SGSpacing.p3),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.login);
                    },
                    child: SGContainer(
                        color: SGColors.primary,
                        padding: EdgeInsets.all(SGSpacing.p4),
                        borderRadius: BorderRadius.circular(SGSpacing.p3),
                        child: Center(
                            child: SGTypography.body("로그인하기",
                                size: FontSize.large,
                                color: SGColors.white,
                                weight: FontWeight.w700))),
                  )),
                ],
              ))
          : const SizedBox.shrink(),
      body: WebViewWidget(controller: controller),
    );
  }
}
