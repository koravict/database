SELECT c.cook_id, c.full_name AS full_name, GROUP_CONCAT(ci.name) AS specialized_cuisines
FROM cooks c
JOIN cuisines_cooks s ON c.cook_id = s.cook_id
JOIN national_cuisines ci ON s.cuisine_id = ci.cuisine_id
GROUP BY c.cook_id, c.full_name;

-- INSERT 2-3 RECIPES PER CUISINE A COOK SPECIALIZES IN , IN COOKS_RECIPES --
-- --------------------------------------------------------------------------
INSERT INTO cooks_recipes (cook_id, recipe_id)
SELECT nc.cook_id, r.recipe_id
FROM (
    -- SELECT EACH COOKS SPECIALIZATION AND A RANDOM RECIPE FROM EACH ONE --
    SELECT cc.cook_id, r.cuisine_id, r.recipe_id,
           ROW_NUMBER() OVER (PARTITION BY cc.cook_id, r.cuisine_id ORDER BY RAND()) AS rn
    FROM cuisines_cooks cc
    JOIN recipes r ON cc.cuisine_id = r.cuisine_id
) AS nc
JOIN recipes r ON nc.recipe_id = r.recipe_id
WHERE nc.rn <= FLOOR(2 + RAND() * 2) -- RANDOMLY SELECT 2-3 RECIPES --
ORDER BY nc.cook_id, nc.cuisine_id, nc.rn;
