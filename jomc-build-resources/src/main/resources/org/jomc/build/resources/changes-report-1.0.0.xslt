<?xml version="1.0" encoding="UTF-8"?>
<!--

  Copyright (C) 2009 The JOMC Project
  Copyright (C) 2005 Christian Schulte <schulte2005@users.sourceforge.net>
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:

    o Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    o Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.

  THIS SOFTWARE IS PROVIDED BY THE JOMC PROJECT AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE JOMC PROJECT OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  $JOMC$

-->
<xsl:stylesheet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:changes="http://maven.apache.org/changes/1.0.0"
                version="1.0">

  <xsl:output method="xml" indent="yes" omit-xml-declaration="no" encoding="UTF-8" standalone="no"
              doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:param name="project.name"/>
  <xsl:param name="project.version"/>
  <xsl:param name="build.number"/>

  <xsl:template match="changes:document">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
      <head>
        <title><xsl:value-of select="$project.name"/> Changelog</title>
        <style type="text/css">
          table { border: 1px solid #CCCCCC; margin: 15px; }
          p.title { font-family: Verdana; font-size: large; margin-top: 15px; margin-bottom: 0px; margin-left: 15px; margin-right: 15px; }
          p.buildinfo { font-family: Verdana; font-size: x-small; margin-top: 0px; margin-bottom: 15px; margin-left: 15px; margin-rigth: 15px; }
          tr.headRow { background-color: #CCCCFF; font-family: Verdana; font-size: medium; padding: 2px 5px 2px 5px; }
          th.headCell { vertical-align: top; text-align: left; font-family: Verdana; font-size: medium; padding: 2px 5px 2px 5px; }
          tr.changelogRowAddition { background-color: #CCFFCC; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          tr.changelogRowDeletion { background-color: #FFCCCC; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          tr.changelogRowFix { background-color: #FFCCCC; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          tr.changelogRowUpdate { background-color: #FFFF99; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          tr.changelogRowNoChanges { background-color: #CCFFCC; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          td.changelogCell { vertical-align: top; text-align: left; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          td.changelogCellAddition { vertical-align: top; text-align: left; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          td.changelogCellDeletion { vertical-align: top; text-align: left; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          td.changelogCellFix { vertical-align: top; text-align: left; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
          td.changelogCellUpdate { vertical-align: top; text-align: left; font-family: Verdana; font-size: small; padding: 2px 5px 2px 5px; }
        </style>
      </head>
      <body>
        <p class="title"><xsl:value-of select="$project.name"/> Changelog</p>
        <p class="buildinfo">Version <xsl:value-of select="$project.version"/> - Build <xsl:value-of select="$build.number"/></p>
        <table>
          <tr class="headRow">
            <th class="headCell">Version</th>
            <th class="headCell">Date</th>
            <th class="headCell">Developer</th>
            <th class="headCell">Action</th>
            <th class="headCell">Description</th>
          </tr>
          <xsl:apply-templates select="changes:body/changes:release"/>
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="changes:release">
    <xsl:apply-templates select="changes:action">
      <xsl:with-param name="version"><xsl:value-of select="@version"/></xsl:with-param>
      <xsl:with-param name="date"><xsl:value-of select="@date"/></xsl:with-param>
      <xsl:sort select="@type"/>
    </xsl:apply-templates>
    <xsl:if test="count(changes:action) = 0">
      <tr class="changelogRowNoChanges">
        <td class="changelogCellAddition"><xsl:value-of select="@version"/></td>
        <td class="changelogCellAddition"><xsl:value-of select="@date"/></td>
        <td class="changelogCellAddition" colspan="3">No changes in this release.</td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="changes:action">
    <xsl:param name="version"/>
    <xsl:param name="date"/>
    <tr>
      <xsl:choose>
        <xsl:when test="@type='add'"><xsl:attribute name="class">changelogRowAddition</xsl:attribute></xsl:when>
        <xsl:when test="@type='fix'"><xsl:attribute name="class">changelogRowFix</xsl:attribute></xsl:when>
        <xsl:when test="@type='remove'"><xsl:attribute name="class">changelogRowDeletion</xsl:attribute></xsl:when>
        <xsl:when test="@type='update'"><xsl:attribute name="class">changelogRowUpdate</xsl:attribute></xsl:when>
      </xsl:choose>
      <td class="changelogCell"><xsl:value-of select="$version"/></td>
      <td class="changelogCell"><xsl:value-of select="$date"/></td>
      <td class="changelogCell"><xsl:value-of select="@dev"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@type='add'"><xsl:attribute name="class">changelogCellAddition</xsl:attribute></xsl:when>
          <xsl:when test="@type='fix'"><xsl:attribute name="class">changelogCellFix</xsl:attribute></xsl:when>
          <xsl:when test="@type='remove'"><xsl:attribute name="class">changelogCellDeletion</xsl:attribute></xsl:when>
          <xsl:when test="@type='update'"><xsl:attribute name="class">changelogCellUpdate</xsl:attribute></xsl:when>
        </xsl:choose>
        <xsl:value-of select="translate(@type, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
      </td>
      <td class="changelogCell"><xsl:value-of select="string(.)" disable-output-escaping="yes"/></td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
