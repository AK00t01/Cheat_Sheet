package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class SnippetsBean {
    private String id;
    private String title;
    private String content;

    private String categoryId;
    private String categoryName;

    private String topicId;
    private String topicName;

    private int viewCount;
    private String userId;
    private String createdAt;
    private String createdBy;

    private String bgColor;
    private String fontFamily;
}
