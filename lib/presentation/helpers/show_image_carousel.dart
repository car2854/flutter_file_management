import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_management/presentation/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:file_management/domain/helpers/helper.dart';
import 'package:open_filex/open_filex.dart';

void showImagesCarousel({required List<File> files, required BuildContext context, required void Function() onPressedAccept}) {

  showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9)
          )
        )
      ),
      child: Dialog(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Expanded(
                child: CarouselSlider(
                options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.8,
                  aspectRatio: 16 / 9, 
                  viewportFraction: 1.0, 
                  enlargeCenterPage: false, 
                  enableInfiniteScroll: false,
                  autoPlay: false, 
                ),
                  items: files.map((file) {
                    return Builder(
                      builder: (BuildContext context) {
                        return (['pdf', 'docs'].contains(getFileExtensionHelper(file.path))) ? Column(
                          children: [
                            const Expanded(
                              child: Icon(Icons.picture_as_pdf, size: 90,),
                            ),
                            TextButton(
                              onPressed: (){
                                OpenFilex.open(file.path);
                              }, 
                              child: const Text('Ver archivo')
                            )
                          ],
                        ) : 
                        Image.file(file, fit: BoxFit.cover, width: 1000,);
                      },
                    );
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButtonWidget(
                      title: 'Cancelar',
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  TextButtonWidget(
                    title: 'Aceptar',
        
                    onPressed: onPressedAccept
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

