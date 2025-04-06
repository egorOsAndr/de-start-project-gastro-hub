BEGIN;
LOCK TABLE cafe.managers IN EXCLUSIVE MODE;
ALTER TABLE cafe.managers
ADD COLUMN phones VARCHAR[2];
WITH numbers AS
(
	SELECT
	phone,
	'8-800-2500-' || (ROW_NUMBER() OVER (ORDER BY name) + 100)::VARCHAR AS ph
	FROM cafe.managers
)
UPDATE cafe.managers AS m
SET phones = ARRAY[n.ph, n.phone]
FROM numbers AS n
WHERE n.phone = m.phone;
ALTER TABLE cafe.managers DROP COLUMN phone;
COMMIT;