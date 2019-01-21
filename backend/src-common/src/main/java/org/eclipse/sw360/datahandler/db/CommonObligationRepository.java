/*
 * Copyright Siemens AG, 2013-2017. Part of the SW360 Portal Project.
 *
 * SPDX-License-Identifier: EPL-1.0
 *
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 */
package org.eclipse.sw360.datahandler.db;

import org.eclipse.sw360.datahandler.couchdb.DatabaseConnector;
import org.eclipse.sw360.datahandler.couchdb.DatabaseRepository;
import org.eclipse.sw360.datahandler.thrift.projects.CommonObligation;
import org.ektorp.support.View;
import org.ektorp.support.Views;

/**
 * CRUD access for the OSSObligation class
 *
 * @author markus@endocode.com
 */
@Views({
        @View(name = "all",
                map = "function(doc) { if (doc.type == 'common_obligation') emit(null, doc._id) }"),
        @View(name = "byname",
                map = "function(doc) { if(doc.type == 'common_obligation') { emit(doc.name, doc) } }"),
        @View(name = "byCreatedOn",
                map = "function(doc) { if(doc.type == 'common_obligation') { emit(doc.createdOn, doc._id) } }")
})
public class CommonObligationRepository extends DatabaseRepository<CommonObligation> {

    public CommonObligationRepository(DatabaseConnector db) {
        super(CommonObligation.class, db);

        initStandardDesignDocument();
    }
}
