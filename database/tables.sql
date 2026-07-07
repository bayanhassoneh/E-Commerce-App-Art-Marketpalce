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
--
-- orders table
create table orders (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references public.profiles(id) on delete cascade default auth.uid(),
  total_price numeric not null,
  status text default 'pinding',
  created_at timestamp with time zone default now()
);
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
  user_id uuid references auth.users(id) on delete cascade default auth.uid(),
  artworks_id uuid references artworks(id) on delete cascade,
  id uuid default gen_random_uuid() primary key,
  created_at timestamp with time zone default now(),
  unique(user_id, artworks_id)
);
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
--
-- price_logs table
create table public.price_logs (
  id uuid default gen_random_uuid() primary key,
  artwork_id uuid references public.artworks(id) on delete cascade not null,
  old_price numeric not null,
  new_price numeric not null,
  changed_at timestamp with time zone DEFAULT timezone('utc'::text, now()) not null
);
