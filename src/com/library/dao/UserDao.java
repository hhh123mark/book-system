package com.library.dao;

import com.library.entity.User;
import java.util.List;

public interface UserDao {
    User findByUsername(String username);
    User findById(Integer id);
    int save(User user);
    int update(User user);
    int updateAvatar(Integer userId, String avatarPath);
    List<User> findAll(int offset, int pageSize);
    List<User> findByCondition(String keyword, int offset, int pageSize);
    int countAll();
    int countByCondition(String keyword);
    int deleteById(Integer id);
    int updateStatus(Integer id, Integer status);
    boolean existsByUsername(String username);
}
