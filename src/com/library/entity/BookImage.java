package com.library.entity;

import java.io.Serializable;
import java.time.LocalDateTime;

public class BookImage implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer bookId;
    private String imagePath;
    private String imageName;
    private Integer sortOrder;
    private LocalDateTime createTime;

    public BookImage() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getBookId() {
        return bookId;
    }

    public void setBookId(Integer bookId) {
        this.bookId = bookId;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getImageName() {
        return imageName;
    }

    public void setImageName(String imageName) {
        this.imageName = imageName;
    }

    public Integer getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    @Override
    public String toString() {
        return "BookImage{" +
                "id=" + id +
                ", bookId=" + bookId +
                ", imagePath='" + imagePath + '\'' +
                ", imageName='" + imageName + '\'' +
                ", sortOrder=" + sortOrder +
                ", createTime=" + createTime +
                '}';
    }
}
