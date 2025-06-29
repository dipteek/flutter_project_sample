import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:reel_app/comment_screen/comment_screen.dart';
import 'package:reel_app/convert.dart';
import 'package:reel_app/home_screen/home_function.dart';
import 'package:reel_app/model_classes/reel_model.dart';
import 'package:reel_app/profile_screen/profile_screen_ui_up.dart';
import 'package:video_player/video_player.dart';

class ReelScreenView extends StatefulWidget {
  final ReelModel reelsModel;
  ReelScreenView({super.key, required this.reelsModel});

  @override
  State<ReelScreenView> createState() => _ReelScreenViewState();
}

class _ReelScreenViewState extends State<ReelScreenView>
    with TickerProviderStateMixin {
  late VideoPlayerController videoController;
  late AnimationController _likeAnimationController;
  late AnimationController _pauseAnimationController;
  late Animation<double> _likeAnimation;
  late Animation<double> _pauseAnimation;

  bool isLoading = true;
  bool isBackPlay = false;
  bool isAlreadyLike = false;
  bool showLikeAnimation = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    checkIfAlready();
    initializeVideo();
    _hideControlsTimer();
  }

  void _initializeAnimations() {
    _likeAnimationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _pauseAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _likeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _likeAnimationController, curve: Curves.elasticOut),
    );

    _pauseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pauseAnimationController, curve: Curves.easeInOut),
    );
  }

  void _hideControlsTimer() {
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _hideControlsTimer();
  }

  void initializeVideo() {
    videoController = VideoPlayerController.network(widget.reelsModel.videoLink);
    videoController.initialize().then((value) {
      setState(() {
        isLoading = false;
      });
      videoController.play();
      videoController.setLooping(true);
    });
  }

  Future<void> checkIfAlready() async {
    isAlreadyLike = await HomeFunction.isAlreadyLiked(widget.reelsModel.id);
    if (mounted) setState(() {});
  }

  void _handleDoubleTap() {
    HapticFeedback.lightImpact();
    if (!isAlreadyLike) {
      setState(() {
        widget.reelsModel.likes = widget.reelsModel.likes + 1;
        isAlreadyLike = true;
        showLikeAnimation = true;
      });
      HomeFunction.onLikeOrUnLike(widget.reelsModel.id, true);
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reset();
        setState(() {
          showLikeAnimation = false;
        });
      });
    }
  }

  void _togglePlayPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
      setState(() {
        isBackPlay = true;
      });
      _pauseAnimationController.forward();
    } else {
      videoController.play();
      setState(() {
        isBackPlay = false;
      });
      _pauseAnimationController.reverse();
    }
    HapticFeedback.selectionClick();
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    if (isAlreadyLike) {
      setState(() {
        widget.reelsModel.likes = widget.reelsModel.likes - 1;
        isAlreadyLike = false;
      });
      HomeFunction.onLikeOrUnLike(widget.reelsModel.id, false);
    } else {
      setState(() {
        widget.reelsModel.likes = widget.reelsModel.likes + 1;
        isAlreadyLike = true;
      });
      HomeFunction.onLikeOrUnLike(widget.reelsModel.id, true);
    }
  }

  @override
  void dispose() {
    videoController.dispose();
    _likeAnimationController.dispose();
    _pauseAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            // Video Player
            GestureDetector(
              onTap: () {
                _showControlsTemporarily();
                _togglePlayPause();
              },
              onDoubleTap: _handleDoubleTap,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black,
                child: isLoading
                    ? _buildLoadingIndicator()
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  ),
                ),
              ),
            ),

            // Like Animation Overlay
            if (showLikeAnimation)
              Center(
                child: AnimatedBuilder(
                  animation: _likeAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _likeAnimation.value,
                      child: Opacity(
                        opacity: 1.0 - _likeAnimation.value,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 120.sp,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Pause Overlay
            if (isBackPlay)
              Center(
                child: AnimatedBuilder(
                  animation: _pauseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pauseAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 50.sp,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Bottom Gradient and Content
            Positioned(
              bottom: 0,
              child: Container(
                height: 200.h,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: _buildBottomContent(),
              ),
            ),

            // Side Actions
            Positioned(
              bottom: 80.h,
              right: 10.w,
              child: _buildSideActions(),
            ),

            // Top Actions
            if (_showControls)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 15,
                child: _buildTopActions(),
              ),

            // Progress Indicator
            if (!isLoading)
              Positioned(
                bottom: 0,
                child: _buildProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 3,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading video...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomContent() {
    return Padding(
      padding: EdgeInsets.only(
        top: 100.h,
        left: 15.w,
        right: 70.w,
        bottom: 20.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          GestureDetector(
            onTap: () => _navigateToProfile(widget.reelsModel.uid),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.grey[800],
                    backgroundImage: widget.reelsModel.profileImage.isNotEmpty
                        ? NetworkImage(widget.reelsModel.profileImage)
                        : null,
                    child: widget.reelsModel.profileImage.isEmpty
                        ? Icon(Icons.person, color: Colors.white, size: 20.sp)
                        : null,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reelsModel.username,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      // Text(
                      //   '2 hours ago', // You can add timestamp to your model
                      //   style: TextStyle(
                      //     color: Colors.white.withOpacity(0.7),
                      //     fontSize: 12.sp,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // Title/Description
          if (widget.reelsModel.title.isNotEmpty)
            Text(
              widget.reelsModel.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSideActions() {
    return Column(
      children: [
        // Like Button
        _buildActionButton(
          icon: isAlreadyLike ? Icons.favorite : Icons.favorite_border,
          color: isAlreadyLike ? Colors.red : Colors.white,
          count: widget.reelsModel.likes,
          onTap: _handleLike,
        ),

        SizedBox(height: 20.h),

        // Comment Button
        _buildActionButton(
          icon: Icons.chat_bubble_outline,
          color: Colors.white,
          count: 0, // You can add comment count to your model
          onTap: () => _navigateToComments(),
        ),

        SizedBox(height: 20.h),

        // Share Button
        _buildActionButton(
          icon: Icons.share,
          color: Colors.white,
          onTap: () {
            // Implement share functionality
            HapticFeedback.lightImpact();
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    int? count,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28.sp,
            ),
          ),
        ),
        if (count != null && count > 0) ...[
          SizedBox(height: 4.h),
          Text(
            _formatCount(count),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTopActions() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: IconButton(
        onPressed: () => _navigateToProfile(FirebaseAuth.instance.currentUser!.uid),
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 3.h,
      child: VideoProgressIndicator(
        videoController,
        allowScrubbing: true,
        colors: VideoProgressColors(
          playedColor: primaryColor,
          backgroundColor: Colors.white.withOpacity(0.3),
          bufferedColor: Colors.white.withOpacity(0.6),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  void _navigateToProfile(String userId) {
    videoController.pause();
    setState(() {
      isBackPlay = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreenUiUp(UserId: userId),
      ),
    ).then((_) {
      // Resume video when returning
      if (mounted && !isBackPlay) {
        videoController.play();
      }
    });
  }

  void _navigateToComments() {
    videoController.pause();
    setState(() {
      isBackPlay = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentScreenUI(reelId: widget.reelsModel.id),
      ),
    ).then((_) {
      // Resume video when returning
      if (mounted && !isBackPlay) {
        videoController.play();
      }
    });
  }
}