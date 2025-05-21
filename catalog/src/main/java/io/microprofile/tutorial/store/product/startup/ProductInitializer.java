package io.microprofile.tutorial.store.product.startup;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.Initialized;
import jakarta.enterprise.event.Observes;

import java.util.logging.Logger;

/**
 * This class is a startup observer that logs when the application context initializes.
 * Data initialization is now handled by JPA's schema generation and SQL script loading
 * as configured in persistence.xml with jakarta.persistence.sql-load-script-source.
 */
@ApplicationScoped
public class ProductInitializer {

    private static final Logger LOGGER = Logger.getLogger(ProductInitializer.class.getName());

    public void init(@Observes @Initialized(ApplicationScoped.class) Object init) {
        LOGGER.info("Application initialized. Database schema and data will be managed by JPA schema generation.");
        LOGGER.info("Product data is loaded from META-INF/sql/import.sql script.");
    }
}
