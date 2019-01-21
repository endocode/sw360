/*
 * Copyright Siemens AG, 2013-2016. Part of the SW360 Portal Project.
 * With modifications by Bosch Software Innovations GmbH, 2016.
 *
 * SPDX-License-Identifier: EPL-1.0
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */

package org.eclipse.sw360.moderation.db;

import com.google.common.collect.Maps;
import org.eclipse.sw360.datahandler.thrift.licenses.License;
import org.eclipse.sw360.datahandler.thrift.licenses.Todo;
import org.eclipse.sw360.datahandler.thrift.moderation.ModerationRequest;
import org.eclipse.sw360.datahandler.thrift.projects.CommonObligation;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import static org.eclipse.sw360.datahandler.common.CommonUtils.nullToEmptyList;

/**
 * Class for comparing a document with its counterpart in the database
 * Writes the difference (= additions and deletions) to the moderation request
 *
 * @author markus@endocode.com
 */
public class CommonObligationModerationRequestGenerator extends ModerationRequestGenerator<CommonObligation._Fields, CommonObligation> {

    @Override
    public ModerationRequest setAdditionsAndDeletions(ModerationRequest request, CommonObligation updateObligation, CommonObligation actualObligation){
        updateDocument = updateObligation;
        actualDocument = actualObligation;

        documentAdditions = new CommonObligation();
        documentDeletions = new CommonObligation();
        //required fields:
        documentAdditions.setName(updateObligation.getName());
        documentAdditions.setId(actualObligation.getId());
        documentDeletions.setName(actualObligation.getName());
        documentDeletions.setId(actualObligation.getId());

        request.setCommonObligationAdditions(documentAdditions);
        request.setCommonObligationDeletions(documentDeletions);
        return request;
    }
}
