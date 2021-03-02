class Rjecnik {
  int id;
  String title;
  String grp;
  String lng;
  String icon;
  String icontitle;
  int def;

  Rjecnik(this.title, this.grp, this.lng, this.icon, this.icontitle, this.def);

  Rjecnik.withId(
      {this.id,
      this.title,
      this.grp,
      this.lng,
      this.icon,
      this.icontitle,
      this.def});

  int get idGet => id;
  String get titleGet => title;
  String get grpGet => grp;
  String get lngGet => lng;
  String get iconGet => icon;
  String get icontitleGet => icontitle;
  int get defGet => def;

// Sets
  set titleSet(String newTitle) {
    if (newTitle.length <= 255) {
      this.title = newTitle;
    }
  }

  set grpSet(String newgrp) {
    this.grp = newgrp;
  }

  set lngSet(String newlng) {
    this.lng = newlng;
  }

  set iconSet(String newIcon) {
    if (newIcon.length <= 255) {
      this.icon = newIcon;
    }
  }

  set icontitleSet(String newIconTitle) {
    if (newIconTitle.length <= 255) {
      this.icontitle = newIconTitle;
    }
  }

  set defSet(int newdef) {
    this.def = newdef;
  }

  // Convert a Rjecnik object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['grp'] = grp;
    map['lng'] = lng;
    map['icon'] = icon;
    map['icontitle'] = icontitle;
    map['def'] = def;
    return map;
  }

  // Extract a Rjecnik object from a Map object
  Rjecnik.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.grp = map['grp'];
    this.lng = map['lng'];
    this.icon = map['icon'];
    this.icontitle = map['icontitle'];
    this.def = map['def'];
  }


}
