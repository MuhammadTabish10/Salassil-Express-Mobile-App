class TicketAttachment {
  int? id;
  String? filePath;

  TicketAttachment({
    this.id,
    this.filePath,
  });

  factory TicketAttachment.fromJson(Map<String, dynamic> json) {
    return TicketAttachment(
      id: json['id'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
    };
  }
}