WITH info AS 
(
SELECT 
	name,
	'Пицца' AS type_dish,
	SPLIT_PART(TRIM(JSONB_EACH(menu -> 'Пицца')::VARCHAR, '()'), ',', 1) AS pizza_name,
	SPLIT_PART(TRIM(JSONB_EACH(menu -> 'Пицца')::VARCHAR, '()'), ',', 2)::INT2 AS pizza_price
FROM cafe.restaurants
WHERE type_rest = 'pizzeria'::cafe.restaurant_type
)
SELECT
	name,
	type_dish,
	pizza_name,
	pizza_price
FROM
(SELECT
	name,
	type_dish,
	pizza_name,
	pizza_price,
	DENSE_RANK() OVER(PARTITION BY name ORDER BY pizza_price DESC) AS dr
FROM info) AS tb
WHERE dr = 1;