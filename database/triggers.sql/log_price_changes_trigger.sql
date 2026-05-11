create or replace function public.log_price_changes()
returns trigger as $$
begin
  if (old.price <> new.price) then 
    insert into public.price_logs (artwork_id, old_price, new_price)
    values (new.id, old.price, new.price);
  end if;
  return new;
end;
$$ language plpgsql;

create trigger on_price_updated
  after update on public.artworks
  for each row execute procedure public.log_price_changes();