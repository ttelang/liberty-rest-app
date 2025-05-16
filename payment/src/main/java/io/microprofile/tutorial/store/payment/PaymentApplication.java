package io.microprofile.tutorial.store.payment;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

/**
 * JAX-RS application for payment management.
 */
@ApplicationPath("/api")
@OpenAPIDefinition(
    info = @Info(
        title = "Payment API",
        version = "1.0.0",
        description = "API for managing payment transactions",
        license = @License(
            name = "Apache 2.0",
            url = "http://www.apache.org/licenses/LICENSE-2.0.html"),
        contact = @Contact(
            name = "Payment API Support",
            email = "support@example.com")),
    tags = {
        @Tag(name = "Payment", description = "Operations related to payment management")
    }
)
public class PaymentApplication extends Application {
    // The resources will be discovered automatically
}
