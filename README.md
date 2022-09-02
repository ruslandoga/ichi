An attempt to translate [tshatrov/ichiran](https://github.com/tshatrov/ichiran) to Elixir and move data to SQLite.

```sh
# loading dump, on mac
curl -LO https://github.com/tshatrov/ichiran/releases/download/ichiran-230122/ichiran-230122.pgdump
createdb -E 'UTF8' -l 'ja_JP.UTF-8' -T template0 ichi
pg_restore -1 -d ichi -U postgres -L pg/db.list -O ichiran-230122.pgdump
```

- [ ] explore ichiran db
- [ ] translate main logic to elixir
- [ ] move from postgres to sqlite
