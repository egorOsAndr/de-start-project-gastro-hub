CREATE SCHEMA cafe;

CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

DROP TABLE IF EXISTS cafe.restaurants CASCADE;
CREATE TABLE IF NOT EXISTS cafe.restaurants 
(
	restaurant_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	name CHARACTER VARYING NOT NULL, -- Varchar так как я не видел супер больших названий кафе и ресторанов
	type_rest cafe.restaurant_type NOT NULL,
	menu JSONB NOT NULL -- JSONB так как надо будет часто обращаться посмотреть, что осталось
);

DROP TABLE IF EXISTS cafe.managers CASCADE;
CREATE TABLE IF NOT EXISTS cafe.managers 
(
	manager_uuid UUID PRIMARY KEY DEFAULT GEN_RANDOM_UUID(),
	name VARCHAR NOT NULL UNIQUE,
	phone VARCHAR NOT NULL UNIQUE
);

DROP TABLE IF EXISTS cafe.restaurant_manager_work_dates CASCADE;
CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates 
(
	restaurant_uuid UUID REFERENCES cafe.restaurants ON DELETE CASCADE,
	manager_uuid UUID REFERENCES cafe.managers ON DELETE CASCADE,
	date_start DATE NOT NULL,
	date_end DATE CHECK (date_start <= date_end),
	PRIMARY KEY (restaurant_uuid, manager_uuid)
);

DROP TABLE IF EXISTS cafe.sales CASCADE;
CREATE TABLE IF NOT EXISTS cafe.sales 
(
	date DATE NOT NULL,
	restaurant_uuid UUID REFERENCES cafe.restaurants ON DELETE CASCADE,
	avg_check NUMERIC(6, 2) NOT NULL CHECK(avg_check > -1),
	PRIMARY KEY (date, restaurant_uuid)
);
