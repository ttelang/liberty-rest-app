package io.microprofile.tutorial.store.inventory.entity;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Inventory class for the microprofile tutorial store application.
 * This class represents inventory information for products in the system.
 * We're using an in-memory data structure rather than a database.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Inventory {

    private Long inventoryId;

    @NotNull(message = "Product ID cannot be null")
    private Long productId;

    @NotNull(message = "Quantity cannot be null")
    @Min(value = 0, message = "Quantity must be greater than or equal to 0")
    private Integer quantity;
}
