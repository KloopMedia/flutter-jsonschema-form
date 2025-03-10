import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/bloc.dart';

class UploadTaskManager extends StatelessWidget {
  const UploadTaskManager({super.key});

  String _bytesTransferredString(TaskSnapshot snapshot) {
    final totalSize = (snapshot.totalBytes / 1000).toStringAsFixed(1);
    final transferredSize = (snapshot.bytesTransferred / 1000).toStringAsFixed(1);
    return '$transferredSize/$totalSize';
  }

  double? _bytesTransferred(TaskSnapshot? snapshot) {
    if (snapshot == null) {
      return null;
    }
    return snapshot.bytesTransferred / snapshot.totalBytes;
  }

  final enumTaskStateMap = const {
    TaskState.running: "Uploading",
    TaskState.error: "Error",
    TaskState.canceled: "Canceled",
    TaskState.success: "Success",
    TaskState.paused: "Paused",
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileBloc, FileState>(
      builder: (context, state) {
        if (state is FileLoading) {
          final task = state.uploadTask;
          return StreamBuilder(
              stream: task.snapshotEvents,
              builder: (context, asyncSnapshot) {
                Widget status = const Text('---');
                TaskSnapshot? snapshot = asyncSnapshot.data;
                TaskState? taskState = snapshot?.state;
                if (snapshot != null) {
                  status = Text(
                    '${enumTaskStateMap[taskState!]!}: ${_bytesTransferredString(snapshot)} KB',
                  );
                }
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(snapshot?.ref.name ?? task.hashCode.toString()),
                  subtitle: UploadStatus(
                    state: taskState,
                    status: status,
                    progress: _bytesTransferred(snapshot),
                  ),
                  trailing: ControlButtons(
                    state: taskState,
                    onPause: task.pause,
                    onCancel: task.cancel,
                    onResume: task.resume,
                  ),
                );
              });
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class UploadStatus extends StatelessWidget {
  final TaskState? state;
  final double? progress;
  final Widget status;

  const UploadStatus({
    Key? key,
    required this.progress,
    required this.status,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        status,
        if (state == TaskState.running)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: LinearProgressIndicator(value: progress),
            ),
          ),
      ],
    );
  }
}

class ControlButtons extends StatelessWidget {
  final TaskState? state;
  final Future<bool> Function() onPause;
  final Future<bool> Function() onCancel;
  final Future<bool> Function() onResume;

  const ControlButtons({
    Key? key,
    this.state,
    required this.onPause,
    required this.onCancel,
    required this.onResume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (state == TaskState.running)
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: onPause,
          ),
        if (state == TaskState.running)
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: onCancel,
          ),
        if (state == TaskState.paused)
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: onResume,
          ),
      ],
    );
  }
}
