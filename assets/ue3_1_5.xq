(: Aufgabe 1.5 :)

declare default element namespace "http://www.fitness.at/fitness";

<Vitalwerte>{
let $doc := fn:doc("ue3_1_fitnessdokument.xml")
let $limits := $doc//Fitnessdokument//Grenzwertliste//Grenzwert
let $measurements := $doc//Fitnessdokument//Vitaldaten//Messung

for $measurement in $measurements
let $typ := data($measurement//@typ)

return element { node-name($measurement) } {
  $measurement/@*,
  if ($limits//@typ = $typ)
  then if (xs:decimal(data($limits[@typ = $typ]//Schwellwert[@unten]//@wert)) < xs:decimal(data($measurement//Messwert//@wert)))
    then attribute flag { "L" }
    else if (xs:decimal(data($limits[@typ = $typ]//Schwellwert[@oben]//@wert)) > xs:decimal(data($measurement//Messwert//@wert)))
      then attribute flag { "H" }
      else ()
  else (),
  
  for $node in $measurement/node()
  where not(local-name($node) = "Notiz")
  
  return $node
}

}</Vitalwerte>