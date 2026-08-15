-- إضافة مستخدم تجريبي (لازم تسجله في Auth أولاً)
INSERT INTO users (id, full_name, email, phone, role, is_active)
VALUES 
  ('00000000-0000-0000-0000-000000000001', 'أحمد محمد', 'ahmed@nilco.com', '01001234567', 'sales_rep', true),
  ('00000000-0000-0000-0000-000000000002', 'محمد المدير', 'manager@nilco.com', '01002345678', 'manager', true),
  ('00000000-0000-0000-0000-000000000003', 'خالد المخزن', 'warehouse@nilco.com', '01003456789', 'warehouse', true);

-- إضافة عملاء
INSERT INTO customers (trade_name, contact_name, phone, address, city, region, customer_type, assigned_rep_id)
VALUES 
  ('محل الألعاب الذهبية', 'محمد علي', '01011111111', 'التجمع الخامس، شارع التسعين', 'القاهرة', 'التجمع', 'retail', '00000000-0000-0000-0000-000000000001'),
  ('هايبر ماركت النيل', 'أحمد سعيد', '01022222222', 'مدينة نصر، شارع مصطفى النحاس', 'القاهرة', 'مدينة نصر', 'wholesale', '00000000-0000-0000-0000-000000000001'),
  ('مكتبة المعرفة', 'سارة كمال', '01033333333', 'مدينة نصر، شارع عباس العقاد', 'القاهرة', 'مدينة نصر', 'retail', '00000000-0000-0000-0000-000000000001');

-- إضافة منتجات Nilco
INSERT INTO products (sku, name, name_ar, wholesale_price, retail_price, barcode, is_active)
VALUES 
  ('NIL-JACK-001', 'Jackaroo Deluxe', 'جاكارو ديلوكس', 320, 450, '6223000123456', true),
  ('NIL-RUM-001', 'Rummikub Classic', 'روميكوب كلاسيك', 220, 320, '6223000123457', true),
  ('NIL-MAS-001', 'Mastermind', 'ماسترمايند', 180, 280, '6223000123458', true),
  ('NIL-PC-001', 'Playing Cards Premium', 'ورق لعب بريميوم', 50, 85, '6223000123459', true),
  ('NIL-TRI-001', 'Triominos Original', 'تراومينوس أوريجينال', 240, 350, '6223000123460', true);

-- إضافة مخزون
INSERT INTO inventory (product_id, quantity_in_stock, min_stock_level)
SELECT id, 50, 10 FROM products WHERE sku = 'NIL-JACK-001';
INSERT INTO inventory (product_id, quantity_in_stock, min_stock_level)
SELECT id, 30, 10 FROM products WHERE sku = 'NIL-RUM-001';
INSERT INTO inventory (product_id, quantity_in_stock, min_stock_level)
SELECT id, 100, 10 FROM products WHERE sku = 'NIL-MAS-001';
INSERT INTO inventory (product_id, quantity_in_stock, min_stock_level)
SELECT id, 200, 20 FROM products WHERE sku = 'NIL-PC-001';
INSERT INTO inventory (product_id, quantity_in_stock, min_stock_level)
SELECT id, 80, 10 FROM products WHERE sku = 'NIL-TRI-001';
