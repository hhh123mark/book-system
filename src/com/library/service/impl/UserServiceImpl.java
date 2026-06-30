package com.library.service.impl;

import com.library.dao.UserDao;
import com.library.dao.impl.UserDaoImpl;
import com.library.entity.User;
import com.library.service.UserService;
import com.library.util.MD5Util;
import com.library.util.PageUtil;

import java.time.LocalDateTime;
import java.util.List;

public class UserServiceImpl implements UserService {

    private UserDao userDao = new UserDaoImpl();

    @Override
    public User login(String username, String password) {
        try {
            User user = userDao.findByUsername(username);
            if (user != null) {
                String md5Password = MD5Util.md5(password);
                if (md5Password.equals(user.getPassword())) {
                    return user;
                }
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean register(User user) {
        try {
            if (checkUsername(user.getUsername())) {
                return false;
            }
            user.setPassword(MD5Util.md5(user.getPassword()));
            user.setCreateTime(LocalDateTime.now());
            user.setUpdateTime(LocalDateTime.now());
            if (user.getRole() == null) {
                user.setRole(0);
            }
            if (user.getStatus() == null) {
                user.setStatus(1);
            }
            int result = userDao.save(user);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean checkUsername(String username) {
        try {
            return userDao.existsByUsername(username);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateProfile(User user) {
        try {
            user.setUpdateTime(LocalDateTime.now());
            int result = userDao.update(user);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateAvatar(Integer userId, String avatarPath) {
        try {
            int result = userDao.updateAvatar(userId, avatarPath);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getById(Integer id) {
        try {
            return userDao.findById(id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public PageUtil getUserPage(int pageNo, int pageSize) {
        try {
            int totalCount = userDao.countAll();
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<User> list = userDao.findAll(pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public PageUtil getUserPage(int pageNo, int pageSize, String keyword) {
        try {
            int totalCount = userDao.countByCondition(keyword);
            PageUtil pageUtil = new PageUtil(pageNo, pageSize, totalCount);
            List<User> list = userDao.findByCondition(keyword, pageUtil.getOffset(), pageSize);
            pageUtil.setList(list);
            return pageUtil;
        } catch (Exception e) {
            e.printStackTrace();
            return new PageUtil(pageNo, pageSize, 0);
        }
    }

    @Override
    public boolean deleteUser(Integer id) {
        try {
            int result = userDao.deleteById(id);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateStatus(Integer id, Integer status) {
        try {
            int result = userDao.updateStatus(id, status);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
