package io.microprofile.tutorial.store.user.repository;

import io.microprofile.tutorial.store.user.entity.User;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import jakarta.enterprise.context.ApplicationScoped;

/**
 * Simple in-memory repository for User objects.
 * This class provides CRUD operations for User entities to demonstrate MicroProfile concepts.
 */
@ApplicationScoped
public class UserRepository {

    private final Map<Long, User> users = new HashMap<>();
    private long nextId = 1;

    /**
     * Saves a user to the repository.
     * If the user has no ID, a new ID is assigned.
     *
     * @param user The user to save
     * @return The saved user with ID assigned
     */
    public User save(User user) {
        if (user.getUserId() == null) {
            user.setUserId(nextId++);
        }
        users.put(user.getUserId(), user);
        return user;
    }

    /**
     * Finds a user by ID.
     *
     * @param id The user ID
     * @return An Optional containing the user if found, or empty if not found
     */
    public Optional<User> findById(Long id) {
        return Optional.ofNullable(users.get(id));
    }

    /**
     * Finds a user by email.
     *
     * @param email The user's email
     * @return An Optional containing the user if found, or empty if not found
     */
    public Optional<User> findByEmail(String email) {
        return users.values().stream()
                .filter(user -> user.getEmail().equals(email))
                .findFirst();
    }

    /**
     * Retrieves all users from the repository.
     *
     * @return A list of all users
     */
    public List<User> findAll() {
        return new ArrayList<>(users.values());
    }

    /**
     * Deletes a user by ID.
     *
     * @param id The ID of the user to delete
     * @return true if the user was deleted, false if not found
     */
    public boolean deleteById(Long id) {
        return users.remove(id) != null;
    }

    /**
     * Updates an existing user.
     *
     * @param id The ID of the user to update
     * @param user The updated user information
     * @return An Optional containing the updated user, or empty if not found
     */
    public Optional<User> update(Long id, User user) {
        if (!users.containsKey(id)) {
            return Optional.empty();
        }
        
        user.setUserId(id);
        users.put(id, user);
        return Optional.of(user);
    }
}
