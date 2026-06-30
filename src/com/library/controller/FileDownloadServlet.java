package com.library.controller;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

public class FileDownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String file = request.getParameter("file");

        if (file == null || file.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (file.contains("..") || file.startsWith("/") || file.startsWith("\\")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String realPath = getServletContext().getRealPath("") + File.separator + file;
        File downloadFile = new File(realPath);

        if (!downloadFile.exists() || !downloadFile.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = downloadFile.getName();
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLengthLong(downloadFile.length());
        response.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");

        try (FileInputStream fis = new FileInputStream(downloadFile);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
        }
    }
}
