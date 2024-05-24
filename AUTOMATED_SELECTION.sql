-- =============================================================
-- -------------------------------------------------------------
-- --  --  -- QUERIES FOR AUTOMATED SELECTION --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================


--@block --------------------------------------------------------
-- ELIGIBLE CUISINES FOR EPISODE --------------------------------

SELECT cuisine_id FROM national_cuisines
WHERE cuisine_id NOT IN (                   -- not in this episode already
    SELECT cuisine_id FROM assignments
    WHERE episode_id = 1 /* E */ -- python
    )
AND cuisine_id NOT IN (                     -- not in all 3 last episodes
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =3 /* E */ -- python
    INTERSECT
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =2 /* E */ -- python
    INTERSECT
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =1 /* E */ -- python
    );



--@block --------------------------------------------------------
-- ELIGIBLE COOKS FOR CUISINE/EPISODE ---------------------------

SELECT c.cook_id , nc.cuisine_id
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
WHERE nc.cuisine_id = 1 /* X */;  -- python

-- + FOR EPISODE


--@block --------------------------------------------------------
-- ELIGIBLE RECIPES FOR CUISINE/COOK/EPISODE --------------------

SELECT r.recipe_id  , r.cuisine_id, c.cook_id
FROM recipes r
JOIN cooks_recipes cr ON r.recipe_id = cr.recipe_id
JOIN cooks c ON c.cook_id = cr.cook_id
WHERE r.cuisine_id = 1 /* X */ AND c.cook_id = 11 /* Y */;  --  =X

-- + FOR EPISODE

-- INSERT ASSIGNMENT X10 PER EPISODE


--@block --------------------------------------------------------
-- ELIGIBLE JUDGES FOR EPISODE ----------------------------------

SELECT c.cook_id
FROM cooks;

-- + FOR EPISODE

-- INSERT JUDGE X3 PER EPISODE
