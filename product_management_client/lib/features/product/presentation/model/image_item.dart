import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum ImageType { existing, newFile }

class ImageItem {
  final String id;
  final ImageType type;
  final String? url;
  final File? file;
  final XFile? xFile;
  final String displayName;

  ImageItem({
    required this.id,
    required this.type,
    this.url,
    this.file,
    this.xFile,
    required this.displayName,
  });

  factory ImageItem.fromUrl(String url) {
    return ImageItem(
      id: url,
      type: ImageType.existing,
      url: url,
      displayName: url.split('/').last,
    );
  }

  factory ImageItem.fromXFile(XFile xFile) {
    return ImageItem(
      id: '${DateTime.now().millisecondsSinceEpoch}_${xFile.name}',
      type: ImageType.newFile,
      file: File(xFile.path),
      xFile: xFile,
      displayName: xFile.name,
    );
  }

  dynamic get displaySource {
    switch (type) {
      case ImageType.existing:
        return url;
      case ImageType.newFile:
        return file;
    }
  }

  bool get isExisting => type == ImageType.existing;
  bool get isNewFile => type == ImageType.newFile;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ImageItem{id: $id, type: $type, displayName: $displayName}';
  }
}
