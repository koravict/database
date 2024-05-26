-- QUERIES

-- =============================================================
-- -------------------------------------------------------------
-- --  --  --  -- QUERYS FOR PROJECT  --  --  --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

--@block 3.1 a ==========================================
-- ======================================================
-- 3.1 - avg score per cook

SELECT c.cook_id, c.full_name AS cook,
ROUND(AVG(score),2) AS avg_score 
FROM assignments a
JOIN score s ON s.assignment_id = a.assignment_id
JOIN cooks c ON c.cook_id = a.cook_id
GROUP BY c.cook_id
ORDER BY avg_score DESC;

--@block 3.1 b -----------------------------------------
-- avg score per cuisine

SELECT nc.cuisine_id, nc.name AS national_cuisine,
ROUND(AVG(score),2) AS avg_score 
FROM assignments a
JOIN score s ON s.assignment_id = a.assignment_id
JOIN national_cuisines nc ON nc.cuisine_id = a.cuisine_id
GROUP BY nc.cuisine_id; 


--@block 3.2a ===========================================
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

/*UNION

SELECT c.cook_id, c.full_name AS cook,
nc.name AS national_cuisine, e.episode_year
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
JOIN judge_assignment ja ON ja.judge_id = c.cook_id
JOIN episodes e ON e.episode_id = ja.episode_id
WHERE nc.cuisine_id = 1 and e.episode_year = 2025
GROUP BY cook_id;
*/

--@block 3.3 ============================================
-- ======================================================
-- 3.3 - young cooks with more recipes

SELECT
COUNT (owner_id) AS num_of_recipes, c.full_name, c.age
FROM cooks c
JOIN recipes r ON r.owner_id = c.cook_id
WHERE c.age < 30
GROUP BY cook_id
ORDER BY num_of_recipes DESC;


--@block 3.4 ============================================
-- ======================================================
-- 3.4 - cooks that have never been judges

SELECT cook_id, full_name FROM cooks
WHERE cook_id NOT IN (
    SELECT judge_id FROM judge_assignment
);


--@block 3.5 ============================================
-- ======================================================
-- 3.5 - appearances of judges

WITH jjapp AS (

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id -- , e.episode_year
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year =2025
    GROUP BY cook_id
    HAVING appearances > 3

    UNION

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2026
    GROUP BY cook_id
    HAVING appearances > 3

    UNION

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2027
    GROUP BY cook_id
    HAVING appearances > 3

    UNION

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2028
    GROUP BY cook_id
    HAVING appearances > 3

    UNION

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2029
    GROUP BY cook_id
    HAVING appearances > 3

    UNION

    SELECT COUNT (cook_id) AS appearances, full_name, cook_id
    FROM cooks c
    JOIN judge_assignment ja ON c.cook_id = ja.judge_id
    JOIN episodes e ON e.episode_id = ja.episode_id
    WHERE e.episode_year = 2030
    GROUP BY cook_id
    HAVING appearances > 3
)

SELECT DISTINCT t1.appearances AS apps,
t1.full_name AS judge1, t2.full_name AS judge2,
t1.cook_id AS id1, t2.cook_id AS id2
FROM jjapp t1
JOIN jjapp t2 ON t1.cook_id < t2.cook_id
WHERE t1.appearances = t2.appearances
ORDER BY t1.appearances;


--@block 3.6a ============================================
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
    CONCAT(t1.tag_id,' | ', t2.tag_id) AS tag_pair,
    CONCAT(t1.tag,' | ', t2.tag) AS pair_names
    -- rapps.recipe_apps,
FROM tt t1 
JOIN tt t2 ON t1.recipe_id = t2.recipe_id
JOIN rapps ON rapps.recipe_id = t1.recipe_id 
WHERE t1.tag_id < t2.tag_id
GROUP BY tag_pair, pair_names
ORDER BY tag_pair_apps DESC LIMIT 3;

--@block 3.6b ============================================
-- ======================================================
-- 3.6b - top 3 tag pairs with force index
EXPLAIN
WITH tt AS (
    SELECT r.recipe_id, t.tag_id, t.name AS tag
    FROM tags t
    JOIN tags_recipes tr FORCE INDEX (idx_tag) ON t.tag_id = tr.tag_id
    JOIN recipes r FORCE INDEX (idx_recipe_id) ON r.recipe_id = tr.recipe_id
),
rapps AS (
    SELECT r.recipe_id,
    COUNT(a.recipe_id) AS recipe_apps
    FROM recipes r
    JOIN assignments a FORCE INDEX (idx_ass_recipe_id) ON a.recipe_id = r.recipe_id
    GROUP BY r.recipe_id
)
SELECT 
    CONCAT(t1.tag_id, ' | ', t2.tag_id) AS tag_pair,
    CONCAT(t1.tag, ' | ', t2.tag) AS pair_names,
    SUM(rapps.recipe_apps) AS tag_pair_apps
FROM tt t1 
JOIN tt t2 ON t1.recipe_id = t2.recipe_id AND t1.tag_id < t2.tag_id
JOIN rapps ON rapps.recipe_id = t1.recipe_id 
GROUP BY tag_pair, pair_names
ORDER BY tag_pair_apps DESC
LIMIT 3;


--@block 3.7 ============================================
-- ======================================================
-- 3.7 - cooks with apps <= max(apps)-5

WITH capps AS (
    SELECT c.cook_id, c.full_name, COUNT (c.cook_id) AS cook_apps
    FROM cooks c
    JOIN assignments a ON a.cook_id = c.cook_id
    GROUP BY c.cook_id
   -- ORDER BY cook_apps DESC
)

SELECT * FROM capps
WHERE cook_apps <= (SELECT MAX(cook_apps) FROM capps) - 5
ORDER BY cook_apps DESC;

--@block 3.8a ============================================
-- ======================================================
-- 3.8 - which episode used the most equipment

SELECT e.episode_id, e.episode_year, e.episode_number,
COUNT(er.equipment_id) AS equipment_count
FROM episodes e

JOIN assignments a ON a.episode_id = e.episode_id
JOIN recipes r ON r.recipe_id = a.recipe_id
JOIN equipment_recipes er ON er.recipe_id = r.recipe_id

GROUP BY e.episode_id, e.episode_year, e.episode_number
ORDER BY equipment_count DESC;

--@block 3.8b ============================================
-- ======================================================
-- 3.8b - which episode used the most equipment with force index
EXPLAIN SELECT e.episode_id, e.episode_year, e.episode_number,
       COUNT(er.equipment_id) AS equipment_count
FROM episodes e
JOIN assignments a FORCE INDEX (idx_ass_episode) ON a.episode_id = e.episode_id
JOIN recipes r FORCE INDEX (idx_recipe_id) ON r.recipe_id = a.recipe_id
GROUP BY e.episode_id, e.episode_year, e.episode_number
ORDER BY equipment_count DESC;

--@block 3.9 ============================================
-- ======================================================
-- 3.9 - list with mean number of grams of carbs by year

SELECT e.episode_year, ROUND(AVG(r.carbs_per_s*r.servings),2) AS avg_carbs_per_year
FROM episodes e

JOIN assignments a ON a.episode_id = e.episode_id
JOIN recipes r ON a.recipe_id = r.recipe_id

GROUP BY e.episode_year
ORDER BY episode_year;



--@block 3.10 ===========================================
-- ======================================================
-- 3.10 - appearances of cuisines

WITH ncapp AS (

    SELECT (apps1 + apps2) AS appearances, cuisine1 AS cuisine, id1 AS id
    FROM (
        SELECT COUNT (nc.cuisine_id) AS apps1, nc.name AS cuisine1, nc.cuisine_id AS id1
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2025
        GROUP BY nc.cuisine_id
        HAVING apps1 > 3 ) AS t1
    JOIN (
        SELECT COUNT (nc.cuisine_id) AS apps2, nc.name AS cuisine2, nc.cuisine_id AS id2
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2026
        GROUP BY nc.cuisine_id
        HAVING apps2 > 3 ) AS t2
    ON id1 = id2

    UNION -- ---------------------------------------------------------

    SELECT (apps1 + apps2) AS appearances, cuisine1 AS cuisine, id1 AS id
    FROM (
        SELECT COUNT (nc.cuisine_id) AS apps1, nc.name AS cuisine1, nc.cuisine_id AS id1
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2026
        GROUP BY nc.cuisine_id
        HAVING apps1 > 3 ) AS t1
    JOIN (
        SELECT COUNT (nc.cuisine_id) AS apps2, nc.name AS cuisine2, nc.cuisine_id AS id2
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2027
        GROUP BY nc.cuisine_id
        HAVING apps2 > 3 ) AS t2
    ON id1 = id2

    UNION -- ---------------------------------------------------------

    SELECT (apps1 + apps2) AS appearances, cuisine1 AS cuisine, id1 AS id
    FROM (
        SELECT COUNT (nc.cuisine_id) AS apps1, nc.name AS cuisine1, nc.cuisine_id AS id1
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2027
        GROUP BY nc.cuisine_id
        HAVING apps1 > 3 ) AS t1
    JOIN (
        SELECT COUNT (nc.cuisine_id) AS apps2, nc.name AS cuisine2, nc.cuisine_id AS id2
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2028
        GROUP BY nc.cuisine_id
        HAVING apps2 > 3 ) AS t2
    ON id1 = id2

    UNION -- ---------------------------------------------------------

    SELECT (apps1 + apps2) AS appearances, cuisine1 AS cuisine, id1 AS id
    FROM (
        SELECT COUNT (nc.cuisine_id) AS apps1, nc.name AS cuisine1, nc.cuisine_id AS id1
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2028
        GROUP BY nc.cuisine_id
        HAVING apps1 > 3 ) AS t1
    JOIN (
        SELECT COUNT (nc.cuisine_id) AS apps2, nc.name AS cuisine2, nc.cuisine_id AS id2
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2029
        GROUP BY nc.cuisine_id
        HAVING apps2 > 3 ) AS t2
    ON id1 = id2

    UNION -- ---------------------------------------------------------

    SELECT (apps1 + apps2) AS appearances, cuisine1 AS cuisine, id1 AS id
    FROM (
        SELECT COUNT (nc.cuisine_id) AS apps1, nc.name AS cuisine1, nc.cuisine_id AS id1
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2029
        GROUP BY nc.cuisine_id
        HAVING apps1 > 3 ) AS t1
    JOIN (
        SELECT COUNT (nc.cuisine_id) AS apps2, nc.name AS cuisine2, nc.cuisine_id AS id2
        FROM national_cuisines nc
        JOIN assignments a ON nc.cuisine_id = a.cuisine_id
        JOIN episodes e ON e.episode_id = a.episode_id
        WHERE e.episode_year = 2030
        GROUP BY nc.cuisine_id
        HAVING apps2 > 3 ) AS t2
    ON id1 = id2
)

SELECT DISTINCT t1.appearances AS apps, 
t1.cuisine AS cuisine1, t2.cuisine AS cuisine2,
t1.id AS id1, t2.id AS id2
FROM ncapp t1
JOIN ncapp t2 ON t1.id < t2.id
WHERE t1.appearances = t2.appearances
ORDER BY t1.appearances;

--@block 3.11 ===========================================
-- ======================================================
-- 3.11 - top 5 score givers to cook

WITH aa AS (
    SELECT j.full_name AS judge, s.score, c.full_name AS cook,
    CONCAT (j.full_name, ' | ', c.full_name) AS jc
    FROM assignments a
    JOIN score s ON s.assignment_id = a.assignment_id
    JOIN cooks c ON c.cook_id = a.cook_id
    JOIN cooks j ON j.cook_id = s.judge_id
)

SELECT judge, SUM(score) AS total_score_to, cook
FROM aa
GROUP BY jc, judge, cook
ORDER BY total_score_to DESC LIMIT 5;


--@block 3.12 ===========================================
-- ======================================================
-- 3.12 - most technical episode per year

WITH ad AS (
    SELECT
    e.episode_id AS id,
    e.episode_year AS year,
    e.episode_number AS episode, 
    ROUND(AVG(difficulty),1) AS difficulty

    FROM recipes r
    JOIN assignments a ON a.recipe_id = r.recipe_id
    JOIN episodes e ON e.episode_id = a.episode_id
    GROUP BY e.episode_id, e.episode_year
),

r_ep AS (
    SELECT year, episode, difficulty,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY difficulty DESC) AS ordinal
    FROM ad
)

SELECT year, episode AS most_technical_ep, difficulty AS avg_difficulty
FROM r_ep
WHERE ordinal = 1;

--@block 3.13 ===========================================
-- ======================================================
-- 3.13 - which episode had the lowest level of chefs and judges

DROP TABLE IF EXISTS levels;

CREATE TEMPORARY TABLE levels (
    level VARCHAR(50),
    l_value INT
);

INSERT INTO levels (level, l_value) VALUES
    ('αρχιμάγειρας (σεφ)', 5),
    ('βοηθός αρχιμάγειρα', 4),
    ('A΄ μάγειρας', 3),
    ('Β΄ μάγειρας', 2),
    ('Γ΄ μάγειρας', 1);

WITH aa AS (
    SELECT e.episode_id, a.cook_id
    FROM episodes e
    JOIN assignments a ON a.episode_id = e.episode_id

    UNION

    SELECT e.episode_id, ja.judge_id
    FROM episodes e
    JOIN judge_assignment ja ON ja.episode_id = e.episode_id
)

SELECT aa.episode_id, -- aa.cook_id, l.l_value,
ROUND(AVG (l_value),2) AS avg_lvl
FROM aa
JOIN cooks c ON c.cook_id = aa.cook_id
JOIN levels l ON l.level = c.level
GROUP BY aa.episode_id
ORDER BY avg_lvl LIMIT 1;

DROP TABLE levels;

--@block 3.14 ===========================================
-- ======================================================
-- 3.14 - which thematic unit has the most appearances in the comp

SELECT tu.name AS unit_name, COUNT(*) AS appearances
FROM thematic_units tu

JOIN units_recipes ur ON tu.unit_id = ur.unit_id
JOIN recipes r ON ur.recipe_id = r.recipe_id 
JOIN assignments a ON r.recipe_id = a.recipe_id
JOIN episodes e ON a.episode_id = e.episode_id

GROUP BY tu.name 
ORDER BY appearances DESC;


--@block 3.15 ===========================================
-- ======================================================
-- 3.15 - find which food groups have never appeared in an episode

SELECT fg.group_id, fg.name
FROM food_groups fg
LEFT JOIN recipes r ON fg.group_id = r.group_id
LEFT JOIN Assignments a ON r.recipe_id = a.recipe_id 
WHERE a.recipe_id IS NULL
GROUP BY fg.group_id, fg.name;
