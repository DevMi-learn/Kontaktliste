import 'dart:io';
import 'dart:convert';

class Kontakt {
  String name;
  int alter;
  String telefonnummer;

  Kontakt(this.name, this.alter, this.telefonnummer);

  void ausgabe() {
    print("- Name: $name   Alter: $alter   Tel.Nr.: $telefonnummer");
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'alter': alter, 'telefonnummer': telefonnummer};
  }

  Kontakt.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      alter = json['alter'],
      telefonnummer = json['telefonnummer'];
}

Future<void> main() async {
  bool run = true;
  String speicherdatei = 'kontakte.json';
  List<Kontakt> kontaktListe = await ladeKontakte(speicherdatei);

  while (run) {
    String menuePunkt = menue();

    switch (menuePunkt) {
      case 'anlegen':
        print("------------------\n Kontakt anlegen:\n------------------");

        Kontakt neuerKontakt = kontaktEigeben();

        if (checkDuplikate(kontaktListe, neuerKontakt)) {
          print("\nDieser Kontakt existiert bereits.\n");
        } else {
          kontaktListe.add(neuerKontakt);
          print("");
        }
        break;

      case 'löschen':
        print("------------------\n Kontakt löschen:\n------------------");

        Kontakt neuerKontakt = kontaktEigeben();

        kontaktListe.removeWhere(
          (kontakt) =>
              kontakt.name.toLowerCase() == neuerKontakt.name &&
              kontakt.alter == neuerKontakt.alter &&
              kontakt.telefonnummer == neuerKontakt.telefonnummer,
        );

        break;

      case 'anzeigen':
        print("-----------\n Kontakte:\n-----------");
        zeigeKontakte(sortiereListe(kontaktListe));
        break;

      case 'suchen':
        String suchMenueAuswahl = suchMenue();

        switch (suchMenueAuswahl) {
          case 'name':
            sucheNachName(kontaktListe, nameEingabe());
            break;

          case 'alterGenau':
            sucheNachAlterGenau(kontaktListe, alterEingabe('Alter'));
            break;

          case 'alterBereich':
            print("--------------\nAltersbereich:\n--------------\n");
            sucheNachAlterBereich(
              kontaktListe,
              alterEingabe('Von'),
              alterEingabe('Bis'),
            );
            break;

          case 'telefon':
            sucheNachTelefonNR(kontaktListe, telefonNREingabe());
            break;

          case 'abbruch':
            print("Suche abgebrochen.\n");
            break;

          default:
            print("\nERROR SUCHMENÜ-AUSWAHL!");
            break;
        }
        break;

      case 'beenden':
        await speicherKontakte(kontaktListe, speicherdatei);
        run = false;
        print("-------------------\n Programm beendet.\n-------------------\n");
        break;

      default:
        print("\nERROR Menüpunkt!");
        break;
    }
  }
}

// Eingaben
String menue() // Haupt- & Startmenü
{
  print("-------\n Menue\n-------");
  print("Kontakt anlegen:   1");
  print("Kontakt löschen:   2");
  print("Kontakt(e) suchen: 3");
  print("Kontakte anzeigen: 4");
  print("Programm beenden:  5\n");

  while (true) {
    stdout.write("- ");
    String? eingabe = stdin.readLineSync()!;

    int? auswahl = int.tryParse(eingabe);
    if (auswahl != null && auswahl >= 1 && auswahl <= 5) {
      print("");

      switch (auswahl) {
        case 1:
          return 'anlegen';

        case 2:
          return 'löschen';

        case 3:
          return 'suchen';

        case 4:
          return 'anzeigen';

        case 5:
          return 'beenden';

        default:
          print("\nERROR MENÜ-EINGABE!");
          break;
      }
    }
  }
}

String suchMenue() // Untermenü für die Suche von Kontakten
{
  print("-------------------\n Kontakt(e) suchen\n-------------------");
  print("suchen nach: ");
  print("Name:          1");
  print("Alter genau:   2");
  print("Alter bereich: 3");
  print("Tel.nummer:    4");
  print("Abbruch:       5\n");

  while (true) {
    stdout.write("- ");
    String? eingabe = stdin.readLineSync()!;

    int? auswahl = int.tryParse(eingabe);
    if (auswahl != null && auswahl >= 1 && auswahl <= 5) {
      print("");

      switch (auswahl) {
        case 1:
          return 'name';

        case 2:
          return 'alterGenau';

        case 3:
          return 'alterBereich';

        case 4:
          return 'telefon';

        case 5:
          return 'abbruch';

        default:
          print("\nERROR SUCHMENÜ-Eingabe");
          break;
      }
    }
  }
}

Kontakt kontaktEigeben() // Legt einen neuen eingegebenen Kontakt an
{
  Kontakt neuerKontakt = Kontakt("name", 0, "tel");

  neuerKontakt.name = nameEingabe();
  neuerKontakt.alter = alterEingabe('Alter');
  neuerKontakt.telefonnummer = telefonNREingabe();

  return neuerKontakt;
}

String nameEingabe() {
  while (true) {
    stdout.write("Name: ");
    String? nameEingabe = stdin.readLineSync();

    if (nameEingabe != null && nameEingabe.isNotEmpty) {
      int? name = int.tryParse(nameEingabe);
      if (name == null) {
        return nameEingabe;
      } else {
        print("ungültiger Name - Bitte keine Zahlen eingeben.\n");
      }
    }
  }
}

int alterEingabe(String ausgabeAnzeige) {
  while (true) {
    stdout.write("$ausgabeAnzeige: ");
    String? alterEingabe = stdin.readLineSync();

    if (alterEingabe != null && alterEingabe.isNotEmpty) {
      if (int.tryParse(alterEingabe) != null) {
        int alter = int.parse(alterEingabe);
        if (alter >= 0) {
          return alter;
        }
      } else {
        print("ungültiges Alter - Bitte nur Zahlen eingeben.\n");
      }
    }
  }
}

String telefonNREingabe() {
  while (true) {
    stdout.write("Tel.Nr.: ");
    String? telefonEingabe = stdin.readLineSync();

    if (telefonEingabe != null && telefonEingabe.isNotEmpty) {
      return telefonEingabe;
    } else {
      print("ungültige Telefonnummer - Bitte nur Zahlen eingeben.\n");
    }
  }
}

// Datenverabrbeitung
void sucheNachName(List<Kontakt> kontaktListe, String name) {
  var gefunden = kontaktListe
      .where(
        (kontakt) => kontakt.name.toLowerCase().contains(name.toLowerCase()),
      )
      .toList();

  if (gefunden.isEmpty) {
    print("Es konnte kein Kontakt unter dem Namen '$name' gefunden werden.\n");
    return;
  }

  zeigeKontakte(sortiereListe(gefunden));
}

void sucheNachAlterGenau(List<Kontakt> kontaktListe, int alter) {
  var gefunden = kontaktListe
      .where((kontakt) => kontakt.alter == alter)
      .toList();

  if (gefunden.isEmpty) {
    print("Es konnte kein Kontakt unter dem Alter '$alter' gefunden werden.\n");
    return;
  }

  zeigeKontakte(gefunden);
}

void sucheNachAlterBereich(
  List<Kontakt> kontaktListe,
  int alterMin,
  int alterMax,
) {
  var gefunden;

  if (alterMin > alterMax) {
    int tauschVar = alterMin;
    alterMin = alterMax;
    alterMax = tauschVar;
  }

  gefunden = kontaktListe
      .where(
        (kontakt) => kontakt.alter >= alterMin && kontakt.alter <= alterMax,
      )
      .toList();

  if (gefunden.isEmpty) {
    print(
      "Es konnte kein Kontakt im Altersbereich zwischen '$alterMin' & '$alterMax' gefunden werden.\n",
    );
    return;
  }

  zeigeKontakte(gefunden);
}

void sucheNachTelefonNR(List<Kontakt> kontaktListe, String telefonNR) {
  var gefunden = kontaktListe
      .where((kontakt) => kontakt.telefonnummer == telefonNR)
      .toList();

  if (gefunden.isEmpty) {
    print(
      "Es konnte kein Kontakt unter der Nummer '$telefonNR' gefunden werden.\n",
    );
    return;
  }

  zeigeKontakte(gefunden);
}

List<Kontakt> sortiereListe(List<Kontakt> kontaktListe) {
  var kopieKontaktListe = List<Kontakt>.from(
    kontaktListe,
  ); // Erstellt Kopie - Alternative_var copy = [...kontaktListe];

  kopieKontaktListe.sort(
    (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
  );
  return kopieKontaktListe;
}

bool checkDuplikate(
  List kontaktListe,
  Kontakt neuerKontakt,
) // Prüft ob ein Kontakt schon existiert
{
  if (kontaktListe.any(
    (kontakt) =>
        kontakt.name.toLowerCase() == neuerKontakt.name.toLowerCase() &&
        kontakt.alter == neuerKontakt.alter &&
        kontakt.telefonnummer == neuerKontakt.telefonnummer,
  )) {
    return true;
  }

  return false;
}

// Speichern & Laden
Future<void> speicherKontakte(
  List<Kontakt> kontakteListe,
  String dateiname,
) async {
  var jsonListe = kontakteListe
      .map((kontakt) => kontakt.toJson())
      .toList(); //Liste(Person) zu Liste(Map)

  String jsonString = jsonEncode(jsonListe); //Liste(Map) zu String

  File datei = File(dateiname);
  await datei.writeAsString(jsonString); //String zu Datei

  print("Kontakte erfolgreich gespeichert.\n");
}

Future<List<Kontakt>> ladeKontakte(String dateiname) async {
  try {
    String jsonString = await File(dateiname).readAsString(); //Datei zu String
    List<dynamic> jsonListe = jsonDecode(jsonString); //String zu Liste(Map)
    return jsonListe
        .map((eintrag) => Kontakt.fromJson(eintrag))
        .toList(); //Liste(Map) zu Liste(Person)
  } catch (e) {
    print("Fehler beim Laden: $e");
    return []; // Leere Liste zurückgeben, wenn Datei fehlt oder fehlerhaft
  }
}

// Ausgaben
void zeigeKontakte(List<Kontakt> kontaktListe) {
  int anzahl = kontaktListe.length;
  print("\n$anzahl Kontakte gefunden.\n");

  for (var kontakt in kontaktListe) {
    kontakt.ausgabe();
  }
  print("");
}
