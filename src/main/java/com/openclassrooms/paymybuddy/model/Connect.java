package com.openclassrooms.paymybuddy.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicUpdate;

@Entity
@DynamicUpdate
@Table ( name = "connect")
public class Connect {

    @Id
    @GeneratedValue ( strategy = GenerationType.IDENTITY)
    @Column ( name = "connect_id")
    private int connectId;

    @Column( name = "libelle")
    private String libelle;

    public Connect() {}
    public int getConnectId() {
        return connectId;
    }

    public void setConnectId(int connectId) {
        this.connectId = connectId;
    }

    public String getLibelle() {
        return libelle;
    }


}