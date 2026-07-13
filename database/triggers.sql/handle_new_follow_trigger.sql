create or replace function public.handle_new_follow()
returns trigger as $$
begin
  insert into public.notifications (receiver_id, sender_id, type, content)
  values (
    new.following_id,
    new.follower_id,  
    'follow', 
    'new follower',
  );
  return new;
end;
$$ language plpgsql;

create trigger on_follow_added
  after insert on public.follows
  for each row execute procedure public.handle_new_follow();