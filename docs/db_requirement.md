# Database design note

Tables: Inventories, Accounts, Roles, Brands, Models, Photos.

Auto-generate ID as primary key for each entities.

## Brand and Model
1 brand has many models => Foreign key in model: brand_id

## Inventory and Model
Belongs to 1 brand, 1 model => Foreign key to model_id (1 model already belongs to 1 brand)

## Inventories and Photos
Inventories and Photos are one-to-many relationship => Foreign key in Photos (inventory_id), currently choose the first photo uploaded as thumbnail.

## Accounts and Roles
Account can only be 1 role (currently).

Roles may represent for a set of accordance rights (decide later).