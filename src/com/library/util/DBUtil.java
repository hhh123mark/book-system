package com.library.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DBUtil {
    private static String driver;
    private static String url;
    private static String username;
    private static String password;

    static {
        try {
            Properties props = new Properties();
            InputStream is = null;

            is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                is = DBUtil.class.getResourceAsStream("/db.properties");
            }
            if (is == null) {
                is = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            }
            if (is == null) {
                String appPath = System.getProperty("catalina.base");
                if (appPath != null) {
                    String configPath = appPath + "/conf/db.properties";
                    try {
                        is = new FileInputStream(configPath);
                    } catch (IOException e) {
                    }
                }
            }
            if (is == null) {
                String classPath = DBUtil.class.getProtectionDomain().getCodeSource().getLocation().getPath();
                int idx = classPath.indexOf("WEB-INF");
                if (idx > 0) {
                    String basePath = classPath.substring(0, idx);
                    String configPath = basePath + "WEB-INF/classes/db.properties";
                    try {
                        is = new FileInputStream(configPath);
                    } catch (IOException e) {
                    }
                }
            }

            if (is != null) {
                props.load(is);
                driver = props.getProperty("jdbc.driver");
                url = props.getProperty("jdbc.url");
                username = props.getProperty("jdbc.username");
                password = props.getProperty("jdbc.password");
                if (driver != null && !driver.isEmpty()) {
                    try {
                        Class.forName(driver);
                    } catch (ClassNotFoundException e) {
                        e.printStackTrace();
                    }
                }
                is.close();
                System.out.println("DBUtil: Loaded database configuration successfully");
            } else {
                System.err.println("DBUtil: db.properties not found in any location");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        if (url == null || username == null) {
            throw new SQLException("Database configuration not loaded");
        }
        return DriverManager.getConnection(url, username, password);
    }

    public static void close(ResultSet rs, Statement stmt, Connection conn) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (stmt != null) {
            try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void close(Statement stmt, Connection conn) {
        close(null, stmt, conn);
    }

    public static void close(Connection conn) {
        close(null, null, conn);
    }

    public static void beginTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.setAutoCommit(false);
        }
    }

    public static void commitTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.commit();
            conn.setAutoCommit(true);
        }
    }

    public static void rollbackTransaction(Connection conn) throws SQLException {
        if (conn != null) {
            conn.rollback();
            conn.setAutoCommit(true);
        }
    }
}
