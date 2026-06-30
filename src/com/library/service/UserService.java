package com.library.service;

import com.library.entity.User;
import com.library.util.PageUtil;

public interface UserService {
    User login(String username, String password);
    boolean register(User user);
    boolean checkUsername(String username);
    boolean updateProfile(User user);
    boolean updateAvatar(Integer userId, String avatarPath);
    User getById(Integer id);
    PageUtil getUserPage(int pageNo, int pageSize);
    PageUtil getUserPage(int pageNo, int pageSize, String keyword);
    boolean deleteUser(Integer id);
    boolean updateStatus(Integer id, Integer status);
}
