import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class MultiFormDataManager {
  final Map<String, String> textData = {};
  final List<File> imageFiles = [];
  final List<File> documentFiles = [];
  final List<File> otherFiles = [];

  // Add text data
  void addTextData(String key, String value) {
    textData[key] = value;
  }

  // Add multiple text data
  void addMultipleTextData(Map<String, String> data) {
    textData.addAll(data);
  }

  // Add image files from XFile
  Future<void> addImages(List<XFile> images) async {
    for (var image in images) {
      imageFiles.add(File(image.path));
    }
  }

  // Add image files from File
  void addImageFiles(List<File> files) {
    imageFiles.addAll(files);
  }

  // Add single image file
  void addImageFile(File file) {
    imageFiles.add(file);
  }

  // Add documents from PlatformFile
  Future<void> addDocuments(List<PlatformFile> files) async {
    for (var file in files) {
      if (file.path != null) {
        documentFiles.add(File(file.path!));
      }
    }
  }

  // Add document files from File
  void addDocumentFiles(List<File> files) {
    documentFiles.addAll(files);
  }

  // Add single document file
  void addDocumentFile(File file) {
    documentFiles.add(file);
  }

  // Add any type of file
  void addFiles(List<File> files, {String type = 'other'}) {
    if (type == 'image') {
      imageFiles.addAll(files);
    } else if (type == 'document') {
      documentFiles.addAll(files);
    } else {
      otherFiles.addAll(files);
    }
  }

  // Add single file with type
  void addFile(File file, {String type = 'other'}) {
    if (type == 'image') {
      imageFiles.add(file);
    } else if (type == 'document') {
      documentFiles.add(file);
    } else {
      otherFiles.add(file);
    }
  }

  // Remove text data by key
  void removeTextData(String key) {
    textData.remove(key);
  }

  // Remove image file by index
  void removeImageAt(int index) {
    if (index >= 0 && index < imageFiles.length) {
      imageFiles.removeAt(index);
    }
  }

  // Remove document file by index
  void removeDocumentAt(int index) {
    if (index >= 0 && index < documentFiles.length) {
      documentFiles.removeAt(index);
    }
  }

  // Remove other file by index
  void removeOtherFileAt(int index) {
    if (index >= 0 && index < otherFiles.length) {
      otherFiles.removeAt(index);
    }
  }

  // Clear all data
  void clear() {
    textData.clear();
    imageFiles.clear();
    documentFiles.clear();
    otherFiles.clear();
  }

  // Clear only text data
  void clearTextData() {
    textData.clear();
  }

  // Clear only image files
  void clearImages() {
    imageFiles.clear();
  }

  // Clear only document files
  void clearDocuments() {
    documentFiles.clear();
  }

  // Clear only other files
  void clearOtherFiles() {
    otherFiles.clear();
  }

  // Check if form data is empty
  bool isEmpty() {
    return textData.isEmpty &&
        imageFiles.isEmpty &&
        documentFiles.isEmpty &&
        otherFiles.isEmpty;
  }

  // Get total file count
  int get totalFileCount {
    return imageFiles.length + documentFiles.length + otherFiles.length;
  }

  // Get total size of all files in bytes
  Future<int> getTotalSize() async {
    int totalSize = 0;

    for (var file in imageFiles) {
      totalSize += await file.length();
    }

    for (var file in documentFiles) {
      totalSize += await file.length();
    }

    for (var file in otherFiles) {
      totalSize += await file.length();
    }

    return totalSize;
  }

  // Convert to Dio FormData (synchronous version)
  FormData toFormData() {
    final formData = FormData();

    // Add text fields
    textData.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    // Add image files
    for (var i = 0; i < imageFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'images', // Use same field name for multiple files
          MultipartFile.fromFileSync(
            imageFiles[i].path,
            filename: _getFileName(imageFiles[i], 'image_$i'),
          ),
        ),
      );
    }

    // Add document files
    for (var i = 0; i < documentFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'documents',
          MultipartFile.fromFileSync(
            documentFiles[i].path,
            filename: _getFileName(documentFiles[i], 'document_$i'),
          ),
        ),
      );
    }

    // Add other files
    for (var i = 0; i < otherFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'files',
          MultipartFile.fromFileSync(
            otherFiles[i].path,
            filename: _getFileName(otherFiles[i], 'file_$i'),
          ),
        ),
      );
    }

    return formData;
  }

  // Alternative: Async version for large files
  Future<FormData> toFormDataAsync() async {
    final formData = FormData();

    // Add text fields
    textData.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    // Add image files asynchronously
    for (var i = 0; i < imageFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            imageFiles[i].path,
            filename: _getFileName(imageFiles[i], 'image_$i'),
          ),
        ),
      );
    }

    // Add document files asynchronously
    for (var i = 0; i < documentFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'documents',
          await MultipartFile.fromFile(
            documentFiles[i].path,
            filename: _getFileName(documentFiles[i], 'document_$i'),
          ),
        ),
      );
    }

    // Add other files asynchronously
    for (var i = 0; i < otherFiles.length; i++) {
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            otherFiles[i].path,
            filename: _getFileName(otherFiles[i], 'file_$i'),
          ),
        ),
      );
    }

    return formData;
  }

  // Enhanced method with validation
  Future<FormData> toFormDataWithValidation({
    int maxFileSize = 10 * 1024 * 1024, // 10MB default
    List<String> allowedImageTypes = const [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
    ],
    List<String> allowedDocumentTypes = const [
      'pdf',
      'doc',
      'docx',
      'txt',
      'rtf',
    ],
  }) async {
    final formData = FormData();
    final errors = <String>[];

    // Validate and add text fields
    textData.forEach((key, value) {
      if (value.isEmpty) {
        errors.add('Field "$key" cannot be empty');
      }
      formData.fields.add(MapEntry(key, value));
    });

    // Validate and add image files
    for (var i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final extension = _getFileExtension(file.path);

      if (!allowedImageTypes.contains(extension.toLowerCase())) {
        errors.add('Image ${file.path} has invalid type: $extension');
        continue;
      }

      final length = await file.length();
      if (length > maxFileSize) {
        errors.add(
          'Image ${file.path} exceeds maximum size (${maxFileSize ~/ (1024 * 1024)}MB)',
        );
        continue;
      }

      formData.files.add(
        MapEntry(
          'images',
          await MultipartFile.fromFile(
            file.path,
            filename: _getFileName(file, 'image_$i'),
          ),
        ),
      );
    }

    // Validate and add document files
    for (var i = 0; i < documentFiles.length; i++) {
      final file = documentFiles[i];
      final extension = _getFileExtension(file.path);

      if (!allowedDocumentTypes.contains(extension.toLowerCase())) {
        errors.add('Document ${file.path} has invalid type: $extension');
        continue;
      }

      final length = await file.length();
      if (length > maxFileSize) {
        errors.add(
          'Document ${file.path} exceeds maximum size (${maxFileSize ~/ (1024 * 1024)}MB)',
        );
        continue;
      }

      formData.files.add(
        MapEntry(
          'documents',
          await MultipartFile.fromFile(
            file.path,
            filename: _getFileName(file, 'document_$i'),
          ),
        ),
      );
    }

    // Add other files (no validation)
    for (var i = 0; i < otherFiles.length; i++) {
      final file = otherFiles[i];
      formData.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            file.path,
            filename: _getFileName(file, 'file_$i'),
          ),
        ),
      );
    }

    if (errors.isNotEmpty) {
      throw FormatException('Validation failed: ${errors.join(", ")}');
    }

    return formData;
  }

  // Helper method to get file name with extension
  String _getFileName(File file, String fallbackName) {
    final path = file.path;
    final fileName = path.split('/').last;
    return fileName.isNotEmpty
        ? fileName
        : '$fallbackName.${_getFileExtension(path)}';
  }

  // Helper method to get file extension
  String _getFileExtension(String path) {
    final parts = path.split('.');
    return parts.length > 1 ? parts.last : 'bin';
  }

  // Get summary of form data (useful for debugging)
  Future<Map<String, dynamic>> getSummary() async {
    return {
      'textFields': textData.length,
      'imageFiles': imageFiles.length,
      'documentFiles': documentFiles.length,
      'otherFiles': otherFiles.length,
      'totalFiles': totalFileCount,
      'totalSize': await getTotalSize(),
      'textData': textData,
      'imagePaths': imageFiles.map((f) => f.path).toList(),
      'documentPaths': documentFiles.map((f) => f.path).toList(),
      'otherFilePaths': otherFiles.map((f) => f.path).toList(),
    };
  }

  // Create a copy of the form data manager
  MultiFormDataManager copy() {
    final copy = MultiFormDataManager();
    copy.textData.addAll(textData);
    copy.imageFiles.addAll(imageFiles);
    copy.documentFiles.addAll(documentFiles);
    copy.otherFiles.addAll(otherFiles);
    return copy;
  }
}
