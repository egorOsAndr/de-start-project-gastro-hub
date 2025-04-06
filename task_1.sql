/*добавьте сюда запрос для решения задания 1*/
CREATE VIEW top_rest AS
WITH rest_top_check AS (
SELECT
	r.name,
	r.type_rest,
	ROUND(MAX(s.avg_check), 2) AS avg_check
FROM cafe.restaurants AS r
	INNER JOIN cafe.sales AS s USING(restaurant_uuid)
GROUP BY 
	r.name,
	r.type_rest
ORDER BY r.type_rest, avg_check DESC
)
SELECT
	name,
	type_rest,
	avg_check
FROM
(SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY type_rest ORDER BY avg_check DESC) AS rn
FROM rest_top_check) AS tb
WHERE rn < 4;
