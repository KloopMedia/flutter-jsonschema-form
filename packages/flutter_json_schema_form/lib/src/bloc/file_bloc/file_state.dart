part of 'file_bloc.dart';

abstract class FileState extends Equatable {
  final List<FileModel> files;

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
  final String name;
  final double progress;

  const FileLoading({
    required super.files,
    required this.name,
    required this.progress,
  });

  @override
  List<Object> get props => [progress, files];
}

class FileError extends FileState {
  final Exception error;

  const FileError({required this.error, required super.files});

  @override
  List<Object?> get props => [files, error];
}
