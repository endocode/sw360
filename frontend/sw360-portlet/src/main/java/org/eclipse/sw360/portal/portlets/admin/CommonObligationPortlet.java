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
import org.eclipse.sw360.portal.common.PortalConstants;
import org.eclipse.sw360.portal.portlets.Sw360Portlet;

import javax.portlet.PortletException;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

public class CommonObligationPortlet extends Sw360Portlet {
    private static final Logger log = Logger.getLogger(CommonObligationPortlet.class);

    @Override
    public void serveResource(ResourceRequest request, ResourceResponse response) throws PortletException {
        String action = request.getParameter(PortalConstants.ACTION);

        if (action == null) {
            log.error("Invalid action 'null'");
            return;
        }

      
    }
}
