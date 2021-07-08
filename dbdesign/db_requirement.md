# Database design note

Tables: Inventories, Accounts, Roles, Brands, Models, Photos.

Auto-generate ID as primary key for each entities.

## Brand and Model
1 brand has many models => Foreign key in model: brand_id

## Inventories
Belongs to 1 brand, 1 model and has many photos (only 1 thumbnail) => Foreign key to album_id, model_id (1 model also belongs to 1 brand)

## Inventories and Photos
Inventories and Photos are one-to-many relationship => Foreign key in Photos.

Choose one photo as thumbnail for an inventory (FK thumbnail_id).

## Accounts and Roles
Account can only be 1 role (currently).

Roles may represent for a set of accordance rights (decide later).