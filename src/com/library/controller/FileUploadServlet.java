package com.library.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class FileUploadServlet extends HttpServlet {

    private static final String UPLOAD_BASE = "uploads";
    private static final String AVATAR_DIR = "avatar";
    private static final String BOOKS_DIR = "books";
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;
    private static final String[] ALLOWED_TYPES = {"image/jpeg", "image/png", "image/gif", "image/jpg"};

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        if (type == null) {
            type = "";
        }

        response.setContentType("application/json;charset=UTF-8");

        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_BASE;

        switch (type) {
            case "avatar":
                uploadAvatar(request, response, uploadPath + File.separator + AVATAR_DIR);
                break;
            case "bookCover":
                uploadBookCover(request, response, uploadPath + File.separator + BOOKS_DIR);
                break;
            case "bookImages":
                uploadBookImages(request, response, uploadPath + File.separator + BOOKS_DIR);
                break;
            default:
                response.getWriter().write("{\"success\":false,\"message\":\"无效的上传类型\"}");
                break;
        }
    }

    private void uploadAvatar(HttpServletRequest request, HttpServletResponse response, String dirPath)
            throws ServletException, IOException {
        File dir = new File(dirPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        Part filePart = request.getPart("file");
        if (filePart == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"请选择文件\"}");
            return;
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            response.getWriter().write("{\"success\":false,\"message\":\"文件大小不能超过5MB\"}");
            return;
        }

        String contentType = filePart.getContentType();
        if (!isAllowedType(contentType)) {
            response.getWriter().write("{\"success\":false,\"message\":\"只支持jpg/png/gif格式\"}");
            return;
        }

        String fileName = generateFileName(filePart.getSubmittedFileName());
        String filePath = dirPath + File.separator + fileName;
        filePart.write(filePath);

        String relativePath = UPLOAD_BASE + "/" + AVATAR_DIR + "/" + fileName;
        response.getWriter().write("{\"success\":true,\"path\":\"" + relativePath + "\"}");
    }

    private void uploadBookCover(HttpServletRequest request, HttpServletResponse response, String dirPath)
            throws ServletException, IOException {
        File dir = new File(dirPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        Part filePart = request.getPart("file");
        if (filePart == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"请选择文件\"}");
            return;
        }

        if (filePart.getSize() > MAX_FILE_SIZE) {
            response.getWriter().write("{\"success\":false,\"message\":\"文件大小不能超过5MB\"}");
            return;
        }

        String contentType = filePart.getContentType();
        if (!isAllowedType(contentType)) {
            response.getWriter().write("{\"success\":false,\"message\":\"只支持jpg/png/gif格式\"}");
            return;
        }

        String fileName = generateFileName(filePart.getSubmittedFileName());
        String filePath = dirPath + File.separator + fileName;
        filePart.write(filePath);

        String relativePath = UPLOAD_BASE + "/" + BOOKS_DIR + "/" + fileName;
        response.getWriter().write("{\"success\":true,\"path\":\"" + relativePath + "\"}");
    }

    private void uploadBookImages(HttpServletRequest request, HttpServletResponse response, String dirPath)
            throws ServletException, IOException {
        File dir = new File(dirPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        List<String> paths = new ArrayList<>();

        for (Part filePart : request.getParts()) {
            if (!"files".equals(filePart.getName()) && !"file".equals(filePart.getName())) {
                continue;
            }

            if (filePart.getSize() > MAX_FILE_SIZE) {
                continue;
            }

            String contentType = filePart.getContentType();
            if (!isAllowedType(contentType)) {
                continue;
            }

            String fileName = generateFileName(filePart.getSubmittedFileName());
            String filePath = dirPath + File.separator + fileName;
            filePart.write(filePath);

            String relativePath = UPLOAD_BASE + "/" + BOOKS_DIR + "/" + fileName;
            paths.add(relativePath);
        }

        StringBuilder json = new StringBuilder();
        json.append("{\"success\":true,\"paths\":[");
        for (int i = 0; i < paths.size(); i++) {
            if (i > 0) {
                json.append(",");
            }
            json.append("\"").append(paths.get(i)).append("\"");
        }
        json.append("]}");

        response.getWriter().write(json.toString());
    }

    private boolean isAllowedType(String contentType) {
        if (contentType == null) {
            return false;
        }
        for (String type : ALLOWED_TYPES) {
            if (type.equalsIgnoreCase(contentType)) {
                return true;
            }
        }
        return false;
    }

    private String generateFileName(String originalFileName) {
        String extension = "";
        int dotIndex = originalFileName.lastIndexOf('.');
        if (dotIndex > 0) {
            extension = originalFileName.substring(dotIndex);
        }
        return UUID.randomUUID().toString().replace("-", "") + extension;
    }
}
