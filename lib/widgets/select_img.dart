import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImg extends StatefulWidget {
  final ValueNotifier<dynamic>? selectedImg; // 갤러리에서 새로 선택한 이미지;
  const SelectImg({
    super.key,
    this.selectedImg,
  });

  @override
  State<SelectImg> createState() => _SelectImgState();
}

class _SelectImgState extends State<SelectImg> {
  bool isNewSelected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color(0xffF4F4F4),
        ),
        child: widget.selectedImg?.value == null
            // 선택된 이미지가 없으면
            ? const Icon(
                Icons.image,
                color: Color(0xff868686),
              )
            // 선택된 이미지가 있으면
            : Container(
                height: MediaQuery.of(context).size.width,
                child: isNewSelected
                    ? Image.file(
                        widget.selectedImg!.value,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        widget.selectedImg!.value,
                        fit: BoxFit.cover,
                      ),
              ),
      ),
      onTap: () => getGalleryImage(),
    );
  }

  void getGalleryImage() async {
    // 갤러리에서 이미지 가지고오는 함수

    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );

    if (image != null) {
      // 이미지가 선택 된 경우
      widget.selectedImg?.value = File(image.path);
      isNewSelected = true;
      setState(() {});
      return;
    }
  }
}
