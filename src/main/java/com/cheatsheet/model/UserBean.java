package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class UserBean {
    private String id;
    private String name;
    private String email;
    private String password;
    private String hashedPassword;
    private String role;

}
