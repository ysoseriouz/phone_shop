# phone_shop
### Run local
- Start docker
```
docker compose up
```
- Install dependencies
```
bundle install
```
- Initialize MS SQL server (run once when create new database)
```
rails db:create
rails db:migrate
rails db:seed # To seed fake data
```
- Start server
```
rails s
```
Run at `localhost:3000`
