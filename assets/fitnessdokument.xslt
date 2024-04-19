<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://www.fitness.at">
	<xsl:output method="html" encoding="UTF-8" indent="yes"/>
	<!--1a Binden Sie das templates.xslt in dieses XSLT ein, sodass die entsprechenden Templates verwendet werden können.-->



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



			</body>
		</html>
	</xsl:template>


	<!--1b Geben Sie zu Beginn die Basisdaten des Fitnessdokuments, sowie die Personendaten aus.-->	
	<xsl:template match="Fitnessdokument">
	
	</xsl:template>

	<!--1c Erstellen Sie ein benanntes Template printMessungTabelle. Als Parameter des Templates definieren und verwenden Sie den Messungs-Typ und die Messungen. Verwenden Sie nach Möglichkeit bereits vorgegebene benannte Templates printUserFormattedDateTime, printWertEinheit und getSeriennummerForMessgerätId. Sortieren Sie die einzelnen Messungen. -->
	
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



		</xsl:for-each-group>
	</xsl:template>


	
	<!--1e Ergänzen Sie Templates zur Ausgabe der Messgeräte bzw. des jeweiligen Messgeräts bzw. Gerätetyp, Hersteller, Modellnummer, Seriennummer-->




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



			</tbody>
		</table>
	</xsl:template>


	<xsl:template match="Medikation">
		<tr>
			<td>
				<b>

				</b>
			</td>
			<td>

			</td>
			<td>

			</td>
			<td>

			</td>
			<td>
				<xsl:if test="exists(@von)">
					<b>Start: </b>
					<xsl:call-template name="printUserFormattedDateTime">
						<xsl:with-param name="dateToFormat" select="@von"/>
					</xsl:call-template>
					<br/>
				</xsl:if>
				<xsl:if test="exists(@bis)">
					<b>Ende: </b>
					<xsl:call-template name="printUserFormattedDateTime">
						<xsl:with-param name="dateToFormat" select="@bis"/>
					</xsl:call-template>
					<br/>
				</xsl:if>
				<b>Anwendung: </b>


			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>