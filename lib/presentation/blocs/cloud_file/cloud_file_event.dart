part of 'cloud_file_bloc.dart';

class CloudFileEvent extends Equatable {
  const CloudFileEvent();

  @override
  List<Object> get props => [];
}

class OnSetFileResponse extends CloudFileEvent{
  final List<FileModel>? files;
  const OnSetFileResponse(this.files);
}

class OnSetPathHistoryCloud extends CloudFileEvent{
  final List<String> pathHistory;
  const OnSetPathHistoryCloud(this.pathHistory);
}
