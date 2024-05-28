
<?xml version="1.0" encoding="utf-8"?>

<!-- 
	XSL HTML TRANSFORM FOR OPML
	Created by Ruben Schade 2021-11-29, while on leave recovering from surgery
	Don't read too much into that!
-->

<xsl:stylesheet
	version="1.0"
	xml:lang="en-SG"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dcterms="http://purl.org/dc/terms/"
    extension-element-prefixes="str">

	<!-- Metadata about this file; xsl will ignore top-level elements it doesn't recognise -->
	<rdf:RDF>
		<rdf:Description rdf:about="https://rubenerd.com/opml.xsl">
			<dcterms:creator>Ruben Schade</dcterms:creator>
			<dcterms:title>Rubenerd OPML XSLT</dcterms:title>
			<dcterms:description>A template to transform OPML into HTML</dcterms:description>
			<dcterms:format>application/xslt+xml</dcterms:format>
			<dcterms:created>2021-11-29T13:00:00+11:00</dcterms:created>
			<dcterms:modified>2023-02-01T14:37:00+11:00</dcterms:modified>
			<dcterms:license rdf:resource="https://opensource.org/licenses/BSD-3-Clause"/>
			<dcterms:related rdf:resource="https://rubenerd.com/omake.opml"/>
		</rdf:Description>
	</rdf:RDF>

	<xsl:output method="html" indent="yes" media-type="text/html" encoding="utf-8" doctype-public="HTML" doctype-system=""/>

	<!-- Kludge to create permalinks from text titles (work-in-progress) -->
	<xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz--</xsl:variable>
	<xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ .</xsl:variable>

	<xsl:template match="/opml">
		<html lang="en-SG">
			<head>
				<title><xsl:value-of select="head/title"/></title>
				<link rel="outline" type="text/x-opml" href="{head/urlPublic}"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<style type="text/css">
					@charset "utf-8";
					body {
						background:white url("/haruhiism@2x.png") fixed bottom right no-repeat;
						background-size:140px 149px;
						border-top:10px solid #004599;
						color:black;
						font:1em "Helvetica Neue","Liberation Sans",Arial,sans-serif;
						line-height:24px;
						margin:0;
						overflow-y:scroll;
						padding:40px 40px 200px 40px
					}
					h1      { letter-spacing:-1px }
					a       { color:#009199 }
					a:hover { text-decoration:none }
					li      { list-style-type:disc }
					summary { 
						cursor:pointer;   /* indicate that it can be clicked on */
						font-weight:bold;
						line-height:26px;
					}
					#nav a { margin-right:0.6em }
					summary:hover { background-color:rgba(3,106,211,0.1) }
					summary:focus { outline:0 }

					/* Dave Winer's XML icon, approximated in CSS */
					.rss { 
						background:cornsilk;
						border:1px outset cornsilk;
						color:#ff6600;
						display:inline-block;
						font-size:10px;
						font-weight:bold;
						line-height:10px;
						margin-right:0.6em;
						padding:1px 6px;
						text-decoration:none;
					}
					.rss:hover {
						border:1px outset #ff6600;
						background-color:#ff6600;
						border:1px solid #8d3901;
						border-top-color:#ffbb8f;
						border-left-color:#ffbb8f;
						color:white;
					}

					/* Retina-grade displays */
					@media (min-resolution: 144dpi) {
						background-image:url("/haruhiism@2x.png");
						background-size:140px 149px;
					}

					/* Dark mode displays */
					@media (prefers-color-scheme: dark) {
						body { 
							background-color:black;
							border-top:10px solid maroon;
							color:darkgrey
						}
						summary:hover { background: midnightblue }
						h1,summary { color:white }
						a { color:skyblue }
					}
				</style>
			</head>
			<body>
				<h1><xsl:value-of select="head/title"/></h1>
				<p id="nav">
					<a href="/">Blog</a>
					<a href="/feed/">RSS</a>
					<a href="/blogroll.opml">Blogroll</a>
					<a href="/omake.xml">Omake</a>
					<a href="http://sasara.moe/">Sasara</a>
				</p>
				<p><xsl:value-of select="head/description"/></p> 
				<xsl:apply-templates select="body/outline"/>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="outline">
		<xsl:choose>
			<xsl:when test="@type">
				<xsl:choose>
					<xsl:when test="@xmlUrl">
						<li>
							<a class="rss" href="{@xmlUrl}">XML</a>
								<xsl:choose>
									<xsl:when test="@htmlUrl">
										<a href="{@htmlUrl}"><xsl:value-of select="@text"/></a>
									</xsl:when>
									<xsl:otherwise>
										<a href="{@xmlUrl}"><xsl:value-of select="@text"/></a>
									</xsl:otherwise>
								</xsl:choose>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li>
							<a href="{@url}"><xsl:value-of select="@text"/></a>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- Check if there are any child elements that will need expanding -->
					<xsl:when test="*">
						<!-- Create permalink, removing the emoji -->
						<xsl:variable name="Permalink" select="translate(@text,$uppercase,$lowercase)" />
						<details id="{$Permalink}">
							<summary>
								<xsl:value-of select="@text"/>
							</summary>
							<ul>
								<xsl:apply-templates select="outline"/>
							</ul>
						</details>
					</xsl:when>
					<xsl:otherwise>
						<li>
							<xsl:value-of select="@text"/>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
