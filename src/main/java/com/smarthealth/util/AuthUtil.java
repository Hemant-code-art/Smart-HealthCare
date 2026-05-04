package com.smarthealth.util;

import com.smarthealth.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public final class AuthUtil {
    private AuthUtil() {
    }

    public static User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (User) session.getAttribute("user");
    }

    public static boolean isAdmin(HttpServletRequest request) {
        User user = getSessionUser(request);
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }

    public static boolean isPatient(HttpServletRequest request) {
        User user = getSessionUser(request);
        return user != null && "PATIENT".equalsIgnoreCase(user.getRole());
    }
}
