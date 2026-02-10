import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/base/image_upload_service.dart';

class ImagePickerField extends StatefulWidget {
  final String? imageUrl;
  final Function(String?) onImageSelected;
  final String label;

  const ImagePickerField({
    super.key,
    this.imageUrl,
    required this.onImageSelected,
    this.label = 'Image',
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  final ImageUploadService _uploadService = ImageUploadService();
  bool _isUploading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    try {
      if (!mounted) return;
      setState(() => _isUploading = true);

      // Determine folder from label (e.g., "Category Image" -> "categories")
      final folder = widget.label.toLowerCase().contains('category')
          ? 'categories'
          : 'products';

      final downloadUrl = await _uploadService.pickAndUploadImage(folder);

      if (!mounted) return;

      if (downloadUrl != null) {
        setState(() {
          _currentImageUrl = downloadUrl;
          _isUploading = false;
        });
        widget.onImageSelected(downloadUrl);
      } else {
        setState(() => _isUploading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isUploading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: $e'),
            backgroundColor: ColorManager.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    if (!mounted) return;
    setState(() => _currentImageUrl = null);
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: ColorManager.black,
          ),
        ),
        SizedBox(height: 8.h),
        // Image upload / preview area
        InkWell(
          onTap: _isUploading ? null : _pickAndUploadImage,
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 300.h,
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: ColorManager.grey300,
                style: BorderStyle.solid,
              ),
            ),
            child: _isUploading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorManager.mainColor,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Uploading...',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorManager.black,
                          ),
                        ),
                      ],
                    ),
                  )
                : _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                ? Stack(
                    children: [
                      // Image preview
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          _currentImageUrl!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 48.sp,
                                color: ColorManager.black,
                              ),
                            );
                          },
                        ),
                      ),
                      // Remove button
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: IconButton(
                          onPressed: _removeImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: ColorManager.black,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 64.sp,
                        color: ColorManager.black,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Click to upload image',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.black,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'PNG, JPG, WEBP up to 5MB',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorManager.black,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
