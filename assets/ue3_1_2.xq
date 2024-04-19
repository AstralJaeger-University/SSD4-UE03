(: Aufgabe 1.2 :)
declare default element namespace "http://www.fitness.at/fitness";

<RR xmlns="http://www.fitness.at/fitness">
  {
    let $doc := doc("ue3_1_fitnessdokument.xml")
    let $mss := $doc//Fitnessdokument//Vitaldaten//Messung
    for $ms in $mss
      where lower-case($ms//Notiz) = "maschinell" and $ms//@typ = "BlutdruckPuls"
      
      return element Blutdruck {
        attribute zeit { $ms/@zeitpunkt },
        element Sys {
          data($ms//Messwert[@typ="Systolisch"]//@wert)
        },
        element Dia {
          data($ms//Messwert[@typ="Diastolisch"]//@wert)
        }
      }
  }
</RR>
