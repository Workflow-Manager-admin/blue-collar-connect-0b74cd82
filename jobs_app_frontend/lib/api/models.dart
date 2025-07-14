/// Models for API entities: User, Job, Application, Company, Message.
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final String? phone;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.phone,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id']?.toString() ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        avatarUrl: json['avatarUrl'],
        bio: json['bio'],
        phone: json['phone'],
      );
}

class Job {
  final String id;
  final String title;
  final String companyId;
  final String companyName;
  final String location;
  final String? description;
  final String? salary;
  final bool applied;

  Job({
    required this.id,
    required this.title,
    required this.companyId,
    required this.companyName,
    required this.location,
    this.description,
    this.salary,
    this.applied = false,
  });

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json['id'].toString(),
        title: json['title'] ?? "",
        companyId: json['companyId']?.toString() ?? "",
        companyName: json['companyName'] ?? "",
        location: json['location'] ?? "",
        description: json['description'],
        salary: json['salary']?.toString(),
        applied: json['applied'] == true,
      );
}

class JobApplication {
  final String id;
  final String jobId;
  final String status;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.status,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) => JobApplication(
        id: json['id']?.toString() ?? "",
        jobId: json['jobId']?.toString() ?? "",
        status: json['status'] ?? "",
      );
}

class Company {
  final String id;
  final String name;
  final String? about;

  Company({
    required this.id,
    required this.name,
    this.about,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        id: json['id']?.toString() ?? "",
        name: json['name'] ?? "",
        about: json['about'],
      );
}

class MessageThread {
  final String id;
  final String contactName;
  final List<Message> messages;

  MessageThread({
    required this.id,
    required this.contactName,
    required this.messages,
  });

  factory MessageThread.fromJson(Map<String, dynamic> json) => MessageThread(
        id: json['id']?.toString() ?? "",
        contactName: json['contactName'] ?? "",
        messages: (json['messages'] as List<dynamic>? ?? [])
            .map((m) => Message.fromJson(m))
            .toList(),
      );
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;

  Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json['id']?.toString() ?? "",
        senderId: json['senderId']?.toString() ?? "",
        text: json['text'] ?? "",
        sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
      );
}
