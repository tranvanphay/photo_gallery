class Item {
  int? remoteId;
  String? thumnail;
  String? linkDownload;
  String? photoDate;
  String? photoDateTime;
  String? serverDate;

  Item(
      {this.remoteId,
      this.thumnail,
      this.linkDownload,
      this.photoDate,
      this.photoDateTime,
      this.serverDate});

  Item.fromJson(Map<String, dynamic> json) {
    remoteId = json['id'];
    thumnail = json['thumnail'];
    linkDownload = json['link_download'];
    photoDate = json['photo_date'];
    photoDateTime = json['photo_date_time'];
    serverDate = json['server_date'];
  }
}
