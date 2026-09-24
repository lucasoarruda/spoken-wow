-- The collaborator role becomes two English grants, and the role goes.
--
-- 0037 kept `collaborator` so that nobody who held it needed a grant row to go on working in
-- English. That left two answers to "what may this person do in a language": the role for
-- English, grants for the rest, and a special case in `can` to join them. English is a
-- language like any other now, so the role is replaced by exactly what it meant -- edit and
-- regenerate in enUS -- and every global role is `member` or `admin`.
--
-- Safe to roll back past: the release before this one already reads grants for English too
-- (its `can` falls through to them for any language), so everyone keeps English under it.
-- The one thing it gates on the role alone is the unlinked /contributions/game-data page.
insert into "language_grant" ("userId", "lang", "capability")
select u."id", 'enUS', c."capability"
  from "user" u
 cross join (values ('edit'), ('regenerate')) as c ("capability")
 where u."role" = 'collaborator'
    on conflict ("userId", "lang", "capability") do nothing;

update "user" set "role" = 'member' where "role" = 'collaborator';
