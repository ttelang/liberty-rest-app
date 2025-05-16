package io.microprofile.tutorial.store.user.resource;

import io.microprofile.tutorial.store.user.entity.User;
import io.microprofile.tutorial.store.user.service.UserService;

import java.net.URI;
import java.util.List;

import jakarta.inject.Inject;
import jakarta.validation.Valid;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.UriInfo;

import org.eclipse.microprofile.openapi.annotations.Operation;
import org.eclipse.microprofile.openapi.annotations.responses.APIResponse;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

/**
 * REST resource for user management operations.
 */
@Path("/users")
@Tag(name = "User Management", description = "Operations for managing users")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class UserResource {

    @Inject
    private UserService userService;
    
    @Context
    private UriInfo uriInfo;

    @GET
    @Operation(summary = "Get all users", description = "Returns a list of all users")
    @APIResponse(responseCode = "200", description = "List of users")
    public List<User> getAllUsers() {
        return userService.getAllUsers();
    }

    @GET
    @Path("/{id}")
    @Operation(summary = "Get user by ID", description = "Returns a user by their ID")
    @APIResponse(responseCode = "200", description = "User found")
    @APIResponse(responseCode = "404", description = "User not found")
    public User getUserById(@PathParam("id") Long id) {
        return userService.getUserById(id);
    }

    @POST
    @Operation(summary = "Create new user", description = "Creates a new user")
    @APIResponse(responseCode = "201", description = "User created")
    @APIResponse(responseCode = "409", description = "Email already in use")
    public Response createUser(@Valid User user) {
        User createdUser = userService.createUser(user);
        URI location = uriInfo.getAbsolutePathBuilder().path(String.valueOf(createdUser.getUserId())).build();
        return Response.created(location).entity(createdUser).build();
    }

    @PUT
    @Path("/{id}")
    @Operation(summary = "Update user", description = "Updates an existing user")
    @APIResponse(responseCode = "200", description = "User updated")
    @APIResponse(responseCode = "404", description = "User not found")
    @APIResponse(responseCode = "409", description = "Email already in use")
    public User updateUser(@PathParam("id") Long id, @Valid User user) {
        return userService.updateUser(id, user);
    }

    @DELETE
    @Path("/{id}")
    @Operation(summary = "Delete user", description = "Deletes a user")
    @APIResponse(responseCode = "204", description = "User deleted")
    @APIResponse(responseCode = "404", description = "User not found")
    public Response deleteUser(@PathParam("id") Long id) {
        userService.deleteUser(id);
        return Response.noContent().build();
    }
}
