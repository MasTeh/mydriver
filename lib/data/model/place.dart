class GooglePlace {
  String? address;
  String? street;
  String? postcode ;
  String? neighborhood;
  String? city;
  String? formattedAddress;

  GooglePlace({
      this.address,
      this.street,
      this.postcode,
      this.neighborhood,
      this.city,
      this.formattedAddress});

  GooglePlace.fromJson(Map<String, dynamic> json) {
    for (var component in json['address_components']) {
      var componentType = component["types"][0];
      switch (componentType) {
        case "street_number":
          address = component['long_name'];
          break;
        case "route":
          street = component['long_name'];
          break;
        case "neighborhood":
          neighborhood = component['long_name'];
          break;
        case "postal_town":
          city = component['long_name'];
          break;
        case "postal_code":
          postcode = component['long_name'];
          break;
        case "formatted_address":
          formattedAddress = component['long_name'];
          break;
      }
    }
  }
}