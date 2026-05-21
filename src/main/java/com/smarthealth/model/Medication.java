package com.smarthealth.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Medication {
    private int id;
    private String name;
    private String genericName;
    private String category;
    private String dosageForm; // e.g. tablet, capsule, syrup, etc.
    private String unit; // e.g. mg, ml
    private int stockQuantity;
    private int reorderLevel;
    private BigDecimal unitPrice;
    private LocalDate expiryDate;
    private boolean isActive;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getGenericName() { return genericName; }
    public void setGenericName(String genericName) { this.genericName = genericName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDosageForm() { return dosageForm; }
    public void setDosageForm(String dosageForm) { this.dosageForm = dosageForm; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public int getReorderLevel() { return reorderLevel; }
    public void setReorderLevel(int reorderLevel) { this.reorderLevel = reorderLevel; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}
