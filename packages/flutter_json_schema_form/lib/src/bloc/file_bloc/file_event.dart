part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();
}

class AddFileEvent extends FileEvent {
  final String name;
  final Uint8List? bytes;
  final FileType type;

  const AddFileEvent({required this.name, required this.bytes, required this.type});

  @override
  List<Object?> get props => [name, bytes];
}

class RemoveFileEvent extends FileEvent {
  final String id;

  const RemoveFileEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ViewFileEvent extends FileEvent {
  final String id;

  const ViewFileEvent(this.id);

  @override
  List<Object?> get props => [id];
}