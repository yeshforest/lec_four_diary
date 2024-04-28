import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:four_diary/widgets/img_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../database_helper.dart';
import '../model/diary_model.dart';
import '../util/snackbar.dart';
import '../widgets/select_img.dart';

class WriteScreen extends StatefulWidget {
  final DiaryModel?
      diaryModel; // diarymodel 존재 x -> 작성하기, diaryModel 존재 -> 수정하기
  const WriteScreen({
    super.key,
    this.diaryModel,
  });

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  late ValueNotifier<dynamic> selectedImgTopLeft;
  late ValueNotifier<dynamic> selectedImgTopRight;
  late ValueNotifier<dynamic> selectedImgBtmLeft;
  late ValueNotifier<dynamic> selectedImgBtmRight;

  late bool isEdit; //수정하기 모드인지 체크

  TextEditingController inputTitleController = TextEditingController();
  final formKey = GlobalKey<FormState>(); // 입력필드 검증용

  int selectedDate = 0; // 선택된 날짜

  @override
  void initState() {
    isEdit = widget.diaryModel == null ? false : true;

    if (isEdit) {
      // 수정모드 -> 기존데이터 가져오기
      inputTitleController.text = widget.diaryModel!.title;
      selectedDate = widget.diaryModel!.date;

      selectedImgBtmRight = ValueNotifier(widget.diaryModel!.imageBtmRight);
      selectedImgTopLeft = ValueNotifier(widget.diaryModel!.imageTopLeft);
      selectedImgBtmLeft = ValueNotifier(widget.diaryModel!.imageBtmLeft);
      selectedImgTopRight = ValueNotifier(widget.diaryModel!.imageTopRight);
    } else {
      selectedImgBtmRight = ValueNotifier(null);
      selectedImgTopLeft = ValueNotifier(null);
      selectedImgBtmLeft = ValueNotifier(null);
      selectedImgTopRight = ValueNotifier(null);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "네컷일기 수정하기" : "네컷일기 작성하기",
          style: GoogleFonts.nanumPenScript(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 24,
            ),
          ),
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 선택 위젯
            ImageGridView(gridViewItem: [
              SelectImg(
                selectedImg: selectedImgTopLeft,
              ),
              SelectImg(
                selectedImg: selectedImgTopRight,
              ),
              SelectImg(
                selectedImg: selectedImgBtmLeft,
              ),
              SelectImg(
                selectedImg: selectedImgBtmRight,
              ),
            ]),
            // 텍스트 작성 필드
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                '한 줄 일기',
                style: GoogleFonts.nanumPenScript(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Form(
                key: formKey,
                child: TextFormField(
                  validator: (val) => titleValidator(val),
                  decoration: InputDecoration(
                    hintText: '한 줄 일기를 작성해주세요 (최대 8글자)',
                    hintStyle: GoogleFonts.nanumPenScript(
                      fontSize: 16,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color(0xffE1E1E1),
                    )),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  maxLength: 8,
                  controller: inputTitleController,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                '날짜',
                style: GoogleFonts.nanumPenScript(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // 날짜 선택 버튼
            GestureDetector(
              onTap: () => _selectedDate(context),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                alignment: Alignment.centerLeft,
                width: double.maxFinite,
                height: 56,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Color(0xffE1E1E1),
                )),
                child: Container(
                  margin: EdgeInsets.only(
                    left: 8,
                  ),
                  child: selectedDate == 0
                      ? Text(
                          '날짜를 선택해주세요',
                          style: GoogleFonts.nanumPenScript(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Color(0xffACACAC),
                            ),
                          ),
                        )
                      : Text(
                          DateFormat('yyyy.MM.dd').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              selectedDate,
                            ),
                          ),
                          style: GoogleFonts.nanumPenScript(
                            textStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 32,
              ),
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () => validateInput(),
                child: Container(
                    margin: EdgeInsets.all(
                      16,
                    ),
                    child: Text(
                      isEdit ? '수정하기' : '저장하기',
                      style: GoogleFonts.nanumPenScript(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectedDate(BuildContext context) async {
    // 날짜를 선택하는 함수
    final DateTime? selected = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (selected != null) {
      selectedDate = selected.millisecondsSinceEpoch;
      setState(() {});
    }
  }

  dynamic titleValidator(val) {
    // 제목 유효성 검사
    if (val.isEmpty) {
      return '제목을 입력해주세요';
    }
    return null;
  }

  void validateInput() {
    // 유효성 검사 함수

    if (formKey.currentState!.validate() &&
        isImgFieldValidate() &&
        isDateValidate()) {
      // 모두 입력이 되었으면
      isEdit ? editData() : saveData();
    }
  }

  void saveData() async {
    // 일기 저장
    DiaryModel diaryModel = DiaryModel(
      title: inputTitleController.text,
      imageTopLeft: await selectedImgTopLeft.value!.readAsBytes(),
      imageTopRight: await selectedImgTopRight.value!.readAsBytes(),
      imageBtmLeft: await selectedImgBtmLeft.value!.readAsBytes(),
      imageBtmRight: await selectedImgBtmRight.value!.readAsBytes(),
      date: selectedDate,
    );

    await DatabaseHelper().initDatabase();
    await DatabaseHelper().insertInfo(diaryModel); // sqflite 저장

    if (!mounted) return;
    showSnackBar(context, '일기가 저장되었습니다.');

    Navigator.pop(context, "COMPLETED_UPDATE");
  }

  Future<Uint8List> makeReadAsBytes(dynamic target) async {
    // 데이터를 수정하여 저장할 때 모든 데이터를 Uint8List 타입으로 변환하는 함수

    try {
      return await target.readAsBytes();
    } catch (e) {
      return target;
    }
  }

  void editData() async {
    //일기 수정하기
    DiaryModel diaryModel = DiaryModel(
      id: widget.diaryModel!.id,
      title: inputTitleController.text,
      imageTopLeft: await makeReadAsBytes(selectedImgTopLeft.value),
      imageTopRight: await makeReadAsBytes(selectedImgTopRight.value),
      imageBtmLeft: await makeReadAsBytes(selectedImgBtmLeft.value),
      imageBtmRight: await makeReadAsBytes(selectedImgBtmRight.value),
      date: selectedDate,
    );

    await DatabaseHelper().initDatabase();
    await DatabaseHelper().updateInfo(diaryModel); // upadate

    if (!mounted) return;
    showSnackBar(context, '일기가 수정되었습니다.');

    Navigator.pop(context, "COMPLETED_UPDATE");
  }

  bool isImgFieldValidate() {
    // 이미지 4개가 선택되었는지 확인

    bool isImgSelcted = selectedImgTopRight.value != null &&
        selectedImgTopLeft.value != null &&
        selectedImgBtmRight.value != null &&
        selectedImgBtmLeft.value != null;

    if (isImgSelcted) {
      return true;
    } else {
      return false;
    }
  }

  bool isDateValidate() {
    // 날짜가 선택되었는지 확인

    bool isDateValidate = selectedDate != 0; // 초기화 숫자가 0이었음.
    if (isDateValidate) {
      return true;
    } else {
      showSnackBar(context, '날짜를 선택해주세요');
      return false;
    }
  }
}
