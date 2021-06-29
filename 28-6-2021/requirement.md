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
-> Memory unit
- Manufacturing year (Number)
- OS version (String)
- Color (String)
- Price (Number) (unit VND..)
-> Price unit

Optional:
- Percent (how many percent new of the used-phone)
- Pictures: picture paths?
- Thumbnail (choose 1 from a list of Pictures to show in scroll-list view)
- ...
