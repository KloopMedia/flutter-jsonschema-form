part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  final List<Reference> files;
  final bool enabled;
  final List<String>? addFileText;

  const FileState({required this.files, this.enabled = true, this.addFileText});
}

class FilesInitial extends FileState {
  const FilesInitial({required super.files, super.enabled, super.addFileText});

  @override
  List<Object> get props => [files];
}

class FilesModified extends FileState {
  const FilesModified({required super.files});

  @override
  List<Object> get props => [files];
}

class FileCompressing extends FileState {

  const FileCompressing({required super.files});

  @override
  List<Object> get props => [files];
}

class FileLoading extends FileState {
  final UploadTask uploadTask;

  const FileLoading({required super.files, required this.uploadTask});

  @override
  List<Object> get props => [uploadTask, files];
}

class FileError extends FileState {
  final String errorMessage;

  const FileError({required this.errorMessage, required super.files});

  @override
  List<Object?> get props => [files, errorMessage];
}

class FilePreview extends FileState {
  final Reference file;

  const FilePreview({required super.files, required this.file});

  @override
  List<Object?> get props => [file, files];
}
