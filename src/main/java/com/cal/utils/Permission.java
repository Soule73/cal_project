package com.cal.utils;

import com.cal.models.User;

public class Permission {

    public static boolean hasRole(User user, String roleName) {
        return user.getRoles().stream().noneMatch(role -> role.getName().equals(roleName));
    }
}
