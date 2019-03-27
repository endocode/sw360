/*
 * Copyright Siemens AG, 2014-2018. Part of the SW360 Portal Project.
 * With contributions by Bosch Software Innovations GmbH, 2016.
 *
 * SPDX-License-Identifier: EPL-1.0
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
include "users.thrift"
include "sw360.thrift"

namespace java org.eclipse.sw360.datahandler.thrift.commonobligations
namespace php sw360.thrift.commonobligations

typedef sw360.RequestStatus RequestStatus
typedef users.User User
typedef users.RequestedAction RequestedAction

struct CommonObligation {
    1: string id,
    2: string text,
    3: string name,
    4: string texthash,
}

service CommonObligationService {

    /**
     * get all OSSObligations
     */
    list<CommonObligation> getCommonObligations(1: User user);

    /**
     * get single common obligation per id
     */
    CommonObligation getCommonObligation(1: string id, 2: User user);

    /**
     * try to update a common obligation as a user, if user has no permission, a moderation request is created
     * (part of project CRUD support)
     */
    RequestStatus updateCommonObligation(1: CommonObligation commonObligation, 2: User user);

    /**
     * try to delete a common obligation as a user, if user has no permission, a moderation request is created
     * (part of project CRUD support)
     */
    RequestStatus deleteCommonObligation(1: string id, 2: User user);

    /**
     * add a common obligation as a user to the db and get the id back
     * (part of project CRUD support)
     */
    string addCommonObligation(1: CommonObligation commonObligation, 2: User user);
}
