// To parse this JSON data, do
//
//     final option = optionFromJson(jsonString);

import 'dart:convert';

Option optionFromJson(String str) => Option.fromJson(json.decode(str));

String optionToJson(Option data) => json.encode(data.toJson());

class Option {
    String label;
    String value;

    Option({
        required this.label,
        required this.value,
    });

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        label: json["label"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
    };
}
