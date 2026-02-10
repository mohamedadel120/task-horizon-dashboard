abstract class BaseModel {
  BaseModel fromMap(Map<String, dynamic> json);
  Map<String, dynamic> toMap();
  BaseModel copyWith();
  BaseModel fakeData();
}

