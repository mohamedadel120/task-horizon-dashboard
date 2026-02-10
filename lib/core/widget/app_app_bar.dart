import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/constants/assets/app_icons.dart';

class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onActionPressed;
  final Color? backgroundColor;
  final double? elevation;
  final bool centerTitle;
  final IconData? leadingIcon;
  final IconData? actionIcon;
  final String? actionText;
  final bool showBackButton;
  final bool showNotificationIcon;
  final bool showMenuIcon;

  const AppAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.onLeadingPressed,
    this.onActionPressed,
    this.backgroundColor,
    this.elevation,
    this.centerTitle = false,
    this.leadingIcon,
    this.actionIcon,
    this.actionText,
    this.showBackButton = false,
    this.showNotificationIcon = false,
    this.showMenuIcon = false,
  }) : assert(
         title == null || titleWidget == null,
         'Cannot provide both title and titleWidget',
       );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? ColorManager.primaryBackground,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading: _buildLeading(context),
      title: _buildTitle(),
      actions: _buildActions(context),
      iconTheme: IconThemeData(
        color: backgroundColor == ColorManager.orange ? Colors.white : null,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton) {
      final iconColor = backgroundColor == ColorManager.orange
          ? Colors.white
          : null;
      return IconButton(
        onPressed:
            onLeadingPressed ??
            () {
              try {
                final router = GoRouter.of(context);
                if (router.canPop()) {
                  router.pop();
                } else {
                  context.pop();
                }
              } catch (e) {
                context.pop();
              }
            },
        icon: Icon(Icons.arrow_back, color: iconColor),
      );
    }

    if (leadingIcon != null) {
      return Padding(
        padding: EdgeInsets.only(left: 10.w),
        child: IconButton(onPressed: onLeadingPressed, icon: Icon(leadingIcon)),
      );
    }

    // // if (showNotificationIcon) {
    //   return Padding(
    //     padding: EdgeInsets.only(left: 10.w),
    //     child: _buildNotificationIcon(context),
    //   );
    // }// }

    return null;
  }

  Widget? _buildTitle() {
    if (titleWidget != null) return titleWidget;

    if (title != null) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          title!,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
        ),
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions != null) return actions;

    final actionWidgets = <Widget>[];

    if (actionIcon != null) {
      actionWidgets.add(SvgPicture.asset(AppIcons.Menue));
    }

    if (actionText != null) {
      actionWidgets.add(
        TextButton(onPressed: onActionPressed, child: Text(actionText!)),
      );
    }

    if (showMenuIcon) {
      actionWidgets.add(
        GestureDetector(
          onTap: onActionPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: ColorManager.primaryBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: SvgPicture.asset(AppIcons.Menue),
          ),
        ),
      );
    }

    return actionWidgets.isNotEmpty ? actionWidgets : null;
  }

  // Widget _buildNotificationIcon(BuildContext context) {
  //   return Builder(
  //     builder: (builderContext) {
  //       try {
  //         // Try to get the cubit from the widget tree
  //         final cubit = builderContext.read<NotificationsCubit>();
  //         return BlocBuilder<NotificationsCubit, NotificationsState>(
  //           builder: (context, state) {
  //             final unreadCount = cubit.unreadCount;

  //             return IconButton(
  //               onPressed: onLeadingPressed,
  //               icon: Stack(
  //                 clipBehavior: Clip.none,
  //                 children: [
  //                   SvgPicture.asset(AppIcons.NOTIFICATION),
  //                   if (unreadCount > 0)
  //                     Positioned(
  //                       right: -4.w,
  //                       top: -4.h,
  //                       child: Container(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 4.w,
  //                           vertical: 2.h,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           color: ColorManager.orange,
  //                           shape: BoxShape.circle,
  //                           border: Border.all(
  //                             color: ColorManager.white,
  //                             width: 1.5,
  //                           ),
  //                         ),
  //                         constraints: BoxConstraints(
  //                           minWidth: 16.w,
  //                           minHeight: 16.h,
  //                         ),
  //                         child: Center(
  //                           child: Text(
  //                             unreadCount > 99 ? '99+' : unreadCount.toString(),
  //                             style: TextStyles.font10WhiteSemiBold,
  //                             textAlign: TextAlign.center,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       } catch (e) {
  //         // If cubit is not available, just show the icon without badge
  //         return IconButton(
  //           onPressed: onLeadingPressed,
  //           icon: const Icon(Icons.notifications),
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Convenience constructors for common use cases
class AppAppBarWithNotification extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onMenuPressed;
  final Color? backgroundColor;

  const AppAppBarWithNotification({
    super.key,
    this.title,
    this.onNotificationPressed,
    this.onMenuPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      title: title,
      showNotificationIcon: true,
      showMenuIcon: true,
      onLeadingPressed: onNotificationPressed,
      onActionPressed: onMenuPressed,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppAppBarWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppAppBarWithBack({
    super.key,
    this.title,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      title: title,
      showBackButton: true,
      onLeadingPressed: onBackPressed,
      actions: actions,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
