import "package:dio/dio.dart";

final clarifai = Dio(
  BaseOptions(
    baseUrl: "https://api.clarifai.com/v2/users/sergi9rom/apps/hack-llama-2/workflows/",
    headers: {"authorization": "Key 6cb2c1f9a35e4ce2b3b6024d6c193d6e", "content-type": "application/json"},
  ),
);