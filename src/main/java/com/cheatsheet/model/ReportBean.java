package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class ReportBean {

    private String id;
    private String userName;
    private String userId;
    private String targetId;
    private String targetType;

    private String commentText;

    private String reason;
    private String status;
    private String createdAt;
    private String adminReason;

}
