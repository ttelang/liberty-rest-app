package io.microprofile.tutorial.store.shoppingcart;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

/**
 * JAX-RS application for shopping cart management.
 */
@ApplicationPath("/api")
@OpenAPIDefinition(
    info = @Info(
        title = "Shopping Cart API",
        version = "1.0.0",
        description = "API for managing shopping carts",
        ),
    tags = {
        @Tag(name = "Shopping Cart", description = "Operations related to shopping cart management")
    }
)
public class ShoppingCartApplication extends Application {
    // The resources will be discovered automatically
}
