package io.microprofile.tutorial.store.user;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * User class for the microprofile tutorial store application.
 * This class represents a user in the system and stores their basic information.
 * We're using an in-memory data structure rather than a database.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    private Long userId;

    @NotEmpty(message = "Name cannot be empty")
    @Size(min = 2, max = 100, message = "Name must be between 2 and 100 characters")
    private String name;

    @NotEmpty(message = "Email cannot be empty")
    @Email(message = "Email should be valid")
    private String email;

    private String passwordHash;
    
    private String address;
    
    private String phoneNumber;
}
