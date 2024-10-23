import 'dart:convert';

class Link {
	dynamic persistentToken;

	Link({this.persistentToken});

	factory Link.fromMap(Map<String, dynamic> data) => Link(
				persistentToken: data['persistent_token'] as dynamic,
			);

	Map<String, dynamic> toMap() => {
				'persistent_token': persistentToken,
			};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Link].
	factory Link.fromJson(String data) {
		return Link.fromMap(json.decode(data) as Map<String, dynamic>);
	}
  /// `dart:convert`
  ///
  /// Converts [Link] to a JSON string.
	String toJson() => json.encode(toMap());
}
