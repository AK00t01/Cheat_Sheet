package com.cheatsheet.model;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class DetailCheatSheetBean {

    private String sheetId;
    private String title;
    private String content;
    private int viewCount;
    private LocalDate createdAt;

    private String userId;
    private String createdBy;
    private LocalDate editedTime;

    private int status;

    private String categoryId;
    private String categoryName;
    private String topicId;
    private String topic;

    private double rating;
    private int userCounts;

    private String parentsCommentId;
    private String childCommentsId;
    private String bgColor;
    private String fontFamily;

    private String reportSheetReasonId;
    private String reportSheetReason;

    private String reportCommentReasonId;
    private String reportCommentReason;

}
