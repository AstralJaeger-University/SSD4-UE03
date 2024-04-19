(: Aufgabe 1.4 :)

declare namespace p = "http://www.fitness.at/person";

let $doc := fn:doc("ue3_1_fitnessdokument.xml")
for $pers in $doc//p:Person

  let $dob := $pers//@geburtsdatum
  let $birth := number(concat(substring($dob, 1, 4), substring($dob, 6, 2),
  substring($dob, 9, 2)))
  let $now := string(current-dateTime())
  let $current := number(concat(substring($now, 1, 4), substring($now, 6, 2),
  substring($now, 9, 2)))
  let $age := floor (($current - $birth) div 10000)

  let $vorTitel := data($pers//p:Titel[@position = "vor"])
  let $nachTitel := data($pers//p:Titel[@position = "nach"])
  
  return <Person>
          <Name>
              {
              $vorTitel,
              data($pers//p:Vorname),
              data($pers//p:Nachname), 
              $nachTitel
              }
          </Name>
          <Geburtsdatum age="{$age}">
              {
              data($pers//@geburtsdatum)
              }
          </Geburtsdatum>
      </Person>
