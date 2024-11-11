// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:singleeat/core/components/container.dart';
import 'package:singleeat/core/components/dialog.dart';
import 'package:singleeat/core/components/sizing.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/components/typography.dart';
import 'package:singleeat/core/constants/colors.dart';
import 'package:singleeat/core/utils/file.dart';
import 'package:singleeat/main.dart';
import 'package:singleeat/office/providers/webview_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  const WebViewScreen({super.key});

  @override
  ConsumerState<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
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
                  .read(webViewNotifierProvider.notifier)
                  .onChangeIdentityVerificationId(identityVerificationId);
            } else if (url.contains('identity-verification-failed-redirect')) {
              ref.read(webViewNotifierProvider.notifier).onChangeStatus(
                  status: WebViewStatus.error,
                  errorMessage: uri.queryParameters['errorMessage'] ?? '');
            } else if (url.contains("identity-verification-success-redirect")) {
              ref
                  .read(webViewNotifierProvider.notifier)
                  .onChangeStatus(status: WebViewStatus.success);
            } else if (url
                .contains('identity-verification-success-account-redirect')) {
              // 아이디 찾기는 redirect http가 온다? > https로 수정해야함
              // String path = url.replaceAll('http://', 'https://');
              // controller.loadRequest(Uri.parse(path));
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    Future.microtask(() async {
      ref
          .read(webViewNotifierProvider.notifier)
          .onChangeStatus(status: WebViewStatus.init);
      final state = ref.watch(webViewNotifierProvider);
      controller.loadFile(await saveHtmlFile(state.html));
    });
  }

  void showFailDialogWithImage({
    required String mainTitle,
    String subTitle = '',
  }) {
    showSGDialogWithImage(
        context: context,
        childrenBuilder: (ctx) => [
              if (subTitle.isEmpty) ...[
                Center(
                    child: SGTypography.body(mainTitle,
                        size: FontSize.medium,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: SGContainer(
                    color: SGColors.primary,
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("확인",
                            color: SGColors.white,
                            weight: FontWeight.w700,
                            size: FontSize.normal)),
                  ),
                )
              ] else ...[
                Center(
                    child: SGTypography.body(mainTitle,
                        size: FontSize.medium,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p4),
                Center(
                    child: SGTypography.body(subTitle,
                        color: SGColors.gray4,
                        size: FontSize.small,
                        weight: FontWeight.w700,
                        lineHeight: 1.25,
                        align: TextAlign.center)),
                SizedBox(height: SGSpacing.p6),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                  child: SGContainer(
                    color: SGColors.primary,
                    width: double.infinity,
                    borderColor: SGColors.primary,
                    padding: EdgeInsets.symmetric(vertical: SGSpacing.p5),
                    borderRadius: BorderRadius.circular(SGSpacing.p3),
                    child: Center(
                        child: SGTypography.body("확인",
                            color: SGColors.white,
                            weight: FontWeight.w700,
                            size: FontSize.normal)),
                  ),
                )
              ]
            ]);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(webViewNotifierProvider, (previous, next) {
      if (previous?.status != next.status) {
        if (next.status == WebViewStatus.success) {
          Navigator.of(context).pop();
        } else if (next.status == WebViewStatus.error &&
            next.error.errorMessage.isNotEmpty) {
          Navigator.of(context).pop();
          showFailDialogWithImage(mainTitle: next.error.errorMessage);
        }
      }
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
