mixin DTO {
  Map<String, dynamic> toJSON();
  Map<String, String> toApiParams();
}
