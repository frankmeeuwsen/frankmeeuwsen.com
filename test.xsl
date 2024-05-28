<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="yes" />

  <xsl:template match="/">
    <xsl:for-each select="/rss/channel/item">
    <div>
      <h2><xsl:value-of select="title" /></h2>
      <p>
        <xsl:variable name="description" select="description" />
        <xsl:variable name="truncated">
          <xsl:call-template name="truncate-description">
            <xsl:with-param name="text" select="$description" />
          </xsl:call-template>
        </xsl:variable>
        <xsl:value-of disable-output-escaping="yes" select="$truncated" />
      </p>
    </div>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="truncate-description">
    <xsl:param name="text" />
    <xsl:variable name="words" select="tokenize($text, ' ')" />
    <xsl:variable name="first-30-words" select="string-join(subsequence($words, 1, 30), ' ')" />
    <xsl:variable name="truncated-text">
      <xsl:choose>
        <xsl:when test="contains($first-30-words, '&lt;')">
          <xsl:value-of select="substring-before($first-30-words, '&lt;')" />
          <xsl:value-of select="substring-before(substring-after($first-30-words, '&lt;'), '&gt;')" />
          <xsl:text>&lt;/</xsl:text>
          <xsl:value-of select="substring-before(substring-after($first-30-words, '&lt;'), '&gt;')" />
          <xsl:text>&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$first-30-words" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$truncated-text" />
  </xsl:template>
</xsl:stylesheet>
