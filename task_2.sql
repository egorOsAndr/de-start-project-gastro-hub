/*добавьте сюда запрос для решения задания 2*/
CREATE MATERIALIZED VIEW profit_statistic AS
WITH annual_revenue_avg AS 
(
SELECT
	DISTINCT ON (EXTRACT(YEAR FROM s.date), r.name)
	EXTRACT(YEAR FROM s.date) AS year,
	r.name,
	r.type_rest,
	ROUND(AVG(s.avg_check) OVER(PARTITION BY name ORDER BY EXTRACT(YEAR FROM s.date)), 2) AS avg_check
FROM cafe.sales AS s
	INNER JOIN cafe.restaurants AS r USING(restaurant_uuid)
WHERE EXTRACT(YEAR FROM s.date) != 2023
ORDER BY r.name
)
SELECT
	*,
	ROUND(avg_check_prev_year / avg_check, 2) AS changing_avg_check
FROM
(SELECT
	*,
	LAG(avg_check) OVER(PARTITION BY name ORDER BY year) AS avg_check_prev_year
FROM annual_revenue_avg) AS tb;