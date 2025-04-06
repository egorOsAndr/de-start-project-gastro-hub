BEGIN;

SELECT restaurant_uuid 
FROM cafe.restaurants
WHERE type_rest = 'coffee_shop'
FOR UPDATE
NOWAIT;

UPDATE cafe.restaurants
SET menu = 
	CASE
		WHEN menu #> '{Кофе, Капучино}' IS NULL THEN menu
		ELSE JSONB_SET(menu, '{Кофе, Капучино}', TO_JSONB((menu #>> '{Кофе, Капучино}')::NUMERIC(6, 2) * 1.2))
	END
WHERE type_rest = 'coffee_shop';

COMMIT;
