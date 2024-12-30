import 'dart:convert';

import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
    adult: false,
    backdropPath: '/alb2BU2BeBZv5dgHhuzV9ZGakfZ.jpg',
    genreIds: [18, 80],
    id: 1396,
    originalName: 'Breaking Bad',
    overview:
        'Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family\'s financial future at any cost as he enters the dangerous world of drugs and crime.',
    popularity: 613.849,
    posterPath: '/ineLOBPG8AZsluYwnkMpHRyu7L.jpg',
    firstAirDate: '2008-01-20',
    name: 'Breaking Bad',
    voteAverage: 8.9,
    voteCount: 14682,
  );

  final tTvResponseModel = TvResponse(tvList: <TvModel>[tTvModel]);
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/now_playing.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "adult": false,
            "backdrop_path": "/alb2BU2BeBZv5dgHhuzV9ZGakfZ.jpg",
            "genre_ids": [18, 80],
            "id": 1396,
            "original_name": "Breaking Bad",
            "overview":
                "Walter White, a New Mexico chemistry teacher, is diagnosed with Stage III cancer and given a prognosis of only two years left to live. He becomes filled with a sense of fearlessness and an unrelenting desire to secure his family's financial future at any cost as he enters the dangerous world of drugs and crime.",
            "popularity": 613.849,
            "poster_path": "/ineLOBPG8AZsluYwnkMpHRyu7L.jpg",
            "first_air_date": "2008-01-20",
            "name": "Breaking Bad",
            "vote_average": 8.9,
            "vote_count": 14682
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
