package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class CategoriesBean {

    private String categoryId;
    private String categoryName;
    private String parentId;
    private String topicName;
    private String topicId;
    private int topicCounts;
}
