package com.dao;

import com.model.User;

public interface UserDAOinterface {
	public boolean registerUser(User user);
	 public User loginUser(String email, String password) ;
}
