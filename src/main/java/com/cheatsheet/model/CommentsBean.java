package com.cheatsheet.model;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CommentsBean {
    private String id;
    private String userId;
    private String commentText;
    private String parentCommentsId; // Our link to the parent
    private String username; // Joined from the users table
    private Timestamp createdAt;

    private List<CommentsBean> replies = new ArrayList<>();

    private String snippetsId;
    private String TimeAgo;

}
