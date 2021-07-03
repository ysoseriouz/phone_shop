# phone_shop

Intern project (1st month)

## Features

View a list of all phones.
Add a new inventory with required properties.
Remove a phone.
Update/change information of an existing phone.

View deleted inventories and able to restore them anytime.
Search/filter inventories based on queried fields.

=> Main views:

- A form to input phone information (require properties + optional info..) and submit to register new inventory.
- A scroll list of all phones (show summarized/short information).
- From scroll-list view: click to a cell -> go to detail page (show full information, pictures..) and able to Edit.

## Properties info and design notes

- Brand (Apple, Samsung..) (String): type arbitrary brand name or choose from a pre-defined list?.
- Model (iPhone X, Samsung Note 1000..) (String)
- Memory size (Number): ie. 256, unit GB
- Manufacturing year (Number)
- OS version (String)
- Color (String)
- Price (Number) (price for sale - VND)

Optional:

- Stock, sell, reserve amount: Stock = sell + reserve (sell: product shows out for sale, reserve: product kept in storage)
- Status (current status of inventory: active, inactive, sold-out, out-of-stock)
- Original Price (price when phone is bought from the owner)
- Source (phone used to belong to whom..)
- Description note about product
- Thumbnail (upload 1 photo for thumbnail view)
- Many photos may be inplemented if possible..
- ...

## User story

0. User sign-in, sign-up (username & password) -> go to main page with navigation bar (option: 'Inventory', 'Brand Management', 'Logout').
1. User at main page 'inventory_list': viewing a list of phones in storage.
   - At the top of the page, there's a search/filter box, a combination of queried properties is used to match inventories -> only view matched phones ('Deleted' checkbox will include deleted inventories in result list).
   - User clicks button 'Add' to register new inventory -> no. 2
   - User clicks icon 'Edit' -> go to 'edit_inventory' -> no. 3
   - User clicks icon 'Delete' -> the row/phone will be delete from inventory list (but keep it on DB maybe later need..)
   - User clicks 'Brand Management' tab on navigation bar -> go to 'brand_management' -> no. 4
2. At 'add_inventory' page
   - User inputs a bunch of information required
   - Click 'Cancel' or 'X' button at the top left to cancel action -> back to main page with nothing change -> no. 1
   - Click 'Save' to complete registration -> reload/redirect to page 'edit_inventory' -> no. 3
3. At 'edit_inventory', user can view details about inventory and edit any fields except the auto-generated ID.

## Design note

In filter box:

- Drop list of price: < 10tr, 10->15tr, 15->20tr, 20->30tr, > 30tr. Or custom 'from - to'.
- Drop list of memory size: <16GB, 16GB -> 64GB, 64GB->256GB, > 256GB. Or custom 'from - to' with fix 'GB' unit.
- Manufactoring year: 'from - to' (default 'to': 2021)
- Status:
  - Active: currently have in stock and able to sell
  - Inactive: soft delete, reserve in stock
  - Sold out: no more product to sell, only reserved products in stock (stock = N, sell = 0, reserve = N)
  - Out-of-stock: no more product in stock (stock = 0, sell = 0, reserve = 0)

When user 'add new inventory', user choose 'brand' and 'model' in drop list, if new brand or new model -> user can choose 'other' and type new brand or model inside -> update DB new brand and model corresponding to the brand.