import 'package:flutter/material.dart';
import 'package:singleeat/main.dart';

/// 네트워크 이미지 뷰
class NetworkImageContainer extends StatefulWidget {
  final String networkImageUrl;
  final double width;
  final double height;
  final double borderRadius;

  const NetworkImageContainer({
    super.key,
    required this.networkImageUrl, // 필수 파라미터
    this.width = 80.0, // 기본값
    this.height = 80.0, // 기본값
    this.borderRadius = 8.0, // 기본값
  });

  @override
  State<NetworkImageContainer> createState() => _NetworkImageContainerState();
}

class _NetworkImageContainerState extends State<NetworkImageContainer> {
  String imageUrl = '';

  @override
  void didUpdateWidget(covariant NetworkImageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // image rebuild
    if (widget.networkImageUrl != oldWidget.networkImageUrl) {
      imageUrl = widget.networkImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
        if (imageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Image.network(
              imageUrl,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Center(
                      child: SizedBox(
                        width: widget.width / 4,
                        height: widget.height / 4,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                }
              },
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return Container(
                  width: widget.width,
                  height: widget.height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: const Text(
                    "이미지 로드 실패",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          )
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Image.asset(
              'assets/images/home-store.png',
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          )
      ],
    );
  }
}
