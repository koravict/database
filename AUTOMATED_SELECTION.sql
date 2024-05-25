
-- -----------------------------------------------------------------
-- --  --  --  --  -- PROCEDURES  --  --  --  --  --  --  --  --  -- 
-- -----------------------------------------------------------------

-- ===========================================================================
-- ===========================================================================
-- cuisine / cook / recipe procedure -----------------------------------------

DROP PROCEDURE IF EXISTS Select_Cuisine;

CREATE PROCEDURE Select_Cuisine(IN ep INT, IN nc INT, IN ck INT, IN re INT) BEGIN

-- into nc we'll store the id of cuisine selected
-- select all national cuisines
SET nc = (SELECT cuisine_id FROM national_cuisines

    -- that are not in this episode already
    WHERE cuisine_id NOT IN (
        SELECT cuisine_id FROM assignments
        WHERE episode_id = ep
        )

    -- and are not in all 3 last episodes either
    AND cuisine_id NOT IN (
        SELECT cuisine_id FROM Assignments
        WHERE episode_id = ep-1
        INTERSECT
        SELECT cuisine_id FROM Assignments
        WHERE episode_id = ep-2
        INTERSECT
        SELECT cuisine_id FROM Assignments
        WHERE episode_id = ep-3
        )

    -- from all the eligible cuisines, choose 1 randomly
    ORDER BY RAND() LIMIT 1
    );

    -- SELECT nc;
    CALL Select_Cook(ep, nc, ck, re);
END;


-- --------------------------------------------------------------
-- ELIGIBLE COOKS FOR CUISINE/EPISODE ---------------------------

DROP PROCEDURE IF EXISTS Select_Cook;

CREATE PROCEDURE Select_Cook(IN ep INT, IN nc INT, IN ck INT, IN re INT) BEGIN

-- into ck we'll store the id of cook selected
-- select all cooks, from the above chosen national cuisine 
SET ck = (SELECT c.cook_id
    FROM cooks c
    JOIN cuisines_cooks cc ON c.cook_id = cc.cook_id
    JOIN national_cuisines nc ON nc.cuisine_id = cc.cuisine_id
    WHERE nc.cuisine_id = nc

    -- that are not in this episode already
    AND c.cook_id NOT IN (
        SELECT a.cook_id FROM assignments a
        WHERE episode_id = ep
        )

    -- and are not in all 3 last episodes either
    AND c.cook_id NOT IN (
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-1
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-2
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-3
        )

    -- from all the eligible cooks, choose 1 randomly
    ORDER BY RAND() LIMIT 1
    );

    -- SELECT ck;
    CALL Select_Recipe(ep, nc, ck, re);
END;


-- --------------------------------------------------------------
-- ELIGIBLE RECIPES FOR CUISINE/COOK/EPISODE --------------------

DROP PROCEDURE IF EXISTS Select_Recipe;

CREATE PROCEDURE Select_Recipe(IN ep INT, IN nc INT, IN ck INT, IN re INT) BEGIN

-- into ck we'll store the id of cook selected
-- select all recipes, from the above chosen national cuisine, that cook knows
SET re = (SELECT r.recipe_id  -- , r.cuisine_id, c.cook_id
    FROM recipes r
    JOIN cooks_recipes cr ON r.recipe_id = cr.recipe_id
    JOIN cooks c ON c.cook_id = cr.cook_id
    WHERE r.cuisine_id = nc AND c.cook_id = ck

    -- that are not in this episode already
    AND c.cook_id NOT IN (
        SELECT a.cook_id FROM assignments a
        WHERE episode_id = ep
        )

    -- and are not in all 3 last episodes either
    AND c.cook_id NOT IN (
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-1
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-2
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-3
    )

    -- from all the eligible cooks, choose 1 randomly
    ORDER BY RAND() LIMIT 1
    );

    -- SELECT ep, nc, ck, re;
    
    INSERT INTO assignments (episode_id, cuisine_id, cook_id, recipe_id)
    values (ep, nc, ck, re);

END;

-- DO THE ABOVE X10 PER EPISODE

-- ===========================================================================
-- ===========================================================================
-- judges procedure ----------------------------------------------------------
DROP PROCEDURE IF EXISTS Select_Judge;

CREATE PROCEDURE Select_Judge(IN ep INT, IN jj INT) BEGIN

DECLARE i INT DEFAULT 9;
DECLARE ass_id INT DEFAULT 0;

-- into jj we'll store the id of judge-cook selected
-- select all cooks
SET jj = (SELECT c.cook_id FROM cooks c

    -- that are not in this episode already
    WHERE cook_id NOT IN (
        SELECT a.cook_id FROM assignments a
        WHERE episode_id = ep
        )

    -- and are not in all 3 last episodes either
    AND c.cook_id NOT IN (
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-1
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-2
        INTERSECT
        SELECT a.cook_id FROM Assignments a
        WHERE episode_id = ep-3
        )

    -- from all the eligible judges-cooks, choose 1 randomly
    ORDER BY RAND() LIMIT 1
    );

    -- SELECT ep, jj;
    
    INSERT INTO Judge_Assignment (episode_id, judge_id)
    values (ep, jj);
-- ----------------------------------------------------
-- fill scores

SET ass_id = (
    SELECT assignment_id FROM assignments
    ORDER BY assignment_id DESC LIMIT 1
);


WHILE i >= 0 DO
    -- select 10 score for last 10 assignments  
    INSERT INTO Score (assignment_id, judge_id, score)
    values ( ass_id-i, jj, FLOOR(1 + (RAND() * 5))); 
    SET i = i - 1;
END WHILE;


END;


-- ===========================================================================
-- ===========================================================================
-- ===========================================================================
-- generate episode procedure ------------------------------------------------

DROP PROCEDURE IF EXISTS Generate_Next_EP;

CREATE PROCEDURE Generate_Next_EP(IN ep INT, IN nc INT, IN ck INT, IN re INT, IN jj INT) BEGIN

DECLARE i INT DEFAULT 0;

SET ep = (SELECT episode_id FROM assignments
    ORDER BY episode_id DESC LIMIT 1
    );
SET ep = COALESCE(ep, 0);
SET ep = ep + 1;

WHILE i < 10 DO
    -- select 10 cuisines, cooks, recipes
    CALL Select_Cuisine(ep, nc, ck, re);
    
    SET i = i + 1;
END WHILE;


SET i = 0;
WHILE i < 3 DO
    -- select 3 cooks-judges
    CALL Select_Judge (ep, jj);
    
    SET i = i + 1;
END WHILE;

END;
