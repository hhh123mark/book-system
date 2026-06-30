package com.library.util;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

public class CSRFUtil {
    private static final SecureRandom random = new SecureRandom();

    public static String generateToken() {
        byte[] bytes = new byte[32];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    public static String generateSimpleToken() {
        return UUID.randomUUID().toString().replace("-", "");
    }

    public static boolean validateToken(String token, String expectedToken) {
        if (token == null || expectedToken == null) {
            return false;
        }
        return constantTimeEquals(token, expectedToken);
    }

    private static boolean constantTimeEquals(String a, String b) {
        if (a.length() != b.length()) {
            return false;
        }
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }
        return result == 0;
    }
}
