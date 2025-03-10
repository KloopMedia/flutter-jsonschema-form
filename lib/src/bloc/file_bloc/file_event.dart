part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();
}

class AddFileEvent extends FileEvent {
  final String name;
  final Uint8List? bytes;
  final List files;

  const AddFileEvent({required this.name, required this.bytes, required this.files});

  @override
  List<Object?> get props => [name, bytes];
}

class AddFutureFileEvent extends FileEvent {
  final Future<FilePickerResult?> future;

  const AddFutureFileEvent({required this.future});

  @override
  List<Object?> get props => [future];
}

class UploadSuccessEvent extends FileEvent {
  final Reference file;

  const UploadSuccessEvent(this.file);

  @override
  List<Object?> get props => [file];
}

class UploadFailEvent extends FileEvent {
  const UploadFailEvent();

  @override
  List<Object?> get props => [];
}

class RemoveFileEvent extends FileEvent {
  final Reference file;
  final int index;

  const RemoveFileEvent(this.file, this.index);

  @override
  List<Object?> get props => [file, index];
}

class ViewFileEvent extends FileEvent {
  final Reference file;
  final int index;

  const ViewFileEvent(this.file, this.index);

  @override
  List<Object?> get props => [];
}

class CloseFileViewerEvent extends FileEvent {
  const CloseFileViewerEvent();

  @override
  List<Object?> get props => [];
}
