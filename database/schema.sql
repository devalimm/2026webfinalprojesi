CREATE DATABASE IF NOT EXISTS ecommerce_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('customer', 'admin') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500) DEFAULT 'images/no-image.png',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Beklemede', 'Hazırlanıyor', 'Kargoya Verildi', 'Tamamlandı', 'İptal Edildi') NOT NULL DEFAULT 'Beklemede',
    shipping_address TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

INSERT INTO users (full_name, email, password, role) VALUES
('Admin User', 'admin@ecommerce.com', '$2a$12$L.B.6la7AUfh5kn1IaoNM.f7fsBVtaOT4u0C.O1IadZrRlhCeTO9S', 'admin');

INSERT INTO categories (name, description) VALUES
('Telefon', 'Akıllı telefonlar ve aksesuarları'),
('Bilgisayar', 'Dizüstü ve masaüstü bilgisayarlar'),
('Aksesuar', 'Elektronik aksesuarlar'),
('Kitap', 'Kitaplar ve e-kitaplar'),
('Giyim', 'Giyim ve moda ürünleri');

INSERT INTO products (category_id, name, description, price, stock, image_url) VALUES
(1, 'Samsung Galaxy S24', 'En yeni Samsung Galaxy S24 akıllı telefon, 128GB', 32999.99, 25, 'images/phone1.jpg'),
(1, 'iPhone 15 Pro', 'Apple iPhone 15 Pro 256GB, titanyum', 52999.99, 15, 'images/phone2.jpg'),
(1, 'Xiaomi Redmi Note 13', 'Xiaomi Redmi Note 13 128GB', 11999.99, 40, 'images/phone3.jpg'),
(2, 'MacBook Air M3', 'Apple MacBook Air M3 çip, 8GB RAM, 256GB SSD', 44999.99, 10, 'images/laptop1.jpg'),
(2, 'Dell XPS 15', 'Dell XPS 15, Intel i7, 16GB RAM, 512GB SSD', 38999.99, 8, 'images/laptop2.jpg'),
(2, 'Lenovo ThinkPad X1', 'Lenovo ThinkPad X1 Carbon, Intel i5, 16GB RAM', 32999.99, 12, 'images/laptop3.jpg'),
(3, 'Kablosuz Kulaklık', 'Bluetooth 5.3 kablosuz kulaklık, gürültü engelleme', 899.99, 100, 'images/accessory1.jpg'),
(3, 'USB-C Hub', '7-in-1 USB-C Hub adaptör', 449.99, 75, 'images/accessory2.jpg'),
(3, 'Taşınabilir Şarj Cihazı', '20000mAh powerbank, hızlı şarj', 599.99, 60, 'images/accessory3.jpg'),
(4, 'Clean Code', 'Robert C. Martin - Temiz Kod yazılım geliştirme rehberi', 349.99, 50, 'images/book1.jpg'),
(4, 'Design Patterns', 'Gang of Four - Tasarım Desenleri', 429.99, 30, 'images/book2.jpg'),
(4, 'Introduction to Algorithms', 'Thomas H. Cormen - Algoritmalara Giriş', 549.99, 20, 'images/book3.jpg'),
(5, 'Pamuklu Tişört', '%100 pamuk, rahat kesim tişört', 249.99, 200, 'images/cloth1.jpg'),
(5, 'Kot Pantolon', 'Slim fit kot pantolon', 599.99, 80, 'images/cloth2.jpg'),
(5, 'Spor Ayakkabı', 'Hafif ve rahat spor ayakkabı', 1299.99, 45, 'images/cloth3.jpg');
