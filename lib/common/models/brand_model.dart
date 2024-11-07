class BrandModel {
  int? _id;
  String? _name;
  int? _position;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _image;
  int? _totalProductQuantity;

  BrandModel(
      {int? id,
        String? name,
        int? position,
        int? status, 
        String? createdAt,
        String? updatedAt,
        String? image,
        int? totalProductQuantity,
      }) {
    _id = id;
    _name = name;
    _position = position;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _image = image;
    _totalProductQuantity = totalProductQuantity;
  }

  int? get id => _id;
  String? get name => _name;
  int? get position => _position;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get image => _image;
  int? get totalProductQuantity => _totalProductQuantity;

  BrandModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _position = json['position'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image_fullpath'];  
    _totalProductQuantity = int.tryParse('${json['products_count']}');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['position'] = _position;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['image'] = _image;
    data['products_count'] = _totalProductQuantity;
    return data;
  }
}
