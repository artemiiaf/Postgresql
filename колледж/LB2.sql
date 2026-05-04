
-- Создание таблиц
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    product_count INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INT REFERENCES categories(id) ON DELETE SET NULL,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Функция триггера
CREATE OR REPLACE FUNCTION update_category_product_count() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE categories SET product_count = product_count + 1 WHERE id = NEW.category_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE categories SET product_count = product_count - 1 WHERE id = OLD.category_id;
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.category_id IS DISTINCT FROM NEW.category_id THEN
            UPDATE categories SET product_count = product_count - 1 WHERE id = OLD.category_id;
            UPDATE categories SET product_count = product_count + 1 WHERE id = NEW.category_id;
        END IF;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Создание триггера
DROP TRIGGER IF EXISTS trg_update_product_count ON products;
CREATE TRIGGER trg_update_product_count
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION update_category_product_count();
