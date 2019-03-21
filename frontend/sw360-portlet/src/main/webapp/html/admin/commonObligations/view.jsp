<%--
  ~ Copyright Siemens AG, 2013-2017.
  ~ Copyright Bosch Software Innovations GmbH, 2016.
  ~ Part of the SW360 Portal Project.
  ~
  ~ SPDX-License-Identifier: EPL-1.0
  ~
  ~ All rights reserved. This program and the accompanying materials
  ~ are made available under the terms of the Eclipse Public License v1.0
  ~ which accompanies this distribution, and is available at
  ~ http://www.eclipse.org/legal/epl-v10.html
  --%>
<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>

<%@include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@include file="/html/utils/includes/errorKeyToMessage.jspf"%>
<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<portlet:actionURL var="updateCommonObligationsURL" name="updateCommonObligation">
</portlet:actionURL>

<div id="header"></div>
<p class="pageHeader"><span class="pageHeaderBigSpan">OSS Obligation Administration</span></p>

<table class="info_table">
    <thead>
    <tr>
        <th>Name</th>
        <th>Text</th>
        <th></th>
    </tr>
    </thead>

    <tbody>
    <tr>
        <td>Download License Archive</td>
        <td><a href="<portlet:resourceURL>
                               <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.DOWNLOAD_LICENSE_BACKUP%>'/>
                         </portlet:resourceURL>">
            <img src="<%=request.getContextPath()%>/images/download_enabled.jpg" alt="Download">
        </a>
        </td>
    </tr>
    <tr>
        <td colspan="2">
            <span> Upload License Archive </span>
            <form id="uploadLicenseArchiveForm" name="uploadLicenseArchiveForm" action="<%=updateLicenseArchiveURL%>" method="POST" enctype="multipart/form-data" style="margin-left: 30px;">
                <div class="fileupload-buttons">
                        <input id="<portlet:namespace/>LicenseArchivefileuploadInput" type="file" name="<portlet:namespace/>file">
                    <label for="overwriteIfExternalIdMatches">
                        <input type="checkbox" id="overwriteIfExternalIdMatches" name="<portlet:namespace/>overwriteIfExternalIdMatches" value="true" />
                        overwrite if external IDs match
                    </label>
                    <label for="overwriteIfIdMatchesEvenWithoutExternalIdMatch">
                        <input type="checkbox" id="overwriteIfIdMatchesEvenWithoutExternalIdMatch" name="<portlet:namespace/>overwriteIfIdMatchesEvenWithoutExternalIdMatch" value="true" />
                        overwrite if IDs match
                    </label>
                    <span class="fileinput-button">
                        <input type="submit" value="Upload License Archive" class="addButton" id="<portlet:namespace/>LicenseArchive-Submit" disabled>
                    </span>
                </div>
            </form>
        </td>
    </tr>
    <tr>
        <td>Import all SPDX license information</td>
        <td><a id="importSPDXLink" href="#">Import</a>
        </td>
    </tr>
    <tr>
        <td>Delete all license information</td>
        <td><img src="<%=request.getContextPath()%>/images/Trash.png"
                 alt="Delete all license information"
                 onclick="deleteAllLicenseInformation()">
        </td>
    </tr>
    </tbody>
</table>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/sw360.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/jquery-confirm2/dist/jquery-confirm.min.css">
