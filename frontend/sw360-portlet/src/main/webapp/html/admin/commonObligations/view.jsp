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
<%@ page import="javax.portlet.PortletRequest" %>
<%@ page import="com.liferay.portlet.PortletURLFactoryUtil" %>

<%@include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@include file="/html/utils/includes/errorKeyToMessage.jspf"%>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<portlet:resourceURL var="deleteAjaxURL">
    <portlet:param name="<%=PortalConstants.ACTION%>" value='<%=PortalConstants.REMOVE_COMMON_OBLIGATION%>'/>
</portlet:resourceURL>

<portlet:renderURL var="addCommonObligationURL">
    <portlet:param name="<%=PortalConstants.PAGENAME%>" value="<%=PortalConstants.PAGENAME_EDIT%>" />
</portlet:renderURL>

<jsp:useBean id="commonObligationList" type="java.util.List<org.eclipse.sw360.datahandler.thrift.projects.CommonObligation>"  scope="request"/>

<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/datatables.net-buttons-bs/css/buttons.bootstrap.min.css"/>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/dataTable_Siemens.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/sw360.css">

<div id="header"></div>
<p class="pageHeader">
    <span class="pageHeaderBigSpan">CommonObligations</span> <span class="pageHeaderSmallSpan">(${commonObligationList.size()})</span>
    <span class="pull-right">
        <input type="button" class="addButton" onclick="window.location.href='<%=addCommonObligationURL%>'" value="Add CommonObligation">
    </span>
</p>

<div id="searchInput" class="content1">
    <%@ include file="/html/utils/includes/quickfilter.jspf" %>
</div>
<div id="commonObligationsTableDiv" class="content2">
    <table id="commonObligationsTable" cellpadding="0" cellspacing="0" border="0" class="display">
        <tfoot>
        <tr>
            <th colspan="3"></th>
        </tr>
        </tfoot>
    </table>
</div>

<link rel="stylesheet" href="<%=request.getContextPath()%>/webjars/jquery-confirm2/dist/jquery-confirm.min.css">

<%--for javascript library loading --%>
<%@ include file="/html/utils/includes/requirejs.jspf" %>
<script>
    AUI().use('liferay-portlet-url', function () {
        var PortletURL = Liferay.PortletURL;

        require(['jquery', 'utils/includes/quickfilter', 'modules/confirm', /* jquery-plugins: */ 'datatables.net', 'datatables.net-buttons', 'datatables.net-buttons.print', 'jquery-confirm'], function($, quickfilter, confirm) {
            var commonObligationsTable,
                commonObligationIdInURL = '<%=PortalConstants.COMMON_OBLIGATION_ID%>',
                pageName = '<%=PortalConstants.PAGENAME%>';
                pageEdit = '<%=PortalConstants.PAGENAME_EDIT%>';
                baseUrl = '<%= PortletURLFactoryUtil.create(request, portletDisplay.getId(), themeDisplay.getPlid(), PortletRequest.RENDER_PHASE) %>';

            // initializing
            commonObligationsTable = createCommonObligationsTable();
            quickfilter.addTable(commonObligationsTable);

            // register event handlers
            $('#commonObligationsTable').on('click', 'img.delete', function (event) {
                var data = $(event.currentTarget).data();
                deleteCommonObligation(data.commonObligationId, data.commonObligationName);
            });

            // helper functions
            function createDetailURLfromCommonObligationId (paramVal) {
                var portletURL = PortletURL.createURL( baseUrl ).setParameter(pageName,pageEdit).setParameter(commonObligationIdInURL, paramVal);
                return portletURL.toString();
            }

            // catch ctrl+p and print dataTable
            $(document).on('keydown', function(e){
                if(e.ctrlKey && e.which === 80){
                    e.preventDefault();
                    commonObligationsTable.buttons('.custom-print-button').trigger();
                }
            });

            function createCommonObligationsTable() {
                var commonObligationsTable,
                    result = [];

                <core_rt:forEach items="${commonObligationList}" var="commonObligation">
                    result.push({
                        "DT_RowId": "${commonObligation.id}",
                        "0": "<a href='"+createDetailURLfromCommonObligationId('${commonObligation.id}')+"' target='_self'><sw360:out value="${commonObligation.name}"/></a>",
                        "1": "<sw360:out value="${commonObligation.text}"/>",
                        "2": "<a href='"+createDetailURLfromCommonObligationId('${commonObligation.id}')+"' target='_self'><img src='<%=request.getContextPath()%>/images/edit.png' alt='Edit' title='Edit'></a>"
                        +"<img class='delete' src='<%=request.getContextPath()%>/images/Trash.png' data-commonObligation-id='${commonObligation.id}' data-commonObligation-name='<sw360:out value="${commonObligation.fullname}"/>')\"  alt='Delete' title='Delete'>"
                    });
                </core_rt:forEach>

                commonObligationsTable = $('#commonObligationsTable').DataTable({
                    pagingType: "simple_numbers",
                    dom: "lBrtip",
                    buttons: [
                        {
                            extend: 'print',
                            text: 'Print',
                            autoPrint: true,
                            className: 'custom-print-button',
                            exportOptions: {
                                columns: [0, 1, 2]
                            }
                        }
                    ],
                    data: result,
                    columns: [
                        {"title": "Name"},
                        {"title": "Text"},
                        {"title": "Actions"}
                    ],
                    autoWidth: false
                });

                return commonObligationsTable;
            }

            function deleteCommonObligation(id, name) {
                function deleteCommonObligationInternal() {
                    jQuery.ajax({
                        type: 'POST',
                        url: '<%=deleteAjaxURL%>',
                        cache: false,
                        data: {
                            <portlet:namespace/>commonObligationId: id
                        },
                        success: function (data) {
                            if(data.result == 'SUCCESS')
                                commonObligationsTable.row('#' + id).remove().draw(false);
                            else {
                                $.alert("I could not delete the commonObligation!");
                            }
                        },
                        error: function () {
                            $.alert("I could not delete the commonObligation!");
                        }
                    });
                }

                confirm.confirmDeletion("Do you really want to delete the commonObligation <b>" + name + "</b> ?", deleteCommonObligationInternal);
            }
        });
    });
</script>
