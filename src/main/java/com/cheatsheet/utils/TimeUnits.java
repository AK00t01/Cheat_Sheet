package com.cheatsheet.utils;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.Instant;

public class TimeUnits {

    public static String convertToTimeAgo(Timestamp createdAt) {
	if (createdAt == null)
	    return "";

	Instant now = Instant.now();
	Instant then = createdAt.toInstant();
	Duration duration = Duration.between(then, now);

	long seconds = duration.getSeconds();

	if (seconds < 60) {
	    return "just now";
	} else if (seconds < 3600) {
	    long minutes = seconds / 60;
	    return minutes + (minutes == 1 ? " min ago" : " mins ago");
	} else if (seconds < 86400) {
	    long hours = seconds / 3600;
	    return hours + (hours == 1 ? " hr ago" : " hrs ago");
	} else if (seconds < 2592000) { // Within 30 days
	    long days = seconds / 86400;
	    return days + (days == 1 ? " day ago" : " days ago");
	} else {
	    // For older comments, just show the date
	    return createdAt.toString().substring(0, 10);
	}

    }
}
