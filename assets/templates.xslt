<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" 
xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" 
xpath-default-namespace="http://www.fitness.at">
	<!--1a Binden Sie dieses XSLT in fitnessdokument.xslt ein und verwenden Sie die entsprechenden Templates-->
    <xsl:template name="printUserFormattedDateTime">
		<xsl:param name="dateTimeToFormat"/>
		<xsl:param name="dateToFormat"/>
		<xsl:variable name="dateTimeFormat" select="'[D]. [MNn] [Y] um [H01]:[m01] Uhr'"/>
		<xsl:variable name="dateFormat" select="'[D].[M].[Y]'"/>
		<xsl:variable name="language" select="'de'"/>
		<xsl:if test="exists($dateTimeToFormat) and ($dateTimeToFormat ne '')">
			<xsl:value-of select="format-dateTime($dateTimeToFormat, $dateTimeFormat, $language, (), ())"/>
		</xsl:if>
		<xsl:if test="exists($dateToFormat) and ($dateToFormat ne '')">
			<xsl:value-of select="format-date($dateToFormat, $dateFormat, $language, (), ())"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="printWertEinheit">
		<xsl:param name="messwerte"/>
		
		<xsl:for-each select="$messwerte">
			<xsl:variable name="messwert" select="."/>
			
			<xsl:if test="$messwert/../@typ = 'BlutdruckPuls'">
				<xsl:value-of select="concat($messwert/@typ, ': ')"/>
			</xsl:if>
		
			<xsl:variable name="wert" select="fn:number($messwert/@wert)"/>		
			<xsl:variable name="einheit" select="$messwert/@einheit"/>
	
			<!--1g Ergänzen Sie die Definition für den unteren bzw. oberen Schwellwert ausgehend vom Parameter messung. Sie können davon ausgehen, dass der Parameter messung einer Messung entspricht.-->
			<xsl:variable name="messung" select=".."/>
			<xsl:variable name="messwertTyp" select="$messwert/@typ"/>
			
            <xsl:variable name="untererSchwellwert" select="number(/Fitnessdokument/Grenzwertliste/Grenzwert[@typ = $messwertTyp and @von &lt;= $messung/@zeitpunkt and @bis &gt;= $messung/@zeitpunkt]/Schwellwert[@typ = 'unten']/@wert)"/>
            <xsl:variable name="obererSchwellwert" select="number(/Fitnessdokument/Grenzwertliste/Grenzwert[@typ = $messwertTyp and @von &lt;= $messung/@zeitpunkt and @bis &gt;= $messung/@zeitpunkt]/Schwellwert[@typ = 'oben']/@wert)"/>

            <!--2. Sonderfälle: abprüfen, ob Wert plausibel-->
			<xsl:if test="(exists($wert)) and ($wert >= 0)">
				<xsl:value-of select="$wert"/> 
			</xsl:if>
			
			<!--2. Sonderfälle: abprüfen, ob Einheit angegeben wird-->
			<xsl:if test="(exists($einheit)) and ($einheit ne '')">
				(<xsl:value-of select="$einheit"/>)	
			</xsl:if>
	
			<!--1h Ergänzen Sie: Liegt der Wert ober bzw. unterhalb der Schwellwerte soll ++ bzw. -\- angezeigt werden-->
            <xsl:if test="$wert &gt;= $obererSchwellwert">
                ++
            </xsl:if>
            <xsl:if test="$wert &lt;= $untererSchwellwert">
                --
            </xsl:if>

			<br/>
		</xsl:for-each>
	</xsl:template>
	
	
	
	<xsl:template name="getSeriennummerForMessgerätId">
		<xsl:param name="messung"/>	
		<xsl:value-of select="$messung/../../Messgeräte/Messgerät[@id=$messung/@messgerätId]/Seriennummer/text()"/>
	</xsl:template>

    <xsl:template name="Formatierung">
		<hr/>
	</xsl:template>
    

</xsl:stylesheet>
