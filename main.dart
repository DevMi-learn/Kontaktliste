import 'dart:io';



class Person
{
  String name;
  int alter;
  int telefonnummer;

  Person(this.name, this.alter, this.telefonnummer);

  void ausgabe()
  {
    print("- Name: $name   Alter: $alter   Tel.Nr.: $telefonnummer");
  }
}


void main()
{
  List<Person> kontakte = [
    Person("Max", 22, 01234),
    Person("Hans", 34, 123),
    Person("Max", 33, 234),
    Person("Peter", 12, 345),
    Person("Petra", 21, 456),
    Person("Uwe", 56, 01234),
    Person("Max", 60, 567),
    Person("Petra", 22, 678),
    Person("max", 5, 1111),
    Person("Marion", 56, 45678)
  ];
  bool run = true;

  while(run)
  {
    String menuePunkt = menue();

    switch (menuePunkt)
    {
      case 'anlegen':
        print("------------------\n Kontakt anlegen:\n------------------");
      
        String name = nameEingabe();
        int alter = alterEingabe('Alter');
        int telefonNR = telefonNREingabe();

        if(kontakte.any((k) => k.name == name && k.alter == alter && k.telefonnummer == telefonNR))
        {
          print("\nDieser Kontakt existiert bereits.\n");
        }
        else
        {
          kontakte.add(Person(name, alter, telefonNR));
          print("");  
        }
      break;

      case 'löschen':
        print("------------------\n Kontakt löschen:\n------------------");
    
        String name = nameEingabe();
        int alter = alterEingabe('Alter');
        int telefonNR = telefonNREingabe();

        kontakte.removeWhere
        (
          (kontakt) =>
            kontakt.name == name &&
            kontakt.alter == alter &&
            kontakt.telefonnummer == telefonNR
        );
      break;

      case 'anzeigen':
        print("-----------\n Kontakte:\n-----------");
        zeigeKontakte(sortiereListe(kontakte));
      break;

      case 'suchen':
        String suchMenueAuswahl = suchMenue();

        switch (suchMenueAuswahl)
        {
          case 'name':
            String name = nameEingabe();
            sucheNachName(kontakte, name);
          break;

          case 'alterGenau':
            int alter = alterEingabe('Alter');
            sucheNachAlterGenau(kontakte, alter);
          break;

          case 'alterBereich':
            print("--------------\nAltersbereich:\n--------------\n");
            int alterMin = alterEingabe('Von');
            int alterMax = alterEingabe('Bis');
            sucheNachAlterBereich(kontakte, alterMin, alterMax);

          case 'telefon':
            int telefonNR = telefonNREingabe();
            sucheNachTelefonNR(kontakte, telefonNR);
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
String menue()
{
  print("-------\n Menue\n-------");
  print("Kontakt anlegen:   1");
  print("Kontakt löschen:   2");
  print("Kontakt(e) suchen: 3");
  print("Kontakte anzeigen: 4");
  print("Programm beenden:  5\n");

  while(true)
  {
    stdout.write("- ");
    String? eingabe = stdin.readLineSync()!;

    int? auswahl = int.tryParse(eingabe);
    if(auswahl != null && auswahl >= 1 && auswahl <= 5) 
    {
      print("");
      
      switch (auswahl)
      {
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

String suchMenue()
{
  print("-------------------\n Kontakt(e) suchen\n-------------------");
  print("suchen nach: ");
  print("Name:          1");
  print("Alter genau:   2");
  print("Alter bereich: 3");
  print("Tel.nummer:    4");
  print("Abbruch:       5\n");

  while(true)
  {
    stdout.write("- ");
    String? eingabe = stdin.readLineSync()!;

    int? auswahl = int.tryParse(eingabe);
    if(auswahl != null && auswahl >= 1 && auswahl <= 5) 
    {
      print("");

      switch (auswahl)
      {
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

String nameEingabe()
{
  while(true)
  {
    stdout.write("Name: ");
    String? nameEingabe = stdin.readLineSync();

    if(nameEingabe != null && nameEingabe.isNotEmpty)
    {
      int? name = int.tryParse(nameEingabe);
      if(name == null)
      {
        return nameEingabe;
      }
      else
      {
        print("ungültiger Name - Bitte keine Zahlen eingeben.\n");
      }
    }
  }
}

int alterEingabe(String ausgabeAnzeige)
{
  while(true)
  {
    stdout.write("$ausgabeAnzeige: ");
    String? alterEingabe = stdin.readLineSync();

    if(alterEingabe != null && alterEingabe.isNotEmpty)
    {
      if(int.tryParse(alterEingabe) != null)
      {
        int alter = int.parse(alterEingabe);
        if(alter >= 0)
        {
          return alter;
        }
      }
      else
      {
        print("ungültiges Alter - Bitte nur Zahlen eingeben.\n");
      }  
    }
  }
}

int telefonNREingabe()
{
  while(true)
  {
    stdout.write("Tel.Nr.: ");
    String? telefonEingabe = stdin.readLineSync();

    if(telefonEingabe != null && telefonEingabe.isNotEmpty)
    {
      if(int.tryParse(telefonEingabe) != null)
      {
        int telefonNR = int.parse(telefonEingabe);
        if(telefonNR >= 0)
        {
          return telefonNR;
        }
      }
      else
      {
        print("ungültige Telefonnummer - Bitte nur Zahlen eingeben.\n");
      }  
    }
  }
}


// Datenverabrbeitung
void sucheNachName(List<Person> kontakte, String name)
{
  var gefunden = kontakte.where((k) => k.name.toLowerCase().contains(name.toLowerCase())).toList();    
       
  if(gefunden.isEmpty)
  {
    print("Es konnte kein Kontakt unter dem Namen '$name' gefunden werden.\n");
    return;
  }
  
  zeigeKontakte(sortiereListe(gefunden));   
}

void sucheNachAlterGenau(List<Person> kontakte, int alter)
{
  var gefunden = kontakte.where((k) => k.alter == alter).toList();    
       
  if(gefunden.isEmpty)
  {
    print("Es konnte kein Kontakt unter dem Alter '$alter' gefunden werden.\n");
    return;
  }
  
  zeigeKontakte(gefunden);   
}

void sucheNachAlterBereich(List<Person> kontakte, int alterMin, int alterMax)
{
  var gefunden;

  if(alterMin > alterMax)
  {
    int tauschVar = alterMin;
    alterMin = alterMax;
    alterMax = tauschVar;
  }

  gefunden = kontakte.where((k) => k.alter >= alterMin && k.alter <= alterMax).toList();

  if(gefunden.isEmpty)
  {
    print("Es konnte kein Kontakt im Altersbereich zwischen '$alterMin' & '$alterMax' gefunden werden.\n");
    return;
  }

  zeigeKontakte(gefunden);
}

void sucheNachTelefonNR(List<Person> kontakte, int telefonNR)
{
  var gefunden = kontakte.where((k) => k.telefonnummer == telefonNR).toList();    
       
  if(gefunden.isEmpty)
  {
    print("Es konnte kein Kontakt unter der Nummer '$telefonNR' gefunden werden.\n");
    return;
  }
  
  zeigeKontakte(gefunden);   
}

List<Person> sortiereListe(List<Person> kontakte)
{
  var kopieKontakte = List<Person>.from(kontakte); // Erstellt Kopie - Alternative_var copy = [...kontakte]; 

  kopieKontakte.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return kopieKontakte;
}


// Ausgaben
void zeigeKontakte(List<Person> kontaktListe)
{
  int anzahl = kontaktListe.length;
  print("\n$anzahl Kontakte gefunden.\n");
  
  for(var k in kontaktListe)
  {
    k.ausgabe();
  }
  print("");
}
