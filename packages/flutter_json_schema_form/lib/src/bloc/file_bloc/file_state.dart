part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  final List<Reference> files;

  const FileState({required this.files});
}

class FilesInitial extends FileState {
  const FilesInitial({required super.files});

  @override
  List<Object> get props => [files];
}

class FilesModified extends FileState {
  const FilesModified({required super.files});

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
  final Exception error;

  const FileError({required this.error, required super.files});

  @override
  List<Object?> get props => [files, error];
}

class FilePreview extends FileState {
  final Reference file;

  const FilePreview({required super.files, required this.file});

  @override
  List<Object?> get props => [file, files];
}
