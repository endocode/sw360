package org.eclipse.sw360.datahandler.permissions;

import org.eclipse.sw360.datahandler.thrift.projects.CommonObligation;
import org.eclipse.sw360.datahandler.thrift.users.RequestedAction;
import org.eclipse.sw360.datahandler.thrift.users.User;

import java.util.Collections;
import java.util.Map;
import java.util.Set;

public class CommonObligationPermissions extends DocumentPermissions<CommonObligation> {

    protected CommonObligationPermissions(CommonObligation document, User user) {
        super(document, user);
    }

    @Override
    public void fillPermissions(CommonObligation other, Map<RequestedAction, Boolean> permissions) {

    }

    @Override
    public boolean isActionAllowed(RequestedAction action) {
        switch (action) {
            case READ:
                return true;
            case WRITE:
            case CLEARING:
            case DELETE:
                return PermissionUtils.isAdmin(user);
            default:
                return false;
        }
    }

    @Override
    protected Set<String> getContributors() {
        return Collections.emptySet();
    }

    @Override
    protected Set<String> getModerators() {
        return Collections.emptySet();
    }
}
