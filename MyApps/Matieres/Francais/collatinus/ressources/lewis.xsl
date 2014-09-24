<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="html" version="2.0" encoding="Utf-8" omit-xml-declaration="yes" indent="no" />

<xsl:template match="/entryFree"> 
    <div class="entry">
        <div class="header">
            <span class="dictid">Lewis &amp; Short, 1879 -- 
                <A HREF="http//www.perseus.tufts.edu/">http!:// www.perseus.tufts.edu/</A>
            </span><br/>
        </div>
        <div class="body"><xsl:apply-templates /></div>
    </div>
</xsl:template>
    <xsl:template match="orth">
        <strong><xsl:value-of select="." /></strong>
    </xsl:template>
    <xsl:template match="itype">
        <!-- <span class="itype"><xsl:value-of select="." /></span> -->
        <strong><xsl:value-of select="." /></strong>
    </xsl:template>

    <xsl:template match="gen">
        <span class="gen"><xsl:value-of select="." /></span>
    </xsl:template>

    <xsl:template match="pos">
        <xsl:value-of select="." />
    </xsl:template>

    <xsl:template match="sense">
         <div style="margin-left:40px">
             <!-- <xsl:value-of select="@n" />.-->
             <xsl:apply-templates />
         </div><br/>
     </xsl:template>

    <xsl:template match="hi">
        <xsl:choose>
        <xsl:when test="@rend='ital'">
            <em><xsl:apply-templates /></em>
        </xsl:when>

        <xsl:otherwise>
            <xsl:apply-templates />
        </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="foreign">
        <span>
        <xsl:attribute name="class">
        <xsl:choose>
            <xsl:when test="@lang">
                <xsl:value-of select="@lang" />
            </xsl:when>
            <xsl:otherwise>generic-foreign</xsl:otherwise>
        </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="." /></span>
    </xsl:template>

    <xsl:template match="cit">
        <!-- <span class="cit"><xsl:apply-templates /></span> -->
        <span style="color:#0000FF"><xsl:apply-templates /></span>
    </xsl:template>

    <xsl:template match="quote">
        <xsl:text>   </xsl:text>
        <strong>
            <xsl:value-of select="." />
        </strong>
        <xsl:text>   </xsl:text>
    </xsl:template>

    <xsl:template match="bibl">
        <strong>
            <xsl:value-of select="." />
        </strong>
        <xsl:text>   </xsl:text>
    </xsl:template>

    <xsl:template match="gloss">
        <em><xsl:apply-templates /></em>
    </xsl:template>

    <xsl:template match="tr">
        <em><xsl:apply-templates /></em>
    </xsl:template>
    
    <xsl:template match="ref">
        <a>
        <xsl:attribute name="href">andromeda:load-entry:<xsl:value-of select="."/> </xsl:attribute>
        <xsl:apply-templates />
        </a>
    </xsl:template>
</xsl:stylesheet>

