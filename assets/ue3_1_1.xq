(: Aufgabe 1.1 :)
declare default element namespace "http://www.fitness.at/fitness";

<M>
  {
    let $doc := doc("ue3_1_fitnessdokument.xml")
    let $mss := $doc//Fitnessdokument//Vitaldaten//Messung//Messwert
    for $mw in $mss
      where $mw//@typ = "Gewicht"
      return element Messwert {
        attribute typ { $mw/@typ },
        attribute wert { $mw/@wert },
        attribute einheit { $mw/@einheit }
      }
  }
</M>
