declare namespace fitness="http://www.fitness.at/fitness";

<fitness:M xmlns="http://www.fitness.at/fitness">
{
  for $mw in doc("ue3_1_fitnessdokument.xml") //fitness:Messwert
  where $mw/@typ = "Gewicht"
  order by $mw/@wert descending
  return $mw
}
</fitness:M>
