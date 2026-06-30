package com.library.util;

import java.io.Serializable;
import java.util.List;

public class PageUtil implements Serializable {
    private static final long serialVersionUID = 1L;

    private int pageNo;
    private int pageSize;
    private int totalCount;
    private int totalPage;
    private List<?> list;

    public PageUtil() {
    }

    public PageUtil(int pageNo, int pageSize, int totalCount) {
        this.pageNo = pageNo;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        calculateTotalPage();
    }

    private void calculateTotalPage() {
        if (totalCount <= 0) {
            totalPage = 0;
        } else {
            totalPage = (totalCount + pageSize - 1) / pageSize;
        }
    }

    public int getOffset() {
        if (pageNo <= 1) {
            return 0;
        }
        return (pageNo - 1) * pageSize;
    }

    public boolean hasPrev() {
        return pageNo > 1;
    }

    public boolean hasNext() {
        return pageNo < totalPage;
    }

    public int getPageNo() {
        return pageNo;
    }

    public void setPageNo(int pageNo) {
        this.pageNo = pageNo;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
        calculateTotalPage();
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
        calculateTotalPage();
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public List<?> getList() {
        return list;
    }

    public void setList(List<?> list) {
        this.list = list;
    }

    @Override
    public String toString() {
        return "PageUtil{" +
                "pageNo=" + pageNo +
                ", pageSize=" + pageSize +
                ", totalCount=" + totalCount +
                ", totalPage=" + totalPage +
                ", list=" + list +
                '}';
    }
}
