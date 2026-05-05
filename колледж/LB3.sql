
CREATE OR REPLACE FUNCTION function_name(param1 INT)
RETURNS INT AS $$
BEGIN
    RETURN param1 * 2;
END;
$$ LANGUAGE plpgsql;-- Вызов:
SELECT function_name(5);  -- 10



CREATE TABLE logs (
    id INT,              
    event_time TIMESTAMP 
);



CREATE OR REPLACE PROCEDURE procedure_name(param1 
INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO logs VALUES (param1, now());
    COMMIT; 
END;
$$;-- Вызов:
CALL procedure_name(5)



-- Категории продуктов
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    product_count INT DEFAULT 0,
    total_value DECIMAL(15,2) DEFAULT 0);
	
	-- Продукты
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INT REFERENCES categories(id),
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);




CREATE OR REPLACE PROCEDURE recalculate_all_categories()
LANGUAGE plpgsql
AS $$
DECLARE
    cur_cursor CURSOR FOR SELECT id FROM categories;
    v_category_id INT;
BEGIN
    OPEN cur_cursor;
    LOOP
        FETCH cur_cursor INTO v_category_id;
        EXIT WHEN NOT FOUND;
        
        -- Обновляем статистику каждой категории
        UPDATE categories SET 
            product_count = (SELECT COUNT(*) FROM products WHERE category_id = v_category_id),
            total_value = (SELECT COALESCE(SUM(price * quantity), 0) 
                          FROM products WHERE category_id = v_category_id)
        WHERE id = v_category_id;
        
        COMMIT;  -- Коммитим каждую категорию отдельно!
    END LOOP;
    CLOSE cur_cursor;
END;
$$;


-- задание --

CREATE TABLE inventory_logs (
    id SERIAL PRIMARY KEY,    
    product_id INT,          
    quantity_changed INT,    
    reason TEXT,              
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE OR REPLACE PROCEDURE decommission_product(
    p_id INT,       
    p_qty INT,    
    p_reason TEXT 
)
LANGUAGE plpgsql    
AS $$               
BEGIN             

    
    UPDATE products 
    SET stock_quantity = stock_quantity - p_qty 
    WHERE id = p_id;

    
    INSERT INTO inventory_logs (product_id, quantity_changed, reason)
    VALUES (p_id, p_qty, p_reason);

    
    COMMIT;

END; 
$$;

