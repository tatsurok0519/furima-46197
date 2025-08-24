
### users テーブル

| Column             | Type       | Options                      |
| :----------------- | :--------- | :--------------------------- |
| nickname           | string     | null: false                  |
| email              | string     | null: false, unique: true    |
| encrypted_password | string     | null: false                  |
| last_name          | string     | null: false                  |
| first_name         | string     | null: false                  |
| last_name_kana     | string     | null: false                  |
| first_name_kana    | string     | null: false                  |
| birth_date         | date       | null: false                  |
| created_at         | datetime   | null: false                  |
| updated_at         | datetime   | null: false                  |

### items テーブル

| Column            | Type       | Options                           |
| :---------------- | :--------- | :-------------------------------- |
| name              | string     | null: false                       |
| description       | text       | null: false                       |
| price             | integer    | null: false                       |
| user              | references | null: false, foreign_key: true    |
| category_id       | integer    | null: false                       |
| condition_id      | integer    | null: false                       |
| postage_id        | integer    | null: false                       |
| prefecture_id     | integer    | null: false                       |
| shipping_day_id   | integer    | null: false                       |
| created_at        | datetime   | null: false                       |
| updated_at        | datetime   | null: false                       |

### orders テーブル

| Column     | Type       | Options                           |
| :--------- | :--------- | :-------------------------------- |
| user       | references | null: false, foreign_key: true    |
| item       | references | null: false, foreign_key: true    |
| created_at | datetime   | null: false                       |
| updated_at | datetime   | null: false                       |

### addresses テーブル

| Column        | Type       | Options                           |
| :------------ | :--------- | :-------------------------------- |
| order         | references | null: false, foreign_key: true    |
| postal_code   | string     | null: false                       |
| prefecture_id | integer    | null: false                       |
| city          | string     | null: false                       |
| house_number  | string     | null: false                       |
| building_name | string     |                                   |
| phone_number  | string     | null: false                       |
| created_at    | datetime   | null: false                       |
| updated_at    | datetime   | null: false                       |


### Association

- **User**
  - `has_many :items`
  - `has_many :orders`
- **Item**
  - `belongs_to :user`
  - `has_one :order`
- **Order**
  - `belongs_to :user`
  - `belongs_to :item`
  - `has_one :address`
- **Address**
  - `belongs_to :order`
