import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io' as io;

import 'package:dating_app/models/prompt_answer_model.dart';

class DownloadNudgeApi {
  Future<String> downloadNudge(
      PromptAnswerModel promptAnswerModel, int index) async {
    dev.log("file url -> ${promptAnswerModel.data![index].mediaUrl!}");

    final fileName = promptAnswerModel.data![index].mediaUrl!
        .split("/")
        .last
        .split("?")
        .first;

    final splittedFile = fileName.split(".");
    final extension = splittedFile.last;
    splittedFile.removeAt(splittedFile.length - 1);
    final newFile = splittedFile.join("");

    dev.log("new file name -> $newFile extension -> $extension");

    final dir = await getApplicationCacheDirectory();
    dev.log("this is the dir -> ${dir.path}");
    dev.log("this is the file name -> $fileName");
    dev.log("downloading the file");

    final downloadPath = "${dir.path}/$newFile.$extension";
    dev.log("download path -> $downloadPath");

    bool isPresent = io.File(downloadPath).existsSync();

    if (isPresent) {
      dev.log("file present");
      return downloadPath;
    } else {
      dev.log("file not present");
    }

// do changes here
// when the file is downloaded we can send the file as well
// cause we know the location of the download
// once the download is completed we can just send it there
    await Dio()
        .download(promptAnswerModel.data![index].mediaUrl!, downloadPath)
        .whenComplete(
          () => dev.log("file download complete dio"),
        );

    dev.log("this download completed $downloadPath");

    dev.log(promptAnswerModel.data![index].question!);

    return downloadPath;
  }
}
