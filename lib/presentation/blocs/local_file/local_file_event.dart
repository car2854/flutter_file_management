part of 'local_file_bloc.dart';

class LocalFileEvent extends Equatable {
  const LocalFileEvent();

  @override
  List<Object> get props => [];
}

class OnSetFiles extends LocalFileEvent{
  final List<FileModel> files;
  const OnSetFiles(this.files);
}

class OnSetPathHistory extends LocalFileEvent{
  final List<String> pathHistory;
  const OnSetPathHistory(this.pathHistory);
}