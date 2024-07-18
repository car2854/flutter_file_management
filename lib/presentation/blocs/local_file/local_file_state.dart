part of 'local_file_bloc.dart';

class LocalFileState extends Equatable {

  final List<FileModel> files;
  final List<String> pathHistory;

  const LocalFileState({
    List<FileModel>? files,
    List<String>? pathHistory,
  }) : files = files ?? const [], pathHistory = pathHistory ?? const[''];

  LocalFileState copyWith({
    List<FileModel>? files,
    List<String>? pathHistory,
  }) => LocalFileState(
    files: files ?? this.files,
    pathHistory: pathHistory ?? this.pathHistory,
  );

  @override
  List<Object?> get props => [ files, pathHistory ];
}
