<%--
  ~ Copyright Siemens AG, 2013-2017. Part of the SW360 Portal Project.
  ~
  ~ SPDX-License-Identifier: EPL-1.0
  ~
  ~ All rights reserved. This program and the accompanying materials
  ~ are made available under the terms of the Eclipse Public License v1.0
  ~ which accompanies this distribution, and is available at
  ~ http://www.eclipse.org/legal/epl-v10.html
  --%>
<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>
<%@include file="/html/init.jsp"%>
<%-- the following is needed by liferay to display error messages--%>
<%@include file="/html/utils/includes/errorKeyToMessage.jspf"%>
<portlet:defineObjects />
<liferay-theme:defineObjects />

<%@ page import="javax.portlet.PortletRequest" %>
<%@ page import="com.liferay.portlet.PortletURLFactoryUtil" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="org.eclipse.sw360.datahandler.thrift.commonObligations.CommonObligation" %>


<jsp:useBean id="commonObligation" class="org.eclipse.sw360.datahandler.thrift.commonObligations.CommonObligation" scope="request" />

<jsp:useBean id="documentID" class="java.lang.String" scope="request" />

<core_rt:set  var="addMode"  value="${empty commonObligation.id}" />

<portlet:actionURL var="updateURL" name="updateCommonObligation">
    <portlet:param name="<%=PortalConstants.COMMON_OBLIGATION_ID%>" value="${commonObligation.id}" />
</portlet:actionURL>

<portlet:actionURL var="deleteCommonObligationURL" name="removeCommonObligation">
    <portlet:param name="<%=PortalConstants.COMMON_OBLIGATION_ID%>" value="${commonObligation.id}"/>
</portlet:actionURL>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/sw360.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/jquery-ui/themes/base/jquery-ui.min.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/jquery-confirm2/dist/jquery-confirm.min.css">
<script src="<%=request.getContextPath()%>/webjars/jquery/dist/jquery.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/jquery-validation/dist/jquery.validate.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/jquery-validation/dist/additional-methods.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/jquery-confirm2/dist/jquery-confirm.min.js" type="text/javascript"></script>
<script src="<%=request.getContextPath()%>/webjars/jquery-ui/jquery-ui.min.js"></script>


<div id="where" class="content1">
    <p class="pageHeader"><span class="pageHeaderBigSpan"><sw360:out value="${commonObligation.name}"/></span>
        <core_rt:if test="${not addMode}" >
            <input type="button" class="addButton" onclick="deleteConfirmed('Do you really want to delete the commonObligation <b><sw360:out value="${commonObligation.fullname}"/></b> ?', deleteCommonObligation)"
                   value="Delete <sw360:out value="${commonObligation.fullname}"/>">
        </core_rt:if>
    </p>
</div>

<div id="editField" class="content2">

    <form  id="commonObligationEditForm" name="commonObligationEditForm" action="<%=updateURL%>" method="post" >
        <table class="table info_table" id="CommonObligationEdit">
            <thead>
            <tr>
                <th colspan="2" class="headlabel">Edit CommonObligation</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td width="45%">
                    <label class="textlabel stackedLabel mandatory" for="commonObligationName">Name</label>
                    <input id="commonObligationName" type="text" required class="toplabelledInput" placeholder="Enter commonObligation name" name="<portlet:namespace/><%=CommonObligation._Fields.NAME%>"
                           value="<sw360:out value="${commonObligation.name}"/>" />
                </td>

                <td width="45%">
                    <label class="textlabel stackedLabel mandatory" for="commonObligationText">Text</label>
                    <input id="commonObligationText" type="text" required class="toplabelledInput" placeholder="Enter commonObligation text" name="<portlet:namespace/><%=CommonObligation._Fields.TEXT%>"
                           value="<sw360:out value="${commonObligation.text}"/>" />
                </td>
            </tr>

            </tbody>
        </table>
        <core_rt:if test="${not addMode}" >
            <input type="submit" value="Update CommonObligation" class="addButton">
            <input type="button" value="Cancel" onclick="cancel()" class="cancelButton">
        </core_rt:if>
        <core_rt:if test="${addMode}" >
            <input type="submit" value="Add CommonObligation" class="addButton">
            <input type="button" value="Cancel" onclick="cancel()" class="cancelButton">
        </core_rt:if>
    </form>

    <core_rt:if test="${releaseList.size() > 0}" >
        <p>Used by the following release(s)</p>
        <table style="padding-left: 3px; padding-right: 3px"> <tr>
        <core_rt:forEach var="release" items="${releaseList}" varStatus="loop">
            <td><sw360:DisplayReleaseLink release="${release}" /></td>
            <core_rt:if test="${loop.count > 0 and  loop.count %  4 == 0}" ></tr> <tr> </core_rt:if>
        </core_rt:forEach>
        </tr>
        </table>
    </core_rt:if>

</div>

<script>
    function cancel() {
        var baseUrl = '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>';
        var portletURL = Liferay.PortletURL.createURL( baseUrl )
                <core_rt:if test="${not addMode}" >
                .setParameter('<%=PortalConstants.PAGENAME%>','<%=PortalConstants.PAGENAME_DETAIL%>')
                </core_rt:if>
                <core_rt:if test="${addMode}" >
                .setParameter('<%=PortalConstants.PAGENAME%>','<%=PortalConstants.PAGENAME_VIEW%>')
                </core_rt:if>
                .setParameter('<%=PortalConstants.COMMON_OBLIGATION_ID%>','${commonObligation.id}');
        window.location = portletURL.toString();
    }

    function deleteCommonObligation() {
        window.location.href = '<%=deleteCommonObligationURL%>';
    }

    var contextpath;
    $( document ).ready(function() {
        contextpath = '<%=request.getContextPath()%>';
        $('#commonObligationEditForm').validate({
            ignore: [],
            invalidHandler: invalidHandlerShowErrorTab
        });
    });

</script>