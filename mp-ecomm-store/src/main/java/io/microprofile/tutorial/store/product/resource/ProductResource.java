package io.microprofile.tutorial.store.product.resource;

import io.microprofile.tutorial.store.product.entity.Product;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.ArrayList;
import java.util.List;

@Path("/products")
public class ProductResource {

    private List<Product> products = new ArrayList<>();

    public ProductResource() {
        // Initialize the list with some sample products
        products.add(new Product(1L, "iPhone", "Apple iPhone 15", 999.99));
        products.add(new Product(2L, "MacBook", "Apple MacBook Air", 1299.0));
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllProducts() {
        return Response.ok(products).build();
    }
}
