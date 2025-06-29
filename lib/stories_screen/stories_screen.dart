import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_view/story_view.dart';

class StoryScreen extends StatefulWidget {
  final String imageUrl;
  final String? userName;
  final String? userProfileImage;
  final String? timeStamp;
  final List<String>? storyUrls; // Support for multiple stories
  final int initialIndex;

  StoryScreen({
    super.key,
    required this.imageUrl,
    this.userName,
    this.userProfileImage,
    this.timeStamp,
    this.storyUrls,
    this.initialIndex = 0,
  });

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin {
  final StoryController _storyController = StoryController();
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  bool _isHeaderVisible = true;
  bool _isPaused = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _initializeAnimations();
    _hideHeaderAfterDelay();

    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
      ),
    );
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    ));

    _headerAnimationController.forward();
  }

  void _hideHeaderAfterDelay() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted && _isHeaderVisible) {
        _toggleHeaderVisibility();
      }
    });
  }

  void _toggleHeaderVisibility() {
    setState(() {
      _isHeaderVisible = !_isHeaderVisible;
    });

    if (_isHeaderVisible) {
      _headerAnimationController.forward();
      _hideHeaderAfterDelay();
    } else {
      _headerAnimationController.reverse();
    }
  }

  void _handleStoryTap(TapUpDetails details) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tapPosition = details.globalPosition.dx;

    if (tapPosition < screenWidth * 0.3) {
      // Left side tap - previous story
      _storyController.previous();
    } else if (tapPosition > screenWidth * 0.7) {
      // Right side tap - next story
      _storyController.next();
    } else {
      // Center tap - toggle header visibility
      _toggleHeaderVisibility();
    }
  }

  void _handleLongPress() {
    setState(() {
      _isPaused = true;
    });
    _storyController.pause();
    HapticFeedback.lightImpact();
  }

  void _handleLongPressEnd() {
    setState(() {
      _isPaused = false;
    });
    _storyController.play();
  }

  List<StoryItem> _buildStoryItems() {
    List<String> urls = widget.storyUrls ?? [widget.imageUrl];

    return urls.map((url) {
      if (url.toLowerCase().contains('.mp4') ||
          url.toLowerCase().contains('.mov') ||
          url.toLowerCase().contains('.avi')) {
        // Video story
        return StoryItem.pageVideo(
          url,
          controller: _storyController,
          duration: Duration(seconds: 10),
        );
      } else {
        // Image story
        return StoryItem.pageImage(
          url: url,
          controller: _storyController,
          duration: Duration(seconds: 5),
        );
      }
    }).toList();
  }

  @override
  void dispose() {
    _storyController.dispose();
    _headerAnimationController.dispose();

    // Reset system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Story View
          GestureDetector(
            onTapUp: _handleStoryTap,
            onLongPress: _handleLongPress,
            onLongPressEnd: (_) => _handleLongPressEnd(),
            child: StoryView(
              storyItems: _buildStoryItems(),
              controller: _storyController,
              inline: false,
              repeat: false,
              onComplete: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              onStoryShow: (s, index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
          ),

          // Header with user info
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -50 * (1 - _headerAnimation.value)),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: _buildStoryHeader(),
                ),
              );
            },
          ),

          // Pause indicator
          if (_isPaused)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Paused',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Story indicators (custom progress bars)
          if (widget.storyUrls != null && widget.storyUrls!.length > 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 60.h,
              left: 16.w,
              right: 16.w,
              child: _buildStoryIndicators(),
            ),

          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 16.w,
            child: AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _headerAnimation.value,
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Instructions overlay (shows briefly on first load)
          _buildInstructionsOverlay(),
        ],
      ),
    );
  }

  Widget _buildStoryHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black.withOpacity(0.3),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.w,
              ),
            ),
            child: CircleAvatar(
              radius: 20.r,
              backgroundColor: Colors.grey[800],
              backgroundImage: widget.userProfileImage != null
                  ? NetworkImage(widget.userProfileImage!)
                  : null,
              child: widget.userProfileImage == null
                  ? Icon(
                Icons.person,
                color: Colors.white,
                size: 20.sp,
              )
                  : null,
            ),
          ),

          SizedBox(width: 12.w),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName ?? 'Unknown User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.timeStamp != null)
                  Text(
                    widget.timeStamp!,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12.sp,
                    ),
                  ),
              ],
            ),
          ),

          // More options
          GestureDetector(
            onTap: () {
              _showMoreOptions();
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryIndicators() {
    if (widget.storyUrls == null || widget.storyUrls!.length <= 1) {
      return SizedBox.shrink();
    }

    return Row(
      children: List.generate(
        widget.storyUrls!.length,
            (index) => Expanded(
          child: Container(
            height: 2.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: index < _currentIndex
                  ? Colors.white
                  : index == _currentIndex
                  ? Colors.white.withOpacity(0.7)
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsOverlay() {
    return AnimatedOpacity(
      opacity: 0.0, // You can make this visible initially and fade out
      duration: Duration(milliseconds: 500),
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.touch_app,
                  color: Colors.white,
                  size: 40.sp,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Story Controls',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInstructionItem(Icons.touch_app, 'Tap left/right to navigate'),
                _buildInstructionItem(Icons.touch_app, 'Tap center to hide/show info'),
                _buildInstructionItem(Icons.pan_tool, 'Hold to pause'),
                _buildInstructionItem(Icons.swipe, 'Swipe down to close'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.8),
            size: 16.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            _buildBottomSheetItem(Icons.report, 'Report Story'),
            _buildBottomSheetItem(Icons.block, 'Block User'),
            _buildBottomSheetItem(Icons.share, 'Share Story'),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Implement functionality
      },
    );
  }
}