import 'package:flutter/material.dart';

/// 네트워크 이미지 뷰
class NetworkImageContainer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFEEEEEE),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        if (networkImageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(
              networkImageUrl,
              width: width,
              height: height,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                      child: SizedBox(
                        width: width / 4,
                        height: height / 4,
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return Container(
                  width: width,
                  height: height,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(borderRadius),
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
          ),
      ],
    );
  }
}
