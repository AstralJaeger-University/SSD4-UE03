<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://www.fitness.at">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<!--1a Binden Sie das templates.xslt in dieses XSLT ein, sodass die entsprechenden Templates verwendet werden können.-->
	<xsl:include href="templates.xslt"/>

	<xsl:template match="/">
		<html>
			<head>
				<meta charset="UTF-8"/>
				<title>Fitnessdokument</title>
				<style type="text/css">
					table.t2 {
						border-collapse: collapse;
					}
					.t2 caption {
						padding-bottom: 0.5em;
						font-weight: bold;
						font-size: 16px;
					}
					.t2 th, .t2 td {
						padding: 4px 8px;
						border: 2px solid #fff;
						background: #bdd2d9;
					}
					.t2 thead th {
						padding: 2px 8px;
						background: #328da8;
						text-align: left;
						font-weight: bold;
						color: #fff;
					}
					.t2 tr *:nth-child(3), .t2 tr *:nth-child(4) {
						text-align: right;
					}
				</style>
			</head>
			<body>
				<!--1b Geben Sie zu Beginn die Basisdaten des Fitnessdokuments, sowie die Personendaten aus.-->	
				<xsl:apply-templates select="/Fitnessdokument"/>
			</body>
		</html>
	</xsl:template>

	<!--1b Geben Sie zu Beginn die Basisdaten des Fitnessdokuments, sowie die Personendaten aus.-->	
	<xsl:template match="Fitnessdokument">
		<h1>Fitnessdokument (Version <xsl:value-of select="@version" />) vom <xsl:call-template name="printUserFormattedDateTime"><xsl:with-param name="dateTimeToFormat" select="@erzeugt" /></xsl:call-template></h1>
        <hr></hr>
        <h2>Persönliche Daten</h2>
        <br></br>
		<xsl:apply-templates select="Person"/>
        <hr></hr>
        <xsl:apply-templates select="Vitaldaten" />
        <xsl:apply-templates select="Messgeräte" />
        <hr></hr>
        <xsl:apply-templates select="Medikationsliste" />
	</xsl:template>

	<xsl:template match="Person">
        <p>
          <xsl:value-of select="Titel[@position='vor']" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="Vorname" />
          <xsl:text> </xsl:text>
          <xsl:value-of select="Nachname" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="Titel[@position='nach']" />
        </p>
        
        <p>
          <b>Geschlecht:</b>
          <xsl:value-of select="@geschlecht" />
          <xsl:text> | </xsl:text>
          <b>geboren am: </b>
          <xsl:value-of select="format-date(@geburtsdatum, '[D01].[M1].[Y0001]')"></xsl:value-of>
          <xsl:text> | </xsl:text>
          <b>SVNR:</b>
          <xsl:value-of select="@svnr" />
        </p>
	</xsl:template>

	<!--1c Erstellen Sie ein benanntes Template printMessungTabelle.-->
	<xsl:template name="printMessungTabelle">
		<xsl:param name="messungTyp"/>
		<xsl:param name="messungen"/>
        
        <table class="t2">
            <thead>
                <tr>
                    <th>Zeitpunkt</th>
                    <th><xsl:value-of select="$messungTyp" /></th>
                    <th>Notiz/Messbedingung</th>
                    <th>Messgerät (SNr.)</th>
                </tr>
            </thead>
        
            <tbody>
                <xsl:for-each select="$messungen">
                    <xsl:sort select="@zeitpunkt"/>
                    <xsl:variable name="zeitpunkt" select="@zeitpunkt"/>
                    <xsl:variable name="wert" select="Messwert"/>
                    <xsl:variable name="notiz" select="Notiz | Messbedingung"/>
                    <xsl:variable name="messgerätId" select="@messgerätId"/>
                    <xsl:variable name="messgerät" select="/Fitnessdokument/Messgeräte/Messgerät[@id=$messgerätId]"/>
                    <tr>
                        <td><xsl:call-template name="printUserFormattedDateTime"><xsl:with-param name="dateTimeToFormat" select="$zeitpunkt"/></xsl:call-template></td>
                        <td><xsl:call-template name="printWertEinheit"><xsl:with-param name="messwerte" select="$wert" /></xsl:call-template></td>
                        <td><xsl:value-of select="$notiz"/></td>
                        <td><xsl:value-of select="$messgerätId"/> (<xsl:value-of select="$messgerät/Seriennummer"/>)</td>
                    </tr>
                </xsl:for-each>
            </tbody>
        </table>
	</xsl:template>

	<!--1d Wird der Knoten Vitaldaten selektiert, rufen Sie das neue Template printMessungTabelle auf.-->
	<xsl:template match="Vitaldaten">
    	<xsl:for-each-group select="./Messung" group-by="@typ">
			<xsl:variable name="typ">
				<xsl:choose>
					<xsl:when test="current-grouping-key()='BlutdruckPuls'">Blutdruck</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="current-grouping-key()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<h2>
				<xsl:value-of select="$typ"/>
			</h2>

            <xsl:call-template name="printMessungTabelle">
                <xsl:with-param name="messungTyp" select="$typ" />
                <xsl:with-param name="messungen" select="current-group()" />
            </xsl:call-template>
		</xsl:for-each-group>
	</xsl:template>

	<!--1e Ergänzen Sie Templates zur Ausgabe der Messgeräte bzw. des jeweiligen Messgeräts bzw. Gerätetyp, Hersteller, Modellnummer, Seriennummer-->
	<xsl:template match="Messgeräte">
        <h2>Messgeräte</h2>
        
        <table class="t2">
        	<thead>
        		<tr>
        			<th>Gerätetyp</th>
        			<th>Hersteller</th>
        			<th>Modellnummer</th>
        			<th>Seriennummer</th>
        		</tr>
        	</thead>
            
        	<tbody>
                <xsl:for-each select="Messgerät">
            		<tr>
                		<th><xsl:value-of select="Gerätetyp" /></th>
            			<th><xsl:value-of select="Hersteller" /></th>
            			<th><xsl:value-of select="Modellnummer" /></th>
            			<th><xsl:value-of select="Seriennummer" /></th>
            		</tr>
                </xsl:for-each>
        	</tbody>
        </table>
	</xsl:template>

	<!--1f Ergänzen Sie die jeweiligen Templates, sodass die Medikationsliste bzw. die Medikation entsprechend der Vorgabe ausgegeben wird-->
	<xsl:template match="Medikationsliste">
		<h2>Medikationsliste</h2>
		<table class="t2">
			<thead>
				<tr>
					<th>Medikament</th>
					<th>Einnahme</th>
					<th>Dosierung</th>
					<th>Hinweis</th>
					<th>Zusatzinformation</th>
				</tr>
			</thead>
			<tbody>
				<xsl:apply-templates/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="Medikation">
		<tr>
			<td><b><xsl:value-of select="."/></b></td>
			<td><xsl:value-of select="@einnahme"/></td>
			<td><xsl:value-of select="@dosierung"/></td>
			<td><xsl:value-of select="@hinweis"/></td>
			<td>
				<xsl:if test="@von">
					<b>Start: </b><xsl:value-of select="@von"/>
					<br/>
				</xsl:if>
				<xsl:if test="@bis">
					<b>Ende: </b><xsl:value-of select="@bis"/>
					<br/>
				</xsl:if>
				<b>Anwendung: </b><xsl:value-of select="@anwendung"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
