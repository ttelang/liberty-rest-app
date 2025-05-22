package com.example.rest;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.enterprise.context.ApplicationScoped;

@Path("/hello")
@ApplicationScoped
public class HelloWorldResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String sayHello() {
        return "Hello, Open Liberty with GitHub Codespaces, JDK 17, MicroProfile 6.1, Jakarta EE 10!";
    }
}
