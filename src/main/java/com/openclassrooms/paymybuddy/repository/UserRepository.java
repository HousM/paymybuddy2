package com.openclassrooms.paymybuddy.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.repository.CrudRepository;
import com.openclassrooms.paymybuddy.model.User;

@Repository
public  interface UserRepository extends CrudRepository <User, Integer>{

    User findByEmail(String email);
    User findByFirstname( String firstname);



}
