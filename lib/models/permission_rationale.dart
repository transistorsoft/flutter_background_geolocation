part of flt_background_geolocation;

class PermissionRationale {
  String? title;

  String? message;

  String? positiveAction;

  String? negativeAction;

  PermissionRationale(
      {this.title, this.message, this.positiveAction, this.negativeAction});

  static fromMap(Map map) {
    return PermissionRationale(
        title: (map['title'] != null) ? map['title'] : null,
        message: (map['message'] != null) ? map['message'] : null,
        positiveAction:
            (map['positiveAction'] != null) ? map['positiveAction'] : null,
        negativeAction:
            (map['negativeAction'] != null) ? map['negativeAction'] : null);
  }

  Map<String, String?> toMap() {
    return {
      "title": this.title,
      "message": this.message,
      "positiveAction": this.positiveAction,
      "negativeAction": this.negativeAction
    };
  }
}
