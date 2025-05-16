package io.microprofile.tutorial.store.user;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;

/**
 * JAX-RS Application class to activate REST resources.
 */
@ApplicationPath("/api")
@OpenAPIDefinition(
    info = @Info(
        title = "User Management API",
        version = "1.0.0",
        description = "API for managing users in the microprofile tutorial store",
        contact = @Contact(
            name = "MicroProfile Team",
            url = "https://microprofile.io",
            email = "info@microprofile.io"
        ),
        license = @License(
            name = "Apache 2.0",
            url = "https://www.apache.org/licenses/LICENSE-2.0.html"
        )
    )
)
public class UserApplication extends Application {
    // The resources will be automatically discovered
}
