import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// A responsive container that provides consistent max width and centering
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? (ResponsiveHelper.isDesktop(context) ? 1200 : double.infinity),
      ),
      child: child,
    );
  }
}

/// A responsive grid widget that adapts columns based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveHelper.getResponsiveCrossAxisCount(
      context,
      mobileCount: mobileColumns,
      tabletCount: tabletColumns,
      desktopCount: desktopColumns,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio ??
            ResponsiveHelper.getResponsiveCardAspectRatio(context),
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// A responsive card widget that adapts its size and content based on screen size
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        padding ?? ResponsiveHelper.getResponsivePadding(context);
    final responsiveMargin = margin ?? const EdgeInsets.all(8);
    final responsiveElevation =
        elevation ?? (ResponsiveHelper.isDesktop(context) ? 4 : 2);
    final responsiveBorderRadius = borderRadius ??
        BorderRadius.circular(
          ResponsiveHelper.isDesktop(context) ? 16 : 12,
        );
  
    return Container(
      margin: responsiveMargin,
      child: Card(
        elevation: responsiveElevation,
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: responsiveBorderRadius,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: responsiveBorderRadius,
          child: Padding(
            padding: responsivePadding,
            child: child,
          ),
        ),
      ),
    );
  }
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final ResponsiveTextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? customFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.type = ResponsiveTextType.body,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.customFontSize,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize;

    if (customFontSize != null) {
      fontSize = customFontSize!;
    } else {
      switch (type) {
        case ResponsiveTextType.header:
          fontSize = ResponsiveHelper.getResponsiveHeaderFontSize(context);
          break;
        case ResponsiveTextType.title:
          fontSize = ResponsiveHelper.getResponsiveTitleFontSize(context);
          break;
        case ResponsiveTextType.body:
          fontSize = ResponsiveHelper.getResponsiveBodyFontSize(context);
          break;
      }
    }
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
enum ResponsiveTextType {
  header,
  title,
  body,
}
/// A responsive button widget that adapts its size based on screen size
class ResponsiveButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final double? elevation;
  final bool isOutlined;
  final double? width;

  const ResponsiveButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.isOutlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final responsivePadding =
        padding ?? ResponsiveHelper.getResponsiveButtonPadding(context);
    final responsiveBorderRadius = borderRadius ??
        BorderRadius.circular(
          ResponsiveHelper.isDesktop(context) ? 12 : 8,
        );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor,
              padding: responsivePadding,
              shape: RoundedRectangleBorder(
                borderRadius: responsiveBorderRadius,
              ),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              padding: responsivePadding,
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: responsiveBorderRadius,
              ),
            ),
            child: child,
          );

    return width != null
        ? SizedBox(
            width: width,
            height: 48,
            child: button,
          )
        : SizedBox(
            height: 48,
            child: button,
          );
  }
}

/// A responsive scaffold that handles different layouts automatically
class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final Widget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar as PreferredSizeWidget?,
      drawer: drawer,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: body,
      ),
    );
  }
}

/// A responsive app bar that adapts its height and content based on screen size
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final Color? backgroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;

  const ResponsiveAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.backgroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: actions,
      leading: leading,
      backgroundColor: backgroundColor,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: ResponsiveHelper.getResponsiveNavigationHeight(context),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(65);
}