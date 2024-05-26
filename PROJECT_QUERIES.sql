-- QUERIES

-- =============================================================
-- -------------------------------------------------------------
-- --  --  --  -- QUERYS FOR PROJECT  --  --  --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

--@block ================================================
-- ======================================================
-- 3.1 - avg score per cook

SELECT c.cook_id, c.full_name AS cook,
ROUND(AVG(score),2) AS avg_score 
FROM assignments a
JOIN score s ON s.assignment_id = a.assignment_id
JOIN cooks c ON c.cook_id = a.assignment_id
GROUP BY c.cook_id; 

--@block 3.1 b -----------------------------------------
-- avg score per cuisine

SELECT nc.cuisine_id, nc.name AS national_cuisine,
ROUND(AVG(score),2) AS avg_score 
FROM assignments a
JOIN score s ON s.assignment_id = a.assignment_id
JOIN national_cuisines nc ON nc.cuisine_id = a.cuisine_id
GROUP BY nc.cuisine_id; 


--@block ================================================
-- ======================================================
-- 3.2 - cooks that specialize in Palestinian Cuisine

SELECT c.cook_id, c.full_name AS cook,
nc.name AS national_cuisine, nc.cuisine_id
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
WHERE nc.cuisine_id = 1;

--@block 3.2 b -----------------------------------------
-- out of them, the following participated in episodes in 2025

SELECT c.cook_id, c.full_name AS cook,
nc.name AS national_cuisine, e.episode_year
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
JOIN assignments a ON a.cook_id = c.cook_id
JOIN episodes e ON e.episode_id = a.episode_id
WHERE nc.cuisine_id = 1 and e.episode_year = 2025
GROUP BY cook_id

UNION

SELECT c.cook_id, c.full_name AS cook,
nc.name AS national_cuisine, e.episode_year
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
JOIN judge_assignment ja ON ja.judge_id = c.cook_id
JOIN episodes e ON e.episode_id = ja.episode_id
WHERE nc.cuisine_id = 1 and e.episode_year = 2025
GROUP BY cook_id;


--@block ================================================
-- ======================================================
-- 3.3 - young cooks with more recipes

SELECT
COUNT (owner_id) AS num_of_recipes, c.full_name, c.age
FROM cooks c
JOIN recipes r ON r.owner_id = c.cook_id
WHERE c.age < 30
GROUP BY cook_id
ORDER BY num_of_recipes DESC;


--@block ================================================
-- ======================================================
-- 3.4 - cooks that have never been judges

SELECT cook_id, full_name FROM cooks
WHERE cook_id NOT IN (
    SELECT judge_id FROM judge_assignment
);

--@block ================================================
-- ======================================================
-- 3.5 - appearances of judges

WITH jjapp AS (
    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2025
    GROUP BY cook_id
    HAVING appearances > 3
    ORDER BY appearances DESC
)

SELECT DISTINCT t1.appearances AS jj1_apps, t1.cook_id AS judge1, 
t2.cook_id AS judge2, t2.appearances AS jj2_apps
FROM jjapp t1 JOIN jjapp t2 ON t1.cook_id < t2.cook_id;
WHERE t1.appearances = t2.appearances;


--@block ================================================
-- ======================================================
-- 3.6 - top 3 tag pairs 

WITH tt AS (
    SELECT r.recipe_id, t.tag_id, t.name AS tag
    FROM tags t
    JOIN tags_recipes tr ON t.tag_id = tr.tag_id
    JOIN recipes r ON r.recipe_id = tr.recipe_id
),

rapps AS (
    SELECT r.recipe_id,
    COUNT (r.recipe_id) AS recipe_apps
    FROM recipes r
    JOIN assignments a ON a.recipe_id = r.recipe_id
    GROUP BY r.recipe_id
)

SELECT DISTINCT 
    -- t1.recipe_id AS recipe,
    SUM (recipe_apps) AS tag_pair_apps,
    CONCAT(t1.tag_id,' | ', t2.tag_id) AS tag_pair
    -- rapps.recipe_apps,
FROM tt t1 
JOIN tt t2 ON t1.recipe_id = t2.recipe_id
JOIN rapps ON rapps.recipe_id = t1.recipe_id 
WHERE t1.tag_id < t2.tag_id
GROUP BY tag_pair
ORDER BY tag_pair_apps DESC LIMIT 3;
