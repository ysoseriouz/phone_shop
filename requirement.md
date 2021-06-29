# phone_shop
Intern project (1st month)

## Features
View a list of all phones.
Add a new inventory with required properties.
Remove a phone.
Update/change information of an existing phone.

Add pictures of the phone. Manager may want to add some pictures.
Search for phones based on query text/properties.

=> Main views:
- A form to input phone information (require properties + optional info..) and submit to register new inventory.
- A scroll list of all phones (show summarized/short information).
- From scroll-list view: click to a cell -> go to detail page (show full information, pictures..)

## Properties info and design notes
- Brand (Apple, Samsung..) (String): type arbitrary brand name or choose from a pre-defined list?.
- Model (iPhone X, Samsung Note 1000..) (String)
- Memory size (Number): only allowed number + choose unit from a list (MB, GB, TB..)?.
- Memory unit
- Manufacturing year (Number)
- OS version (String)
- Color (String)
- Price (Number) (unit VND..)
- Price unit

Optional:
- Source (phone used to belong to whom..)
- Percent (how many percent new of the used-phone)
- Pictures: picture paths?
- Thumbnail (choose 1 from a list of Pictures to show in scroll-list view)
- ...

## User story
1. User at main page: viewing a list of phones in storage ('inventory_list_1' or 'inventory_list_2').
    - At the top of the page, there's a search/filter box, a combination of queried properties is used to match inventories -> only view matched phones.
    - User clicks button 'Add'/'Add inventory' to register new inventory -> no. 2
    - User clicks icon 'Edit' -> go to 'edit_inventory' -> no. 3
    - User clicks icon 'Delete' -> the row/phone will be delete from inventory list (but keep it on DB maybe later need..)
2. At 'add_inventory' page
    - User inputs a bunch of information required
    - Click 'Cancel' or 'X' button at the top left to cancel action -> back to main page with nothing change -> no. 1
    - Click 'Save' to complete registration -> reload/redirect to page 'edit_inventory' -> no. 3
3. At 'edit_inventory', user can view details about inventory and edit any fields except the auto-generated ID.