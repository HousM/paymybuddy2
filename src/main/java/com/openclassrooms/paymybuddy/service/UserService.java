package com.openclassrooms.paymybuddy.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.openclassrooms.paymybuddy.model.Connect;
import com.openclassrooms.paymybuddy.model.User;
import com.openclassrooms.paymybuddy.repository.UserRepository;

@Service
public class UserService implements UserDetailsService {


    private UserRepository userRepository;

    public UserService() {}
    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User findByUserEmail(String email) {
    return userRepository.findByEmail(email);
    }



    public User saveUser(String firstname,String lastname,String email,String password) {
        Connect connect = new Connect();
        connect.setConnectId(2);
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String hashedPassword = passwordEncoder.encode(password);
        User user= new User();
        user.setEmail(email);
        user.setFirstname(firstname);
        user.setLastname(lastname);
        user.setPassword(hashedPassword);
        user.setRole(connect);
        user.setBalance(1000);
        return userRepository.save(user);
    }

    @Override
    public UserDetails loadUserByUsername(String s) throws UsernameNotFoundException {
        return (UserDetails) userRepository.findByEmail(s);
    }
    public User addBuddy (User user, String email) {
            User userBuddy = userRepository.findByEmail(email);
            user.getUserBuddy().add(userBuddy);
        return userRepository.save(user);
    }

    public User deleteBuddy (User user,String email) {
            User userBuddy = userRepository.findByEmail(email);
            user.getUserBuddy().remove(userBuddy);
        return userRepository.save(user);
    }


}
