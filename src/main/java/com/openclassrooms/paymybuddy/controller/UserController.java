package com.openclassrooms.paymybuddy.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.openclassrooms.paymybuddy.model.User;
import com.openclassrooms.paymybuddy.service.UserService;

@Controller
public class UserController {
	 @Autowired
	    private UserService userService;

	    public UserController() {}
	    public UserController(UserService userService) {
	        this.userService = userService;
	    }

	    @GetMapping(value = "/newbuddy")
	    public String getUserByEmail(Model model) {
	    return "newbuddy";
	    }

	    @GetMapping(value ="/deletebuddy")
	    public String deleteUserByMail(Model model) {
	        return "deletebuddy";
	    }

	    @PostMapping(value="/addbuddy")
	    public String addFriend (@AuthenticationPrincipal User user, @RequestParam("email") String email, Model model){
	        userService.addBuddy(user, email);
	        return "redirect:/transfer";
	    }

	    @PostMapping(value = "/deletebuddy")
	    public String deleteFriend (@AuthenticationPrincipal User user, @RequestParam("email") String email, Model model) {
	        userService.deleteBuddy(user,email);
	        return "redirect:/transfer";
	    }

	    @GetMapping( value = "/register")
	    public String registration (Model model) {
	        return "register";
	    }

	    @PostMapping(value = "/newuser")
	    public String saveUser ( @RequestParam("firstname") String firstname,
	                           @RequestParam("lastname") String lastname,
	                           @RequestParam("email") String email,
	                           @RequestParam("password") String password,
	                           Model model) {
	        userService.saveUser(firstname,lastname, email, password);
	        return "redirect:/transfer";
	    }

	    @GetMapping(value = "/profil")
	    public String findUser(Model model) {
	        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	        if (!(auth instanceof AnonymousAuthenticationToken)) {
	        UserDetails userDetails = (UserDetails) auth.getPrincipal();
	        String email = userDetails.getUsername();
	        User user = userService.findByUserEmail(email);
	            model.addAttribute("userDetails",user);
	        }
	        return "profil";
	    }

	    @GetMapping(value = "/login")
	    public String login (Model model) {
	        return "login";
	    }

}
