package io.microprofile.tutorial.store.inventory.repository;

import io.microprofile.tutorial.store.inventory.entity.Inventory;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import jakarta.enterprise.context.ApplicationScoped;

/**
 * Simple in-memory repository for Inventory objects.
 * This class provides CRUD operations for Inventory entities to demonstrate MicroProfile concepts.
 */
@ApplicationScoped
public class InventoryRepository {

    private final Map<Long, Inventory> inventories = new HashMap<>();
    private long nextId = 1;

    /**
     * Saves an inventory item to the repository.
     * If the inventory has no ID, a new ID is assigned.
     *
     * @param inventory The inventory to save
     * @return The saved inventory with ID assigned
     */
    public Inventory save(Inventory inventory) {
        if (inventory.getInventoryId() == null) {
            inventory.setInventoryId(nextId++);
        }
        inventories.put(inventory.getInventoryId(), inventory);
        return inventory;
    }

    /**
     * Finds an inventory item by ID.
     *
     * @param id The inventory ID
     * @return An Optional containing the inventory if found, or empty if not found
     */
    public Optional<Inventory> findById(Long id) {
        return Optional.ofNullable(inventories.get(id));
    }

    /**
     * Finds inventory by product ID.
     *
     * @param productId The product ID
     * @return An Optional containing the inventory if found, or empty if not found
     */
    public Optional<Inventory> findByProductId(Long productId) {
        return inventories.values().stream()
                .filter(inventory -> inventory.getProductId().equals(productId))
                .findFirst();
    }

    /**
     * Retrieves all inventory items from the repository.
     *
     * @return A list of all inventory items
     */
    public List<Inventory> findAll() {
        return new ArrayList<>(inventories.values());
    }

    /**
     * Deletes an inventory item by ID.
     *
     * @param id The ID of the inventory to delete
     * @return true if the inventory was deleted, false if not found
     */
    public boolean deleteById(Long id) {
        return inventories.remove(id) != null;
    }

    /**
     * Updates an existing inventory item.
     *
     * @param id The ID of the inventory to update
     * @param inventory The updated inventory information
     * @return An Optional containing the updated inventory, or empty if not found
     */
    public Optional<Inventory> update(Long id, Inventory inventory) {
        if (!inventories.containsKey(id)) {
            return Optional.empty();
        }
        
        inventory.setInventoryId(id);
        inventories.put(id, inventory);
        return Optional.of(inventory);
    }
}
