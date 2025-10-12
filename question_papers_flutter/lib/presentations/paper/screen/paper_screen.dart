import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:question_papers_flutter/common/app_theme.dart';
import 'package:question_papers_flutter/common/shimmer_list.dart';
import 'package:question_papers_flutter/presentations/paper/controller/paper_controller.dart';
import 'package:question_papers_flutter/presentations/paper/widgets/paper_tile.dart';

class PaperScreen extends StatefulWidget {
  final String subjectId;
  final String subjectName;

  const PaperScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<PaperScreen> createState() => _PaperScreenState();
}

class _PaperScreenState extends State<PaperScreen> {
  final PaperController controller = Get.put(PaperController());
  bool showShimmer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWithAnimation();
    });
  }

  Future<void> _loadWithAnimation() async {
    setState(() => showShimmer = true);
    final start = DateTime.now();

    await controller.loadPapers(widget.subjectId);

    final diff = DateTime.now().difference(start);
    final delay = diff.inMilliseconds < 1000 ? 1000 - diff.inMilliseconds : 0;
    await Future.delayed(Duration(milliseconds: delay));

    if (mounted) setState(() => showShimmer = false);
  }

  String getYoutubeThumbnail(String url) {
    Uri uri = Uri.parse(url);
    if (uri.host.contains('youtu.be')) {
      return "https://img.youtube.com/vi/${uri.pathSegments[0]}/0.jpg";
    }
    return "https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.subjectName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: Obx(() {
        final papers = controller.papers;

        final questionPapers = papers
            .where((p) => p.pdfUrl.isNotEmpty)
            .toList();
        final masterPapers = papers
            .where((p) => p.masterPdfUrl != null)
            .toList();
        final videos = papers.where((p) => p.ytUrl != null).toList();

        return RefreshIndicator(
          onRefresh: _loadWithAnimation,
          color: Theme.of(context).colorScheme.primary,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: showShimmer
                ? ListView.separated(
                    key: const ValueKey('shimmer'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    itemCount: 6,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, __) => const ShimmerList(),
                  )
                : ListView(
                    key: const ValueKey('list'),
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 32, top: 16),
                    children: [
                      if (questionPapers.isNotEmpty) ...[
                        _buildSectionTitle(context, "Question Papers", isDark),
                        ...questionPapers.map(
                          (p) => PaperTile(
                            title: "Question Paper (${p.year})",
                            onTap: () => controller.openPdf(
                              p.pdfUrl,
                              title: "Question Paper (${p.year})",
                            ),
                          ),
                        ),
                      ],
                      if (masterPapers.isNotEmpty) ...[
                        _buildSectionTitle(context, "Master Papers", isDark),
                        ...masterPapers.map(
                          (p) => PaperTile(
                            title: "Master Paper (${p.year})",
                            onTap: () => controller.openPdf(
                              p.masterPdfUrl!,
                              title: "Master Paper (${p.year})",
                            ),
                          ),
                        ),
                      ],
                      if (videos.isNotEmpty) ...[
                        _buildSectionTitle(context, "Videos", isDark),
                        ...videos.map(
                          (p) => Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 6,
                            ),
                            height: 120,
                            child: InkWell(
                              onTap: () => controller.openYoutube(p.ytUrl!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppTheme.defaultRadius,
                                ),
                                child: Image.network(
                                  getYoutubeThumbnail(p.ytUrl!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? AppTheme.textColorDark : AppTheme.textColorLight,
        ),
      ),
    );
  }
}
