
-- =============================================================
-- -------------------------------------------------------------
-- --  --  -- QUERIES FOR AUTOMATED SELECTION --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================


--@block --------------------------------------------------------
-- ELIGIBLE CUISINES FOR EPISODE --------------------------------

-- select all national cuisines
SELECT cuisine_id FROM national_cuisines

-- that are not in this episode already
WHERE cuisine_id NOT IN (
    SELECT cuisine_id FROM assignments
    WHERE episode_id = 1 /* E */ -- python
    )

-- and are not in all 3 last episodes either
AND cuisine_id NOT IN (
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =3 /* E-1 */ -- python
    INTERSECT
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =2 /* E-2 */ -- python
    INTERSECT
    SELECT cuisine_id FROM Assignments
    WHERE episode_id =1 /* E-3 */ -- python
    );

-- PYTHON, SELECT ONE CUISINE OF THE ABOVE RANDIOMLY = NC

--@block --------------------------------------------------------
-- ELIGIBLE COOKS FOR CUISINE/EPISODE ---------------------------

-- select all cooks, from the above chosen national cuisine 
SELECT c.cook_id -- , nc.cuisine_id
FROM cooks c
JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
WHERE nc.cuisine_id = 1 /* NC */;  -- python

-- that are not in this episode already
AND c.cook_id NOT IN (
    SELECT a.cook_id FROM assignments a
    WHERE episode_id = 1 /* E */ -- python
    )

-- and are not in all 3 last episodes either
AND c.cook_id NOT IN (
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =3 /* E-1 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =2 /* E-2 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =1 /* E-3 */ -- python
    );

-- PYTHON, SELECT ONE COOK OF THE ABOVE RANDIOMLY = C


--@block --------------------------------------------------------
-- ELIGIBLE RECIPES FOR CUISINE/COOK/EPISODE --------------------

-- select all recipes, from the above chosen national cuisine, that cook knows
SELECT r.recipe_id  -- , r.cuisine_id, c.cook_id
FROM recipes r
JOIN cooks_recipes cr ON r.recipe_id = cr.recipe_id
JOIN cooks c ON c.cook_id = cr.cook_id
WHERE r.cuisine_id = 1 /* X */ AND c.cook_id = 11 /* Y */;  --  =X

-- that are not in this episode already
AND c.cook_id NOT IN (
    SELECT a.cook_id FROM assignments a
    WHERE episode_id = 1 /* E */ -- python
    )

-- and are not in all 3 last episodes either
AND c.cook_id NOT IN (
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =3 /* E-1 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =2 /* E-2 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =1 /* E-3 */ -- python
    );

-- PYTHON, SELECT ONE COOK OF THE ABOVE RANDIOMLY = C


-- INSERT episode_id, cuisine_id, cook_id, recipe_id in ASSIGNMENT
-- DO THE ABOVE X10 PER EPISODE


--@block --------------------------------------------------------
-- ELIGIBLE JUDGES FOR EPISODE ----------------------------------

SELECT c.cook_id FROM cooks c

-- that are not in this episode already
WHERE cook_id NOT IN (
    SELECT a.cook_id FROM assignments a
    WHERE episode_id = 3 /* E */ -- python
    )

-- and are not in all 3 last episodes either
AND c.cook_id NOT IN (
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =3 /* E-1 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =2 /* E-2 */ -- python
    INTERSECT
    SELECT a.cook_id FROM Assignments a
    WHERE episode_id =1 /* E-3 */ -- python
    );


-- INSERT JUDGE IN ASSIGNMENT WITH assigned_judge = 1
-- DO THE ABOVE X3 PER ASSIGNMENT
