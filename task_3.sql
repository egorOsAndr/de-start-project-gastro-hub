/*добавьте сюда запрос для решения задания 3*/
/*
 * Я понимаю, что тут нужно топ 3 мест, где чаще менялись менеджеры,
 * но записей с максимальным количеством менеджерей равно 8 и
 * выводить рандомные три записи из этих я считаю не особо правильным
 * поэтому сделал так
 * */
WITH count_manager AS 
(
SELECT
	r.name,
	COUNT(rmwd.manager_uuid) AS count_manager
FROM cafe.restaurants AS r
	LEFT JOIN cafe.restaurant_manager_work_dates AS rmwd USING(restaurant_uuid)
GROUP BY r.name
ORDER BY count_manager DESC
)
SELECT
	name,
	count_manager
FROM
(
	SELECT
		*,
		DENSE_RANK() OVER(ORDER BY count_manager DESC) AS dr
	FROM count_manager
) AS tb
WHERE dr = 1;