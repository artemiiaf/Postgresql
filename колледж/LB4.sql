CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL,
    supplier_info TEXT,  -- конфиденциально
    internal_notes TEXT  -- только для сотрудников
);
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products,
    user_id INT,
    quantity INT,
    created_at TIMESTAMP
);
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    contact_info TEXT,
    bank_details TEXT  -- очень конфиденциально
);



-- Группы (роли без логина)
CREATE ROLE customers;      -- клиенты
CREATE ROLE sales;          -- продавцы
CREATE ROLE managers;       -- менеджеры
CREATE ROLE accountants;    -- бухгалтеры
CREATE ROLE admins;         -- администраторы-- Пользователи
CREATE USER ivan WITH PASSWORD 'ivan123';
CREATE USER petr WITH PASSWORD 'petr123';
CREATE USER anna WITH PASSWORD 'anna123';
CREATE USER admin WITH PASSWORD 'admin123' SUPERUSER;-- Назначаем роли
GRANT customers TO ivan;
GRANT sales TO petr;
GRANT accountants TO anna;
GRANT admins TO admin, petr;  -- Петр еще и админ


-- 1. Базовые права для всех
GRANT CONNECT ON DATABASE shop TO customers, sales, 
managers, accountants;-- 2. Права на схему
GRANT USAGE ON SCHEMA public TO customers, sales, managers, 
accountants;-- 3. КЛИЕНТЫ (только видят товары)
GRANT SELECT ON products TO customers;
GRANT SELECT (id, name, price) ON products TO customers;
GRANT SELECT, INSERT ON orders TO customers;  -- могут создавать заказы-- 4. ПРОДАВЦЫ (видят больше, могут обновлять)
GRANT SELECT, UPDATE ON products TO sales;
GRANT SELECT, UPDATE ON orders TO sales;
GRANT SELECT (name, contact_info) ON suppliers TO sales;  -- только имя и контакт-- 5. МЕНЕДЖЕРЫ (почти всё, кроме финансов)
GRANT ALL ON products, orders TO managers;
GRANT SELECT ON suppliers TO managers;-- 6. БУХГАЛТЕРЫ (финансовая информация)
GRANT SELECT (id, name, price) ON products TO accountants;
GRANT SELECT, UPDATE ON orders TO accountants;
GRANT SELECT (name, bank_details) ON suppliers TO 
accountants;  -- банковские реквизиты-- 7. АДМИНЫ (всё)
GRANT ALL ON ALL TABLES IN SCHEMA public TO admins;




SET ROLE ivan;
SELECT id, name, price FROM products; -- ✅ Должно сработать
-- SELECT supplier_info FROM products; -- ❌ ОШИБКА (раскомментируй, чтобы проверить)
-- SELECT * FROM suppliers;           -- ❌ ОШИБКА
RESET ROLE;

-- ПРОВЕРКА ПЕТРА
SET ROLE petr;
SELECT * FROM products;               -- ✅ OK
UPDATE products SET price = 100 WHERE id = 1; -- ✅ OK
SELECT * FROM suppliers;              -- ✅ OK (он же админ)
RESET ROLE;


-- 1. СОЗДАЕМ ВСЕ РОЛИ (ДОЛЖНОСТИ)
-- Сначала создаем их, чтобы база знала, кто это такие
CREATE ROLE employees;
CREATE ROLE sales_dept;
CREATE ROLE accounting_dept;
CREATE ROLE sales_managers;
CREATE ROLE sales_staff;


-- 2. СТРОИМ ИЕРАРХИЮ (КТО КОМУ ПОДЧИНЯЕТСЯ)
-- Теперь, когда все созданы, ошибки не будет
GRANT employees TO sales_dept, accounting_dept;
GRANT sales_dept TO sales_managers, sales_staff;
GRANT accounting_dept TO accountants;

-- 3. СОЗДАЕМ СОТРУДНИКОВ
DROP USER IF EXISTS john;
DROP USER IF EXISTS jane;

CREATE USER john WITH PASSWORD 'john123' IN ROLE sales_staff;
CREATE USER jane WITH PASSWORD 'jane123' IN ROLE accountants;

ALTER TABLE products ADD COLUMN created_by TEXT DEFAULT current_user;


-- 1. Включаем RLS
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- 2. Создаем политику видимости
CREATE POLICY products_policy ON products FOR SELECT USING (
    pg_has_role(current_user, 'admins', 'member') OR 
    pg_has_role(current_user, 'managers', 'member') OR 
    created_by = current_user
);


-- 1. Сначала убедимся, что RLS включен
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- 2. Переписываем политику SELECT (Кто что видит)
-- pg_has_role(пользователь, роль, тип_проверки)
DROP POLICY IF EXISTS products_policy ON products;
CREATE POLICY products_policy ON products FOR SELECT USING (
    pg_has_role(current_user, 'admins', 'member') OR   -- если ты в группе админов
    pg_has_role(current_user, 'managers', 'member') OR -- если ты в группе менеджеров
    created_by = current_user                          -- или если это твой товар
);

-- 3. Политика INSERT (Проверка цены)
DROP POLICY IF EXISTS products_insert_policy ON products;
CREATE POLICY products_insert_policy ON products FOR INSERT WITH CHECK (
    price > 0 
);

-- 4. Политика UPDATE (Кто может менять)
DROP POLICY IF EXISTS products_update_policy ON products;
CREATE POLICY products_update_policy ON products FOR UPDATE USING (
    pg_has_role(current_user, 'admins', 'member') OR 
    created_by = current_user
);


