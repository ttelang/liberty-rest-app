package io.microprofile.tutorial.store.user;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;

/**
 * Application class to activate REST resources.
 */
@ApplicationPath("/api")
public class UserApplication extends Application {
    // The resources will be automatically discovered
}
