/*
 * Вообще нет DISTINCT здесь лишний, так как я не думаю, что надо
 * учитывать уникальных менедежеров
 * так как по сути бывают ситуации, когда менеджера, которого сменили
 * может вернуться 
 * так же я проверил результаты на всякий случай результат такой же 
 * как и без уникальных пользователей 
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