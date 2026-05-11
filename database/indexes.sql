-- indexes 

CREATE INDEX IF NOT EXISTS idx_artworks_is_sold ON artworks(is_sold);
CREATE INDEX IF NOT EXISTS idx_artworks_user_id ON artworks(user_id);

CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_artworks_id ON order_items(artworks_id);

CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);