<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:vcard="http://schemas.vivaldi.ru/xsl/vcard/v1.0"
                xmlns:lom="http://ltsc.ieee.org/xsd/LOM"
                xmlns:rl="http://spec.edu.ru/xsd/RUS_LOM"
                xmlns:v="http://schemas.vivaldi.ru/mods/v1"
                xmlns="http://www.loc.gov/mods/v3"
                exclude-result-prefixes="msxsl lom rl"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="lom:lom">
    <mods version="3.0">
      <xsl:apply-templates select="lom:general/lom:title" />
      <xsl:apply-templates select="lom:general/lom:description" />
      <xsl:apply-templates select="lom:lifeCycle/lom:contribute" />
      <xsl:if test="lom:lifeCycle/rl:placeOfPublication">
        <xsl:call-template name="originInfo" />
      </xsl:if>
      <typeOfResource>text</typeOfResource>
    </mods>
  </xsl:template>
  <xsl:template match="lom:description">
    <abstract>
      <xsl:value-of select="lom:string[1]" />
    </abstract>
  </xsl:template>
  <xsl:template match="lom:title">
    <titleInfo>
      <title>
        <xsl:value-of select="lom:string[1]" />
      </title>
    </titleInfo>
    <extension>
      <v:collections>
        <v:collection>all</v:collection>
      </v:collections>
    </extension>
  </xsl:template>
  <xsl:template match="lom:contribute">
    <!--<xsl:analyze-string select="entity" regex=".">
      <xsl:matching-substring></xsl:matching-substring>
    </xsl:analyze-string>-->

    <name type="personal">
      <namePart>
        <xsl:value-of select="vcard:name(lom:entity)" />
      </namePart>
      <affiliation>
        <xsl:value-of select="vcard:org(lom:entity)"/>
      </affiliation>
      <role>
        <roleTerm type="text">
          <xsl:value-of select="lom:role/lom:value"/>
        </roleTerm>
      </role>
    </name>
  </xsl:template>
  <xsl:template name="originInfo">
    <xsl:if test="//rl:placeOfPublication or //rl:publishingHouse or //rl:yearOfPublication">
      <originInfo>
        <place>
          <placeTerm type="text">
            <xsl:value-of select="//rl:placeOfPublication/lom:string" />
          </placeTerm>
        </place>
        <publisher>
          <xsl:value-of select="//rl:publishingHouse/lom:string" />
        </publisher>
        <dateIssued keyDate="yes" encoding="w3cdtf">
          <xsl:value-of select="//rl:yearOfPublication/lom:dateTime"/>
        </dateIssued>
      </originInfo>
    </xsl:if>
  </xsl:template>
  <msxsl:script implements-prefix='vcard' language='CSharp'>
    <![CDATA[
      public string name(string vcard)
      {
          Regex regex = new Regex("(?m)^N.*?:(?<text>.*)$");
          Match match = regex.Match(vcard);
          if (!match.Success)
              return "no";

          return match.Groups["text"].Value;
      }
      public string org(string vcard)
      {
          return field(vcard, "N");
      }
      public string field(string vcard, string fieldName)
      {
          Regex regex = new Regex(String.Format("(?m)^{0}.*?:(?<text>.*)$", fieldName));
          Match match = regex.Match(vcard);
          if (!match.Success)
              return "no";

          return match.Groups["text"].Value;
      }

]]>
  </msxsl:script>

</xsl:stylesheet>
