package io.microprofile.tutorial.store.inventory.service;

import io.microprofile.tutorial.store.inventory.entity.Inventory;
import io.microprofile.tutorial.store.inventory.repository.InventoryRepository;

import java.util.List;
import java.util.Optional;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.ws.rs.WebApplicationException;
import jakarta.ws.rs.core.Response;

/**
 * Service class for Inventory management operations.
 */
@ApplicationScoped
public class InventoryService {

    @Inject
    private InventoryRepository inventoryRepository;

    /**
     * Creates a new inventory item.
     *
     * @param inventory The inventory to create
     * @return The created inventory
     * @throws WebApplicationException if inventory with the product ID already exists
     */
    public Inventory createInventory(Inventory inventory) {
        // Check if product ID already exists
        Optional<Inventory> existingInventory = inventoryRepository.findByProductId(inventory.getProductId());
        if (existingInventory.isPresent()) {
            throw new WebApplicationException("Inventory for product already exists", Response.Status.CONFLICT);
        }
        
        return inventoryRepository.save(inventory);
    }

    /**
     * Gets an inventory item by ID.
     *
     * @param id The inventory ID
     * @return The inventory
     * @throws WebApplicationException if the inventory is not found
     */
    public Inventory getInventoryById(Long id) {
        return inventoryRepository.findById(id)
                .orElseThrow(() -> new WebApplicationException("Inventory not found", Response.Status.NOT_FOUND));
    }

    /**
     * Gets inventory by product ID.
     *
     * @param productId The product ID
     * @return The inventory
     * @throws WebApplicationException if the inventory is not found
     */
    public Inventory getInventoryByProductId(Long productId) {
        return inventoryRepository.findByProductId(productId)
                .orElseThrow(() -> new WebApplicationException("Inventory not found for product", Response.Status.NOT_FOUND));
    }

    /**
     * Gets all inventory items.
     *
     * @return A list of all inventory items
     */
    public List<Inventory> getAllInventories() {
        return inventoryRepository.findAll();
    }

    /**
     * Updates an inventory item.
     *
     * @param id The inventory ID
     * @param inventory The updated inventory information
     * @return The updated inventory
     * @throws WebApplicationException if the inventory is not found
     */
    public Inventory updateInventory(Long id, Inventory inventory) {
        // Check if product ID exists in a different inventory record
        Optional<Inventory> existingInventoryWithProductId = inventoryRepository.findByProductId(inventory.getProductId());
        if (existingInventoryWithProductId.isPresent() && 
            !existingInventoryWithProductId.get().getInventoryId().equals(id)) {
            throw new WebApplicationException("Another inventory record already exists for this product", 
                                             Response.Status.CONFLICT);
        }
        
        return inventoryRepository.update(id, inventory)
                .orElseThrow(() -> new WebApplicationException("Inventory not found", Response.Status.NOT_FOUND));
    }

    /**
     * Deletes an inventory item.
     *
     * @param id The inventory ID
     * @throws WebApplicationException if the inventory is not found
     */
    public void deleteInventory(Long id) {
        boolean deleted = inventoryRepository.deleteById(id);
        if (!deleted) {
            throw new WebApplicationException("Inventory not found", Response.Status.NOT_FOUND);
        }
    }

    /**
     * Updates the quantity for a product.
     *
     * @param productId The product ID
     * @param quantity The new quantity
     * @return The updated inventory
     * @throws WebApplicationException if the inventory is not found
     */
    public Inventory updateQuantity(Long productId, int quantity) {
        Inventory inventory = getInventoryByProductId(productId);
        inventory.setQuantity(quantity);
        return inventoryRepository.save(inventory);
    }
}
