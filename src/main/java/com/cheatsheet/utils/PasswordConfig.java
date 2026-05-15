package com.cheatsheet.utils;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordConfig {
    public static String hashPassword(String plainTextPassword) {
	return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    public static boolean checkPassword(String plainTextPassword, String hashedFromDatabase) {
	return BCrypt.checkpw(plainTextPassword, hashedFromDatabase);
    }

}
