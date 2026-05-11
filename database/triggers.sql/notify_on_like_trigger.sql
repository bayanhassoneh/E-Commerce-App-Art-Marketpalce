create or replace function public.notify_on_like()
returns trigger as $$
begin
  insert into public.notifications (receiver_id, sender_id,type,content)
 values (
    (select user_id from public.artworks where id = new.artwork_id), 
    new.user_id, 
    'like',      
    'Someone liked your artwork!'
  );

  return new;
end;
$$ language plpgsql;

create trigger on_like_added
  after insert on public.likes
  for each row execute procedure public.notify_on_like();