<xsl:stylesheet version="1.0"
                exclude-result-prefixes="msxml js"
                xmlns="http://www.loc.gov/MARC21/slim"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxml="urn:schemas-microsoft-com:xslt"
                xmlns:js="javascript:code"
                >
  <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
  <xsl:strip-space elements="*"/>

  <!--
  Transformation from UNIMARC XML representation to MARCXML.
  Based upon http://www.loc.gov/marc/unimarctomarc21.html
  
  -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="//collection">
        <collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
          <xsl:for-each select="//collection/record">
            <record>
              <xsl:call-template name="record"/>
            </record>
          </xsl:for-each>
        </collection>
      </xsl:when>
      <xsl:otherwise>
        <record xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
          <xsl:for-each select="//record">
            <xsl:call-template name="record"/>
          </xsl:for-each>
        </record>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="record">
    <xsl:call-template name="transform-leader"/>
    <xsl:call-template name="copy-control">
      <xsl:with-param name="tag">001</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="copy-control">
      <xsl:with-param name="tag">005</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="transform-100"/>

    <!-- 200->245 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">200</xsl:with-param>
      <xsl:with-param name="dstTag">245</xsl:with-param>
      <xsl:with-param name="srcCodes">aefb</xsl:with-param>
      <xsl:with-param name="dstCodes">abch</xsl:with-param>
    </xsl:call-template>

    <!-- 210->260 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">210</xsl:with-param>
      <xsl:with-param name="dstTag">260</xsl:with-param>
      <xsl:with-param name="srcCodes">acd</xsl:with-param>
      <xsl:with-param name="dstCodes">abc</xsl:with-param>
    </xsl:call-template>

    <!-- 215->300 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">215</xsl:with-param>
      <xsl:with-param name="dstTag">300</xsl:with-param>
      <xsl:with-param name="srcCodes">acde</xsl:with-param>
      <xsl:with-param name="dstCodes">abce</xsl:with-param>
    </xsl:call-template>

    <!-- 615->650 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">615</xsl:with-param>
      <xsl:with-param name="dstTag">650</xsl:with-param>
      <xsl:with-param name="srcCodes">ax</xsl:with-param>
    </xsl:call-template>

    <!-- 615->072 -->
    <xsl:call-template name="transform-datafield">
      <xsl:with-param name="srcTag">615</xsl:with-param>
      <xsl:with-param name="dstTag">072</xsl:with-param>
      <xsl:with-param name="srcCodes">nm</xsl:with-param>
      <xsl:with-param name="dstCodes">ax</xsl:with-param>
    </xsl:call-template>

    <!-- 700->100 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">700</xsl:with-param>
      <xsl:with-param name="dstTag">100</xsl:with-param>
    </xsl:call-template>

    <!-- 701->700 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">701</xsl:with-param>
      <xsl:with-param name="dstTag">700</xsl:with-param>
    </xsl:call-template>

    <!-- 702->700 -->
    <xsl:call-template name="transform-personal-name">
      <xsl:with-param name="srcTag">702</xsl:with-param>
      <xsl:with-param name="dstTag">700</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="transform-leader">
    <xsl:variable name="leader" select="leader"/>
    <xsl:variable name="leader05" select="translate(js:part($leader,05,05), 'o', 'c')"/>
    <xsl:variable name="leader06" select="translate(js:part($leader,06,06), 'hmn', 'aor')"/>
    <xsl:variable name="leader07" select="js:part($leader,07,07)"/>
    <xsl:variable name="leader08-16" select="'  22     '"/>
    <xsl:variable name="leader17" select="translate(js:part($leader,17,17), '23', '87')"/>
    <xsl:variable name="leader18" select="translate(js:part($leader,18,18), ' n', 'i ')"/>
    <xsl:variable name="leader19-23" select="' 4500'"/>
    <leader>
      <xsl:value-of select="concat('     ', $leader05, $leader06, $leader07, $leader08-16, $leader17, $leader18, $leader19-23)"/>
    </leader>
  </xsl:template>
  <xsl:template name="copy-control">
    <xsl:param name="tag"/>
    <xsl:for-each select="controlfield[@tag=$tag]">
      <controlfield>
        <xsl:attribute name="tag">
          <xsl:value-of select="$tag"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </controlfield>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="transform-100">
    <xsl:variable name="source" select="datafield[@tag='100']/subfield[@code='a']"/>
    <xsl:variable name="dest00-05" select="js:part($source,02,07)"/>
    <xsl:variable name="dest06" select="translate(js:part($source,08,08), 'abcdefghij', 'cdusrqmtpe')"/>
    <xsl:variable name="dest07-14" select="js:part($source,09,16)"/>
    <xsl:variable name="dest15-21" select="'       '"/>
    <xsl:variable name="dest22" select="translate(js:part($source,17,17), 'bcadekmu', 'abjcdeg ')"/>
    <xsl:variable name="dest23-27" select="'     '"/>
    <xsl:variable name="dest28" select="translate(js:part($source,20,20), 'abcdefghy', 'fsllcizo ')"/>
    <xsl:variable name="dest29-32" select="'    '"/>
    <xsl:variable name="dest33" select="js:part($source,34,34)"/>
    <xsl:variable name="dest34-37" select="'    '"/>
    <xsl:variable name="dest38" select="translate(js:part($source,21,21), '01', ' o')"/>
    <xsl:variable name="dest39-40" select="'  '"/>
    <controlfield tag="008">
      <xsl:value-of select="concat($dest00-05, $dest06, $dest07-14, $dest15-21, $dest22, $dest23-27, $dest28, $dest29-32, $dest33, $dest34-37, $dest38, $dest39-40)"/>
    </controlfield>
  </xsl:template>
  <xsl:template name="transform-datafield">
    <xsl:param name="srcTag"/>
    <xsl:param name="dstTag" select="@srcTag"/>
    <xsl:param name="srcCodes"/>
    <xsl:param name="dstCodes"/>
    <xsl:if test="datafield[@tag=$srcTag]/subfield[contains($srcCodes, @code)]">
      <xsl:for-each select="datafield[@tag=$srcTag]">
        <datafield>
          <xsl:attribute name="tag">
            <xsl:value-of select="$dstTag"/>
          </xsl:attribute>
          <xsl:call-template name="copy-indicators"/>
          <xsl:call-template name="transform-subfields">
            <xsl:with-param name="srcCodes" select="$srcCodes"/>
            <xsl:with-param name="dstCodes" select="$dstCodes"/>
          </xsl:call-template>
        </datafield>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  <xsl:template name="transform-personal-name">
    <xsl:param name="srcTag"/>
    <xsl:param name="dstTag"/>

    <xsl:for-each select="datafield[@tag=$srcTag]">
      <datafield>
        <xsl:attribute name="tag">
          <xsl:value-of select="$dstTag"/>
        </xsl:attribute>
        <xsl:attribute name="ind1">
          <xsl:value-of select="@ind2"/>
        </xsl:attribute>
        <xsl:attribute name="ind2" />
        <xsl:call-template name="transform-subfields">
          <xsl:with-param name="srcCodes" select="'acdfpg'"/>
          <xsl:with-param name="dstCodes" select="'acbduq'"/>
        </xsl:call-template>
      </datafield>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="copy-indicators">
    <xsl:attribute name="ind1">
      <xsl:value-of select="translate(@ind1, '#', '')"/>
    </xsl:attribute>
    <xsl:attribute name="ind2">
      <xsl:value-of select="translate(@ind2, '#', '')"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="transform-subfields">
    <xsl:param name="srcCodes">abcdefghijklmnopqrstuvwxyz</xsl:param>
    <xsl:param name="dstCodes" select="$srcCodes"/>
    <xsl:for-each select="subfield[contains($srcCodes, @code)]">
      <subfield>
        <xsl:attribute name="code">
          <xsl:value-of select="translate(@code, $srcCodes, $dstCodes)"/>
        </xsl:attribute>
        <xsl:value-of select="text()"/>
      </subfield>
    </xsl:for-each>
  </xsl:template>

  <msxml:script implements-prefix="js">
    function part(source : String, from : int, to : int)
    {
      return source.substring(from, to + 1);
    }
  </msxml:script>
</xsl:stylesheet>