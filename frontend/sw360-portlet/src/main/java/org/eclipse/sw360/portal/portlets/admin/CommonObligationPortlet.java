/*
 * Copyright Siemens AG, 2013-2015.
 * Copyright Bosch Software Innovations GmbH, 2018.
 * Part of the SW360 Portal Project.
 *
 * SPDX-License-Identifier: EPL-1.0
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.eclipse.sw360.portal.portlets.admin;

import org.apache.log4j.Logger;
import org.apache.thrift.TException;
import org.eclipse.sw360.datahandler.thrift.RequestStatus;
import org.eclipse.sw360.datahandler.thrift.projects.CommonObligation;
import org.eclipse.sw360.datahandler.thrift.projects.ProjectService;
import org.eclipse.sw360.datahandler.thrift.users.User;
import org.eclipse.sw360.portal.common.PortalConstants;
import org.eclipse.sw360.portal.common.UsedAsLiferayAction;
import org.eclipse.sw360.portal.portlets.Sw360Portlet;
import org.eclipse.sw360.portal.portlets.components.ComponentPortletUtils;
import org.eclipse.sw360.portal.portlets.projects.ProjectPortletUtils;
import org.eclipse.sw360.portal.users.UserCacheHolder;

import javax.portlet.*;
import java.io.IOException;
import java.util.Collections;
import java.util.List;

import static com.google.common.base.Strings.isNullOrEmpty;
import static org.eclipse.sw360.portal.common.PortalConstants.*;

public class CommonObligationPortlet extends Sw360Portlet {
    private static final Logger log = Logger.getLogger(CommonObligationPortlet.class);

    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws IOException, PortletException {
        String action = request.getParameter(PortalConstants.ACTION);

        if (action == null) {
            log.error("Invalid action 'null'");
            return;
        }

        if (REMOVE_VENDOR.equals(action)) {
            removeCommonObligation(request, response);
        }

    }

    private void removeCommonObligation(javax.portlet.PortletRequest request, ResourceResponse response) throws IOException {

    }

    @Override
    public void doView(RenderRequest request, RenderResponse response) throws IOException, PortletException {
        String pageName = request.getParameter(PAGENAME);
        if (PAGENAME_EDIT.equals(pageName)) {
            prepareObligationEdit(request);
            include("/html/admin/commonObligations/edit.jsp", request, response);
        } else {
            prepareStandardView(request);
            super.doView(request, response);
        }
    }

    private void prepareObligationEdit(RenderRequest request) throws PortletException {
        String id = request.getParameter(COMMON_OBLIGATION_ID);

        if (!isNullOrEmpty(id)) {
            try {
                final User user = UserCacheHolder.getUserFromRequest(request);
                ProjectService.Iface projClient = thriftClients.makeProjectClient();
                CommonObligation commonObligation = projClient.getCommonObligation(id, user);
                request.setAttribute(COMMON_OBLIGATION, commonObligation);
            } catch (TException e) {
                log.error("Problem retrieving vendor");
            }
        }
        else{
            request.setAttribute(RELEASE_LIST, Collections.emptyList());
        }
    }

    private void prepareStandardView(RenderRequest request) throws IOException {
        List<CommonObligation> commonObligationsList;
        try {
            final User user = UserCacheHolder.getUserFromRequest(request);
            ProjectService.Iface projectClient = thriftClients.makeProjectClient();

            commonObligationsList = projectClient.getCommonObligations(user);

        } catch (TException e) {
            log.error("Could not get common obligations from backend ", e);
            commonObligationsList = Collections.emptyList();
        }

        request.setAttribute(COMMON_OBLIGATION_LIST, commonObligationsList);
    }

    @UsedAsLiferayAction
    public void updateCommonObligation(ActionRequest request, ActionResponse response) throws PortletException, IOException {
        String id = request.getParameter(COMMON_OBLIGATION_ID);
        final User user = UserCacheHolder.getUserFromRequest(request);

        if (id != null) {
            try {
                ProjectService.Iface projectClient = thriftClients.makeProjectClient();
                CommonObligation commonObligation = projectClient.getCommonObligation(id, user);
                ProjectPortletUtils.updateCommonObligationFromRequest(request, commonObligation);
                RequestStatus requestStatus = projectClient.updateCommonObligation(commonObligation, user);
                setSessionMessage(request, requestStatus, "CommonObligation", "update", commonObligation.getName());
            } catch (TException e) {
                log.error("Error fetching common obligation from backend!", e);
            }
        }
        else{
            addCommonObligation(request);
        }
    }

    @UsedAsLiferayAction
    public void removeCommonObligation(ActionRequest request, ActionResponse response) throws IOException, PortletException {
        final RequestStatus requestStatus = ComponentPortletUtils.deleteVendor(request, log);
        setSessionMessage(request, requestStatus, "CommonObligation", "delete");
        response.setRenderParameter(PAGENAME, PAGENAME_VIEW);
    }

    private void addCommonObligation(ActionRequest request)  {
        final CommonObligation commonObligation = new CommonObligation();
        ProjectPortletUtils.updateCommonObligationFromRequest(request, commonObligation);

        try {
            CommonObligation.Iface projectClient = thriftClients.makeCommonObligationClient();
            projectClient.addCommonObligation(commonObligation);
        } catch (TException e) {
            log.error("Error adding common obligation", e);
        }
    }

}
