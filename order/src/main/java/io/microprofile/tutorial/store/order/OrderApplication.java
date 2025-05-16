package io.microprofile.tutorial.store.order;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

/**
 * JAX-RS application for order management.
 */
@ApplicationPath("/api")
@OpenAPIDefinition(
    info = @Info(
        title = "Order API",
        version = "1.0.0",
        description = "API for managing orders and order items",
        license = @License(
            name = "Apache 2.0",
            url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
        contact = @Contact(
            name = "Order API Support",
            email = "support@example.com")),
    tags = {
        @Tag(name = "Order", description = "Operations related to order management"),
        @Tag(name = "OrderItem", description = "Operations related to order item management")
    }
)
public class OrderApplication extends Application {
    // The resources will be discovered automatically
}
