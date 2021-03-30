class Rota {
  List<Routes> routes;
  List<Waypoints> waypoints;
  String code;
  String uuid;

  Rota({this.routes, this.waypoints, this.code, this.uuid});

  Rota.fromJson(Map<String, dynamic> json) {
    if (json['routes'] != null) {
      routes = [];
      json['routes'].forEach((v) {
        routes.add(new Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = [];
      json['waypoints'].forEach((v) {
        waypoints.add(new Waypoints.fromJson(v));
      });
    }
    code = json['code'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.routes != null) {
      data['routes'] = this.routes.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints.map((v) => v.toJson()).toList();
    }
    data['code'] = this.code;
    data['uuid'] = this.uuid;
    return data;
  }
}

class Routes {
  String geometry;
  List<Legs> legs;
  String weightName;
  double weight;
  double duration;
  double distance;

  Routes(
      {this.geometry,
      this.legs,
      this.weightName,
      this.weight,
      this.duration,
      this.distance});

  Routes.fromJson(json) {
    geometry =  json['geometry'] == null? null: json['geometry'].toString();
    if (json['legs'] != null) {
      legs = [];
      json['legs'].forEach((v) {
        legs.add(new Legs.fromJson(v));
      });
    }
    weightName = json['weight_name'];
    weight = json['weight'] == null ? null : json['weight'].toDouble();
    duration = json['duration'] == null ? null : json['duration'].toDouble();
    distance = json['distance'] == null ? null : json['distance'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geometry'] = this.geometry;
    if (this.legs != null) {
      data['legs'] = this.legs.map((v) => v.toJson()).toList();
    }
    data['weight_name'] = this.weightName;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Legs {
  String summary;
  double weight;
  double duration;
  List<Steps> steps;
  double distance;

  Legs({this.summary, this.weight, this.duration, this.steps, this.distance});

  Legs.fromJson(Map<String, dynamic> json) {
    summary = json['summary'];
    weight = json['weight'] == null ? null : json['weight'].toDouble();
    duration = json['duration'] == null ? null : json['duration'].toDouble();
    if (json['steps'] != null) {
      steps = [];
      json['steps'].forEach((v) {
        steps.add(new Steps.fromJson(v));
      });
    }
    distance = json['distance'] == null ? null : json['distance'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary'] = this.summary;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    if (this.steps != null) {
      data['steps'] = this.steps.map((v) => v.toJson()).toList();
    }
    data['distance'] = this.distance;
    return data;
  }
}

class Steps {
  List<Intersections> intersections;
  String drivingSide;
  String geometry;
  String mode;
  Maneuver maneuver;
  String ref;
  double weight;
  double duration;
  String name;
  double distance;
  List<VoiceInstructions> voiceInstructions;
  List<BannerInstructions> bannerInstructions;

  Steps(
      {this.intersections,
      this.drivingSide,
      this.geometry,
      this.mode,
      this.maneuver,
      this.ref,
      this.weight,
      this.duration,
      this.name,
      this.distance,
      this.voiceInstructions,
      this.bannerInstructions});

  Steps.fromJson(Map<String, dynamic> json) {
    if (json['intersections'] != null) {
      intersections = [];
      json['intersections'].forEach((v) {
        intersections.add(new Intersections.fromJson(v));
      });
    }
    drivingSide = json['driving_side'];
    geometry = json['geometry'] == null? null:json['geometry'].toString();
    mode = json['mode'];
    maneuver = json['maneuver'] != null
        ? new Maneuver.fromJson(json['maneuver'])
        : null;
    ref = json['ref'];
    weight = json['weight']== null? null: json['weight'].toDouble();
    duration = json['duration']== null? null: json['duration'].toDouble();
    name = json['name'];
    distance = json['distance']== null? null:json['distance'].toDouble();
    if (json['voiceInstructions'] != null) {
      voiceInstructions = [];
      json['voiceInstructions'].forEach((v) {
        voiceInstructions.add(new VoiceInstructions.fromJson(v));
      });
    }
    if (json['bannerInstructions'] != null) {
      bannerInstructions = [];
      json['bannerInstructions'].forEach((v) {
        bannerInstructions.add(new BannerInstructions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.intersections != null) {
      data['intersections'] =
          this.intersections.map((v) => v.toJson()).toList();
    }
    data['driving_side'] = this.drivingSide;
    data['geometry'] = this.geometry;
    data['mode'] = this.mode;
    if (this.maneuver != null) {
      data['maneuver'] = this.maneuver.toJson();
    }
    data['ref'] = this.ref;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['name'] = this.name;
    data['distance'] = this.distance;
    if (this.voiceInstructions != null) {
      data['voiceInstructions'] =
          this.voiceInstructions.map((v) => v.toJson()).toList();
    }
    if (this.bannerInstructions != null) {
      data['bannerInstructions'] =
          this.bannerInstructions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Intersections {
  int out;
  List<bool> entry;
  List<int> bearings;
  List<double> location;
  int inwhat;

  Intersections(
      {this.out, this.entry, this.bearings, this.location, this.inwhat});

  Intersections.fromJson(Map<String, dynamic> json) {
    out = json['out'];
    entry = json['entry'].cast<bool>();
    bearings = json['bearings'].cast<int>();
    location = json['location'].cast<double>();
    inwhat = json['in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['out'] = this.out;
    data['entry'] = this.entry;
    data['bearings'] = this.bearings;
    data['location'] = this.location;
    data['in'] = this.inwhat;
    return data;
  }
}

class Maneuver {
  int bearingAfter;
  int bearingBefore;
  List<double> location;
  String modifier;
  String type;
  String instruction;

  Maneuver(
      {this.bearingAfter,
      this.bearingBefore,
      this.location,
      this.modifier,
      this.type,
      this.instruction});

  Maneuver.fromJson(Map<String, dynamic> json) {
    bearingAfter = json['bearing_after'];
    bearingBefore = json['bearing_before'];
    location = json['location'].cast<double>();
    modifier = json['modifier'];
    type = json['type'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bearing_after'] = this.bearingAfter;
    data['bearing_before'] = this.bearingBefore;
    data['location'] = this.location;
    data['modifier'] = this.modifier;
    data['type'] = this.type;
    data['instruction'] = this.instruction;
    return data;
  }
}

class VoiceInstructions {
  double distanceAlongGeometry;
  String announcement;
  String ssmlAnnouncement;

  VoiceInstructions(
      {this.distanceAlongGeometry, this.announcement, this.ssmlAnnouncement});

  VoiceInstructions.fromJson(Map<String, dynamic> json) {
    distanceAlongGeometry = json['distanceAlongGeometry'];
    announcement = json['announcement'];
    ssmlAnnouncement = json['ssmlAnnouncement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distanceAlongGeometry'] = this.distanceAlongGeometry;
    data['announcement'] = this.announcement;
    data['ssmlAnnouncement'] = this.ssmlAnnouncement;
    return data;
  }
}

class BannerInstructions {
  double distanceAlongGeometry;
  Primary primary;
  Primary secondary;
  Null then;

  BannerInstructions(
      {this.distanceAlongGeometry, this.primary, this.secondary, this.then});

  BannerInstructions.fromJson(Map<String, dynamic> json) {
    distanceAlongGeometry = json['distanceAlongGeometry'];
    primary =
        json['primary'] != null ? new Primary.fromJson(json['primary']) : null;
    secondary = json['secondary'] != null
        ? new Primary.fromJson(json['secondary'])
        : null;
    then = json['then'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['distanceAlongGeometry'] = this.distanceAlongGeometry;
    if (this.primary != null) {
      data['primary'] = this.primary.toJson();
    }
    if (this.secondary != null) {
      data['secondary'] = this.secondary.toJson();
    }
    data['then'] = this.then;
    return data;
  }
}

class Primary {
  String text;
  List<Components> components;
  String type;
  String modifier;

  Primary({this.text, this.components, this.type, this.modifier});

  Primary.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    if (json['components'] != null) {
      components = [];
      json['components'].forEach((v) {
        components.add(new Components.fromJson(v));
      });
    }
    type = json['type'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    if (this.components != null) {
      data['components'] = this.components.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['modifier'] = this.modifier;
    return data;
  }
}

class Components {
  String text;

  Components({this.text});

  Components.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class Waypoints {
  String name;
  List<double> location;

  Waypoints({this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
