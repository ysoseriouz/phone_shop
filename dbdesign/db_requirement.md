# Database design note

Tables: Inventories, Accounts, Roles, Brands, Models, Albums, Photos.

Auto-generate ID as primary key for each entities.

## Brand and Model
1 brand has many models => Foreign key in model: brand_id

## Inventories
Belongs to 1 brand, 1 model and has 1 album of photos => Foreign key to album_id, model_id (1 model also belongs to 1 brand)

## Albums and Photos
Inventories and Albums are one-to-one relationship => Foreign key in Inventories (accept NULL).

Album has many photos, a set of photos belongs to an album, choose one photo as thumbnail for album (FK thumbnail_id).

## Accounts and Roles
Account can only be 1 role (currently).

Roles may represent for a set of accordance rights (decide later).