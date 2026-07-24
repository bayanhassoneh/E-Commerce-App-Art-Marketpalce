-- This script initializes the main tables
--
-- profiles table
create table public.profiles (
id uuid references auth.users(id) on delete cascade primary key,
email text not null ,
user_name text unique,
cover_url text,
location text, 
bio text,
followers integer default 0,
following integer default 0,
--add
joined_date timestamp with time zone default timezone('utc'::text, now()) not null
);
--

-- artworks table
create table public.artworks (
  id uuid default gen_random_uuid() primary key,
user_id uuid references public.profiles(id) on delete cascade, 
  title text ,
  description text,
  image_url text ,
  price numeric,
  is_sold boolean default false,
created_at timestamp with time zone default timezone('utc'::text, now()) not null
);
--
-- likes table
create table public.likes (
  id uuid default gen_random_uuid() primary key  ,
  user_id uuid references public.profiles(id) on delete cascade ,
artworks_id uuid references public.artworks(id) on delete cascade,
created_at timestamp with time zone default timezone('utc'::text, now()),
unique(user_id, artworks_id)
);

ALTER TABLE public.likes
ADD CONSTRAINT fk_likes_profile 
FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.likes
ADD CONSTRAINT fk_likes_artwork 
FOREIGN KEY (artworks_id) REFERENCES public.artworks(id) ON DELETE CASCADE;
--
-- orders table
create table orders (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade default auth.uid(),
  total_price numeric not null,
  status text default 'pending',
  created_at timestamp with time zone default now()
);
ALTER TABLE public.orders
ADD CONSTRAINT fk_orders_profile 
FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--
-- order_items table
create table order_items (
id uuid default gen_random_uuid() primary key,
order_id uuid references orders(id) on delete cascade ,
artworks_id uuid references public.artworks(id),
price_at_purchase numeric not null,
UNIQUE(artworks_id)
);
--
-- cart_items table
create table cart_items  (
  user_id uuid references public.profiles(id) on delete cascade default auth.uid(),
  artworks_id uuid references public.artworks(id) on delete cascade,
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default now(),
  unique(user_id, artworks_id)
);
ALTER TABLE public.cart_items
ADD CONSTRAINT fk_cart_items_profile 
FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--
-- payments table
create table payments (
payment_id uuid default gen_random_uuid() primary key,
order_id uuid references orders(id) on delete cascade not null ,
user_id uuid references public.profiles(id) not null,
amount decimal(10, 2) not null,
status text check(status in ('pending', 'completed', 'failed', 'refunded')),
currency text default 'JD',
payment_method text, 
transaction_id text unique,
created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) not null
);
ALTER TABLE public.payments
ADD CONSTRAINT fk_payments_profile 
FOREIGN KEY (user_id) REFERENCES public.profiles(id);
--
-- conversations table
create table conversations(
id uuid default gen_random_uuid()  primary key,
user1_id uuid references public.profiles(id) ,
user2_id uuid references public.profiles(id),
last_messsage text,
last_messag_time timestamp with time zone default timezone('utc'::text, now()) not null,
unique(user1_id, user2_id)
);
-- 1. ربط العمود الأول في جدول المحادثات بجدول البروفايل
ALTER TABLE public.conversations
ADD CONSTRAINT fk_conversations_user1 
FOREIGN KEY (user1_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

-- 2. ربط العمود الثاني في جدول المحادثات بجدول البروفايل
ALTER TABLE public.conversations
ADD CONSTRAINT fk_conversations_user2 
FOREIGN KEY (user2_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--


-- messages table
create table messages(
  id uuid default gen_random_uuid() primary key,
  conversation_id uuid references conversations(id) on delete cascade,
  sender_id uuid references public.profiles(id) on delete cascade, 
  text_message text not null,
is_read boolean default false,
  created_at timestamp with time zone default timezone('utc'::text, now())not null
);
-- إضافة قيد الربط لعمود المرسل بشكل صريح لتظهر الخطوط في الرسمة
ALTER TABLE public.messages
ADD CONSTRAINT fk_messages_sender_profile 
FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--
-- notifications table
-- create table if not exists public.notifications (
--   id uuid default gen_random_uuid() primary key,
--   receiver_id uuid references public.profiles(id) on delete cascade, 
--   sender_id uuid references public.profiles(id)on delete cascade, 
--   type text,
--   content text not null, 
--   is_read boolean default false,
--   created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) not null
-- ); 
-- --
-- rates table
create table public.rates(
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade ,
  artworks_id uuid references public.artworks(id) on delete cascade,
stars integer check (stars >= 1 and stars <= 5),
created_at timestamp with time zone default timezone('utc'::text, now()),
unique(user_id, artworks_id)
);
ALTER TABLE public.rates
ADD CONSTRAINT fk_rates_profile 
FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--
-- follows table
create table follows (
  id uuid default gen_random_uuid() primary key,
  follower_id uuid references public.profiles(id) on delete cascade,
  following_id uuid references public.profiles(id) on delete cascade, 
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  unique(follower_id, following_id),
  check (follower_id <> following_id)
);
ALTER TABLE public.follows
ADD CONSTRAINT fk_follows_follower_profile 
FOREIGN KEY (follower_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.follows
ADD CONSTRAINT fk_follows_following_profile 
FOREIGN KEY (following_id) REFERENCES public.profiles(id) ON DELETE CASCADE;
--
-- notifications table
create table if not exists public.notifications (
  id uuid default gen_random_uuid() primary key,
  receiver_id uuid references public.profiles(id) on delete cascade, 
  sender_id uuid references public.profiles(id)on delete cascade, 
  type text,
  content text not null, 
  is_read boolean default false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) not null
);
ALTER TABLE public.notifications
ADD CONSTRAINT fk_notifications_receiver_profile 
FOREIGN KEY (receiver_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.notifications
ADD CONSTRAINT fk_notifications_sender_profile 
FOREIGN KEY (sender_id) REFERENCES public.profiles(id) ON DELETE CASCADE;

--
-- price_logs table
create table public.price_logs (
  id uuid default gen_random_uuid() primary key,
  artwork_id uuid references public.artworks(id) on delete cascade not null,
  old_price numeric not null,
  new_price numeric not null,
  changed_at timestamp with time zone DEFAULT timezone('utc'::text, now()) not null
);
