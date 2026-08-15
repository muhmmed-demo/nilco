-- 1. جدول المستخدمين (يرتبط بـ Auth)
CREATE TABLE users (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  role TEXT NOT NULL CHECK (role IN ('sales_rep', 'manager', 'warehouse', 'admin')),
  branch_id UUID,
  avatar_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. جدول العملاء
CREATE TABLE customers (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  trade_name TEXT NOT NULL,
  contact_name TEXT,
  phone TEXT,
  address TEXT,
  city TEXT,
  region TEXT,
  customer_type TEXT CHECK (customer_type IN ('wholesale', 'retail')),
  credit_limit DECIMAL DEFAULT 0,
  assigned_rep_id UUID REFERENCES users(id),
  location_lat DECIMAL,
  location_lng DECIMAL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. جدول المنتجات
CREATE TABLE products (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sku TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  name_ar TEXT,
  category_id UUID,
  description TEXT,
  image_url TEXT,
  wholesale_price DECIMAL NOT NULL,
  retail_price DECIMAL NOT NULL,
  cost_price DECIMAL,
  barcode TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. جدول الطلبيات
CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_number TEXT UNIQUE NOT NULL,
  customer_id UUID REFERENCES customers(id),
  sales_rep_id UUID REFERENCES users(id),
  branch_id UUID,
  total_amount DECIMAL DEFAULT 0,
  discount_amount DECIMAL DEFAULT 0,
  tax_amount DECIMAL DEFAULT 0,
  net_amount DECIMAL DEFAULT 0,
  status TEXT DEFAULT 'pending' CHECK (status IN ('draft', 'pending', 'approved', 'rejected', 'fulfilled', 'delivered', 'cancelled')),
  payment_status TEXT DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'partial', 'paid')),
  notes TEXT,
  approved_by UUID REFERENCES users(id),
  approved_at TIMESTAMPTZ,
  fulfilled_by UUID REFERENCES users(id),
  fulfilled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. جدول منتجات الطلبية
CREATE TABLE order_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID REFERENCES products(id),
  quantity INT NOT NULL,
  unit_price DECIMAL NOT NULL,
  discount_pct DECIMAL DEFAULT 0,
  total_price DECIMAL NOT NULL,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. جدول المخزون
CREATE TABLE inventory (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  branch_id UUID,
  quantity_in_stock INT DEFAULT 0,
  quantity_reserved INT DEFAULT 0,
  quantity_available INT GENERATED ALWAYS AS (quantity_in_stock - quantity_reserved) STORED,
  min_stock_level INT DEFAULT 10,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. جدول الزيارات
CREATE TABLE visits (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  sales_rep_id UUID REFERENCES users(id),
  customer_id UUID REFERENCES customers(id),
  visit_date DATE DEFAULT CURRENT_DATE,
  check_in_at TIMESTAMPTZ,
  check_in_lat DECIMAL,
  check_in_lng DECIMAL,
  check_out_at TIMESTAMPTZ,
  check_out_lat DECIMAL,
  check_out_lng DECIMAL,
  notes TEXT,
  photos JSONB DEFAULT '[]',
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE visits ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users view own data" ON users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Reps view their orders" ON orders FOR SELECT USING (sales_rep_id = auth.uid());
CREATE POLICY "Managers view branch orders" ON orders FOR SELECT USING (EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'manager'));
CREATE POLICY "Warehouse view approved" ON orders FOR SELECT USING (status IN ('approved', 'fulfilled') AND EXISTS (SELECT 1 FROM users WHERE id = auth.uid() AND role = 'warehouse'));
CREATE POLICY "Reps view assigned customers" ON customers FOR SELECT USING (assigned_rep_id = auth.uid());
CREATE POLICY "Reps view their visits" ON visits FOR SELECT USING (sales_rep_id = auth.uid());
