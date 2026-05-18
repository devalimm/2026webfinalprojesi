package com.ecommerce.dao;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int createOrder(Order order, List<OrderItem> items) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String orderSql = "INSERT INTO orders (user_id, total_amount, status, shipping_address) VALUES (?, ?, ?, ?)";
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getUserId());
                ps.setBigDecimal(2, order.getTotalAmount());
                ps.setString(3, order.getStatus());
                ps.setString(4, order.getShippingAddress());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            String itemSql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (OrderItem item : items) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    ps.setBigDecimal(4, item.getUnitPrice());
                    ps.setBigDecimal(5, item.getSubtotal());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            String stockSql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";
            try (PreparedStatement ps = conn.prepareStatement(stockSql)) {
                for (OrderItem item : items) {
                    ps.setInt(1, item.getQuantity());
                    ps.setInt(2, item.getProductId());
                    ps.setInt(3, item.getQuantity());
                    int updated = ps.executeUpdate();
                    if (updated == 0) {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            conn.commit();
            return orderId;
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return -1;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS user_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrder(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order findById(int orderId) {
        String sql = "SELECT o.*, u.full_name AS user_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setItems(findItemsByOrderId(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Order> findAll() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS user_name FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<OrderItem> findItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setUnitPrice(rs.getBigDecimal("unit_price"));
                    item.setSubtotal(rs.getBigDecimal("subtotal"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setUserName(rs.getString("user_name"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(rs.getString("status"));
        o.setShippingAddress(rs.getString("shipping_address"));
        return o;
    }
}
