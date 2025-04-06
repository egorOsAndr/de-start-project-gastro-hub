WITH pizze_rest AS 
(
SELECT 
	name,
	COUNT(pizza) AS count_pizze
FROM
(SELECT
	name,
	JSONB_OBJECT_KEYS(menu -> 'Пицца') AS pizza
FROM cafe.restaurants
WHERE type_rest = 'pizzeria'::cafe.restaurant_type) AS tb
GROUP BY name
)
SELECT
	name,
	count_pizze
FROM
(SELECT
	name,
	count_pizze,
	DENSE_RANK() OVER(ORDER BY count_pizze DESC) r
FROM pizze_rest) AS tb
WHERE r = 1;