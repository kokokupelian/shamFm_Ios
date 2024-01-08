import 'dart:convert';

class GQL {
  static String get _link => "https://gql.sham.fm";

  static Uri get Link => Uri.parse(_link);

  static String _gqlBody(
      {required String query, String? operationName, String? variables}) {
    return json.encode({
      "query": """query{$query}""",
      "operationName": operationName,
      "variables": variables
    });
  }

  static String categories(
      {required List<String> fields, List<String>? parentCategory}) {
    var _fields = fields.join(" ");
    var _parentalCategory = parentCategory != null && parentCategory.isNotEmpty
        ? "parentCategory { ${parentCategory.join(" ")} }"
        : "";
    return _gqlBody(query: "Categories { ${_fields} ${_parentalCategory} }");
  }

  static String articlesByCategories(
      {required String id,
      required int offset,
      required List<String> fields,
      List<String>? category,
      List<String>? mainImage}) {
    var _fields = fields.join(" ");
    var _category = category != null && category.isNotEmpty
        ? "category{ ${category.join(" ")} }"
        : "";
    var _mainImage = mainImage != null && mainImage.isNotEmpty
        ? "MainImage{ ${mainImage.join(" ")} }"
        : "";
    return _gqlBody(
        query:
            """ArticleByCategories(id : "${id}" , offset : ${offset}){ ${_fields} ${_category} ${_mainImage} }""");
  }

  static String articleForHeaders(
      {required int index,
      required List<String> fields,
      List<String>? category,
      List<String>? mainImage}) {
    var _fields = fields.join(" ");
    var _category = category != null && category.isNotEmpty
        ? "category{ ${category.join(" ")} }"
        : "";
    var _mainImage = mainImage != null && mainImage.isNotEmpty
        ? "MainImage{ ${mainImage.join(" ")} }"
        : "";
    return _gqlBody(
        query:
            """ArticleForHeader(index : ${index}){ ${_fields} ${_category} ${_mainImage} }""");
  }

  static String articleFromKeyWords(
      {required String keyWords,
      required List<String> fields,
      List<String>? category,
      List<String>? mainImage}) {
    var _fields = fields.join(" ");
    var _category = category != null && category.isNotEmpty
        ? "category{ ${category.join(" ")} }"
        : "";
    var _mainImage = mainImage != null && mainImage.isNotEmpty
        ? "MainImage{ ${mainImage.join(" ")} }"
        : "";
    return _gqlBody(
        query:
            """ArticlesByKeywords(keyword : "${keyWords}"){ ${_fields} ${_category} ${_mainImage} }""");
  }

  static String horoscope({required String date}) {
    return _gqlBody(
        query:
            """HoroscopeByDay(day : "${date}"){ aries taurus gemini cancer leo virgo libra scorpio sagittarius capricorn aquarius pisces }""");
  }

  static String tvList() {
    return _gqlBody(query: """TvLists{title,name,server,web,}""");
  }

  static String radioLists() {
    return _gqlBody(query: """RadioList{title,name,radio,image}""");
  }

  static String uploaded() {
    return _gqlBody(query: """isUploaded{uploaded}""");
  }
}
