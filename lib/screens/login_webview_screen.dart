// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:singleeat/core/components/action_button.dart';
import 'package:singleeat/core/components/app_bar_with_left_arrow.dart';
import 'package:singleeat/core/components/spacing.dart';
import 'package:singleeat/core/routers/app_routes.dart';
import 'package:singleeat/core/utils/file.dart';
import 'package:singleeat/main.dart';
import 'package:singleeat/office/providers/login_webview_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LoginWebViewScreen extends ConsumerStatefulWidget {
  const LoginWebViewScreen({super.key});

  @override
  ConsumerState<LoginWebViewScreen> createState() => _LoginWebViewScreenState();
}

class _LoginWebViewScreenState extends ConsumerState<LoginWebViewScreen> {
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
                  .read(loginWebViewNotifierProvider.notifier)
                  .onChangeIdentityVerificationId(identityVerificationId);
            } else if (url.contains('identity-verification-failed-redirect')) {
              ref
                  .read(loginWebViewNotifierProvider.notifier)
                  .onChangeStatus(LoginWebViewStatus.error);
            } else if (url.contains("identity-verification-success-redirect")) {
              ref
                  .read(loginWebViewNotifierProvider.notifier)
                  .onChangeStatus(LoginWebViewStatus.success);
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    Future.microtask(() async {
      ref
          .read(loginWebViewNotifierProvider.notifier)
          .onChangeStatus(LoginWebViewStatus.init);

      final state = ref.watch(loginWebViewNotifierProvider);
      controller.loadFile(await saveHtmlFile(state.html));
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginWebViewNotifierProvider);
    return Scaffold(
      appBar: AppBarWithLeftArrow(
          title: "로그인",
          onTap: () {
            context.pop(context);
          }),
      floatingActionButton: (state.status == LoginWebViewStatus.success ||
              state.status == LoginWebViewStatus.error)
          ? Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - SGSpacing.p8,
                  maxHeight: 58),
              child: SGActionButton(
                onPressed: () {
                  bool isStatus =
                      ref.read(loginWebViewNotifierProvider.notifier).onClick();
                  if (isStatus) {
                    context.pop(context);
                  } else {
                    context.go(AppRoutes.login);
                  }
                },
                disabled: false,
                label: (state.status == LoginWebViewStatus.success)
                    ? "다음"
                    : '로그인으로 돌아가기',
              ),
            )
          : const SizedBox.shrink(),
      body: WebViewWidget(controller: controller),
    );
  }
}
