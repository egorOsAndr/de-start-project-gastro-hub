
INSERT INTO cafe.restaurants (name, type_rest, menu)
SELECT
	DISTINCT ON (m.cafe_name)
	m.cafe_name,
	s.TYPE::cafe.restaurant_type,
	m.menu
FROM raw_data.menu AS m
	INNER JOIN raw_data.sales AS s ON m.cafe_name = s.cafe_name;

INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT ON (manager)
	manager,
	REGEXP_REPLACE(manager_phone, '[^0-9]', '', 'g') AS manager_phone
FROM raw_data.sales;

INSERT INTO cafe.restaurant_manager_work_dates 
(
	restaurant_uuid, 
	manager_uuid,
	date_start,
	date_end
)
SELECT
	rest.restaurant_uuid,
	manag.manager_uuid,
	MIN(s.report_date),
	MAX(s.report_date)
FROM raw_data.sales AS s
	LEFT JOIN cafe.restaurants AS rest ON rest.type_rest = s.TYPE::cafe.restaurant_type
		AND rest.name = s.cafe_name
	LEFT JOIN cafe.managers AS manag ON s.manager = manag.name
		AND REGEXP_REPLACE(s.manager_phone, '[^0-9]', '', 'g') = manag.phone
GROUP BY 
	rest.restaurant_uuid,
	manag.manager_uuid;

INSERT INTO cafe.sales
(
	date,
	restaurant_uuid,
	avg_check
)
SELECT
	s.report_date,
	r.restaurant_uuid,
	s.avg_check
FROM cafe.restaurants AS r
	INNER JOIN raw_data.sales AS s ON r.name = s.cafe_name
		AND r.type_rest = s.type::cafe.restaurant_type;
