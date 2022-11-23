part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();
}

class AddFileEvent extends FileEvent {
  final String name;
  final Uint8List? bytes;

  const AddFileEvent({required this.name, required this.bytes});

  @override
  List<Object?> get props => [name, bytes];
}

class UploadFileEvent extends FileEvent {
  final double progress;
  final String name;

  const UploadFileEvent({required this.progress, required this.name});

  @override
  List<Object?> get props => [name, progress];
}

class UploadSuccessEvent extends FileEvent {
  final Reference file;

  const UploadSuccessEvent(this.file);

  @override
  List<Object?> get props => [file];
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
  List<Object?> get props => [file, index];
}
