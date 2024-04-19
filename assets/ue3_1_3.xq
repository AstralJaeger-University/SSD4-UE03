(: Aufgabe 1.3 :)

declare default element namespace "http://www.fitness.at/fitness";

<Aktivität>
  {
    let $doc := doc("ue3_1_fitnessdokument.xml")

    let $devices := $doc//Messgeräte//Messgerät
    for $device in $devices
    let $deviceId := data($device//@id)
    let $measurements := $doc//Fitnessdokument//Vitaldaten//Messung[@messgerätId = $deviceId]
    where count($measurements) >= 2

    return <Gerät id="{$deviceId}">{
      for $measurement in $measurements
      return <Online>{data($measurements//@zeitpunkt)}</Online>
  }</Gerät>
  }
</Aktivität>