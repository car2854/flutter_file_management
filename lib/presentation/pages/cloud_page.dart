import 'package:file_management/domain/helpers/helper.dart';
import 'package:file_management/presentation/blocs/bloc.dart';
import 'package:file_management/presentation/helpers/helper.dart';
import 'package:file_management/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_filex/open_filex.dart';

class CloudPage extends StatefulWidget {
  final CloudFileBloc cloudFileBloc;

  const CloudPage({
    super.key,
    required this.cloudFileBloc,
  });

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CloudFileBloc, CloudFileState>(
          builder: (context, stateCloudFile) {
            return AppBarWidget(
              title: 'Cloud',
              history: (stateCloudFile.pathHistory.last.trim().isEmpty) ? '': '/${stateCloudFile.pathHistory.last}',
              onPressedNewFolder: () {
                final tecFolderName = TextEditingController();
                final formKey = GlobalKey<FormState>();

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: DialogTheme(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9)
                          )
                        )
                      ),
                      child: Form(
                        key: formKey,
                        child: NewFolderDialogWidget(
                          tecFolderName: tecFolderName,
                          formKey: formKey,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Este campo es obligatorio';
                            }
                            if (!isValidString(value)) {
                              return 'No deben existir caracteres como /,. en el nombre';
                            }
                            bool exist = widget.cloudFileBloc.state.files
                                .any((dato) => dato.fileName == '$value/');
                            if (exist) {
                              return 'Ya existe una carpeta con ese nombre';
                            }
                            return null;
                          },
                          onPressedAccept: () async {
                            if (formKey.currentState!.validate()) {
                              EasyLoading.show(status: 'Cargando');
                      
                              final navigator = Navigator.of(context);
                              final state = await widget.cloudFileBloc.createFolder(tecFolderName.value.text);
                              if (state) {
                                navigator.pop();
                              } else {
                                // TODO: Error aqui
                              }
                              EasyLoading.dismiss();
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              onPressedUploadFile: () async {
                final navigator = Navigator.of(context);
                EasyLoading.show(status: 'Cargando');
                final pickedFiles = await openFileExplorer(context);
                EasyLoading.dismiss();
                if (pickedFiles.isNotEmpty) {
                  showImagesCarousel(
                    // ignore: use_build_context_synchronously
                    context: context,
                    files: pickedFiles,
                    onPressedAccept: () async {
                      EasyLoading.show(status: 'Cargando');
                      List<String> paths = pickedFiles.map((file) => file.path).toList();
                      final status = await widget.cloudFileBloc.updateFile(paths: paths);
                      if (status){
                        navigator.pop();
                      }else{
                        // TODO: Error aqui
                      }
                      EasyLoading.dismiss();
                    },
                  );
                }
              },
            );
          },
        ),
        Expanded(
          child: FutureBuilder<Object>(
              future: widget.cloudFileBloc.getFiles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicatorWidget();
                }
                if (snapshot.hasData) {
                  return BlocBuilder<CloudFileBloc, CloudFileState>(
                    builder: (context, stateCloudFile) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: stateCloudFile.files.length,
                          itemBuilder: (context, index) {
                            return (stateCloudFile.files[index].format != 'back')
                              ? DismissibleWidget(
                                  confirmDismiss: (direction) async {
                                    return await deleteDialog(
                                      context: context,
                                      message:
                                          '¿Estás seguro que quieres eliminar ${stateCloudFile.files[index].name}?',
                                      onPressedAccept: () async {
                                        EasyLoading.show(status: 'Eliminando');
                                        final navigator = Navigator.of(context);
                                        final status = await widget
                                            .cloudFileBloc
                                            .deleteFile(stateCloudFile
                                                .files[index].fileName);
                                        if (status) {
                                          navigator.pop(true);
                                        } else {
                                          // TODO: Error
                                        }
                                        EasyLoading.dismiss();
                                      },
                                    );
                                  },
                                  widget: ListTileWidget(
                                      leadingFormat:
                                          stateCloudFile.files[index].format,
                                      leadingPath:
                                          stateCloudFile.files[index].publicUrl,
                                      title: stateCloudFile.files[index].name,
                                      onTap: () async {
                                        
                                        if (stateCloudFile
                                                .files[index].format ==
                                            'folder') {
                                          EasyLoading.show(status: 'Cargando');
                                          widget.cloudFileBloc.add(OnSetPathHistoryCloud([...stateCloudFile.pathHistory, stateCloudFile.files[index].fileName]));
                                          await widget.cloudFileBloc.stream.first;
                                          await widget.cloudFileBloc.getFiles();
                                          EasyLoading.dismiss();
                                          } else if(['pdf', 'docx'].contains(stateCloudFile.files[index].format)) {
                                            // TODO: Leer PDF
                                            // OpenFilex.open(stateCloudFile.files[index].publicUrl);
                                            //  String savedDir = (await getTemporaryDirectory()).path;
                                            // await FlutterDownloader.enqueue(
                                            //   url: stateCloudFile.files[index].publicUrl,
                                            //   savedDir: savedDir,
                                            //   showNotification: true, // show download progress in status bar (for Android)
                                            //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                            // );
                                          } else if (stateCloudFile.files[index].format == 'back') {
                                          EasyLoading.show(status: 'Cargando');
                                          widget.cloudFileBloc.add(OnSetPathHistoryCloud(stateCloudFile.pathHistory.sublist(0,stateCloudFile.pathHistory.length - 1)));
                                          await widget
                                              .cloudFileBloc.stream.first;
                                          await widget.cloudFileBloc.getFiles();
                                          EasyLoading.dismiss();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ImageModal(
                                                imageUrl: stateCloudFile
                                                    .files[index].publicUrl,
                                              );
                                            },
                                          );
                                        }
                                      }),
                                )
                              : ListTile(
                                  leading: getIcon(
                                      format:
                                          stateCloudFile.files[index].format,
                                      path: stateCloudFile
                                          .files[index].publicUrl),
                                  title: Text(stateCloudFile.files[index].name),
                                  onTap: () async {
                                    print(stateCloudFile.files[index].format);
                                    if (stateCloudFile.files[index].format =='folder') {
                                      EasyLoading.show(status: 'Cargando');
                                      widget.cloudFileBloc.add(
                                        OnSetPathHistoryCloud([...stateCloudFile.pathHistory,stateCloudFile.files[index].fileName
                                      ]));
                                      await widget.cloudFileBloc.stream.first;
                                      await widget.cloudFileBloc.getFiles();
                                      EasyLoading.dismiss();
                                    } else if (stateCloudFile.files[index].format == 'back') {
                                      EasyLoading.show(status: 'Cargando');
                                      widget.cloudFileBloc.add(OnSetPathHistoryCloud(stateCloudFile.pathHistory.sublist(0,stateCloudFile.pathHistory.length - 1)));
                                      await widget.cloudFileBloc.stream.first;
                                    
                                      await widget.cloudFileBloc.getFiles();
                                      EasyLoading.dismiss();
                                    } else if(['pdf', 'docx'].contains(stateCloudFile.files[index].format)) {
                                      OpenFilex.open(stateCloudFile.files[index].publicUrl);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Theme(
                                            data: Theme.of(context).copyWith(
                                              dialogTheme: DialogTheme(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(2),
                                                ),
                                              )
                                            ),
                                            child: ImageModal(
                                              imageUrl: stateCloudFile
                                                  .files[index].publicUrl,
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                          },
                        );
                      
    
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Error'),
                  );
                }
              }),
        ),
      ],
    );
  }

}
