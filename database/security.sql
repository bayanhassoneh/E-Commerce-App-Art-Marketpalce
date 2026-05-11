-- 1. Enable RLS for all tables
alter table profiles enable row level security;
alter table artworks enable row level security;
alter table likes enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;
alter table cart_items enable row level security;
alter table payments enable row level security;
alter table conversations enable row level security;
alter table messages enable row level security;
alter table notifications enable row level security;
alter table rates enable row level security;
alter table follows enable row level security;
alter table notifications enable row level security;
alter table price_logs enable row level security;
--
--profiles policies >>>>>>>>
create policy "profiles are viewable by everyone"
on public.profiles 
for select using(true);

create policy "users can update their own profiles"
on public.profiles for update using (auth.uid()= id);

--artworks policies >>>>>>>>
create policy "allow public read access"
on public.artworks
for select
 using(true);
 
CREATE POLICY "artworks_insert_authenticated" 
ON artworks FOR INSERT 
WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

CREATE POLICY "artworks_update_owner" 
ON artworks FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "artworks_delete_owner" 
ON artworks FOR DELETE 
USING (auth.uid() = user_id);

--likes policies >>>>>>>>>>>
create policy "everyone can see artworks "
on public.likes for select using(true);

create policy " only Authenticated can like artworks"
on public.likes for insert WITH CHECK(auth.role() = 'authenticated' AND auth.uid() = user_id);

create policy "Users can delete their own likes"
on public.likes for delete using(auth.uid()= user_id);

-- order policies >>>>>>>>>>>
create policy "user can see only their own previous orders "
on orders for select using ( auth.uid() = user_id);

create policy " user can insert their own orders"
on orders for insert WITH CHECK ( auth.role()= 'authenticated' and auth.uid() = user_id );

-- order_items policies >>>>>>
create policy "user can see only their own order items details "
on order_items for select using (EXISTS (
    SELECT 1 FROM orders 
    WHERE orders.id = order_items.order_id 
    AND orders.user_id = auth.uid()
  ));

-- cart_items policies >>>>>>>
create policy "user can see only their own cart items "
on cart_items for select using ( auth.uid() = user_id);

create policy "user can update only their own cart "
on cart_items for update using (auth.uid() = user_id );

create policy "user can delete only their own cart items "
on cart_items for delete using (auth.uid() = user_id );

create policy " user can insert only to their own cart"
on cart_items for insert WITH CHECK ( auth.role()= 'authenticated' and auth.uid() = user_id );

-- payments policies >>>>>>>>>
CREATE POLICY "Users can view their own payments" 
ON payments FOR SELECT USING (auth.uid() = user_id);

-- conversations policies >>>>>>
create policy "only user1 and user2 can read conversation "
on conversations for select using((auth.uid() = user1_id) or(auth.uid() = user2_id) );

create policy "only user1 and user2 can send messages on conversation"
on conversations for insert WITH CHECK((auth.uid() = user1_id) or(auth.uid() = user2_id) );

-- messages policies >>>>>>>>>>
create policy "only sender & receiver can read conversation"
on messages for select using ( auth.uid() = sender_id OR exists (
  select 1 from conversations 
  where id = conversation_id 
  and (user1_id = auth.uid() or user2_id = auth.uid())
) ) ;

-- notifications policies >>>>>>>>
create policy "user sees his own notifications"
ON notifications FOR SELECT USING (auth.uid() = receiver_id);

create policy "Users can update their own notifications"
  on public.notifications for update
  using ( auth.uid() = receiver_id );

-- rates policies >>>>>>>>>>

create policy "everyone can see ratings "
on public.rates for select using(true);

create policy " only Authenticated can rate artworks"
on public.rates for insert WITH CHECK (auth.role() = 'authenticated' AND auth.uid() = user_id);

create policy "Users can delete their own rateings "
on public.rates for delete using(auth.uid()= user_id);


-- follows policies >>>>>>>>>>
create policy "all users can see following and followers"
on follows for select using (true);

create policy "user can unfollow with their own id "
on follows for delete using (auth.uid() =  follower_id );

create policy " authentication user can do follow with their own id"
on follows for insert WITH CHECK ( auth.role()= 'authenticated' and auth.uid() =   follower_id );

--notifications policies >>>>>>>
create policy "user sees his own notifications"
ON notifications FOR SELECT USING (auth.uid() = receiver_id);

create policy "Users can update their own notifications"
  on public.notifications for update
  using ( auth.uid() = receiver_id );

 --price_logs policies >>>>>>>>
  create policy "Allow public read access to price logs"
  on public.price_logs for select
  using ( true );