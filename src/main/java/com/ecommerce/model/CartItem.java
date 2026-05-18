package com.ecommerce.model;

import java.io.Serializable;
import java.math.BigDecimal;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int productId;
    private String productName;
    private BigDecimal price;
    private int quantity;
    private int stock;
    private String imageUrl;

    public CartItem() {}

    public CartItem(int productId, String productName, BigDecimal price, int quantity, int stock, String imageUrl) {
        this.productId = productId;
        this.productName = productName;
        this.price = price;
        this.quantity = quantity;
        this.stock = stock;
        this.imageUrl = imageUrl;
    }

    public BigDecimal getSubtotal() {
        return price.multiply(new BigDecimal(quantity));
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
