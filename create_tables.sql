   


USE masterchef;

-- =============================================================
-- -------------------------------------------------------------
-- --  --  --  BASIC TABLES   OF   DATABASE   --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

-- -----------------------------------------------------
-- COOKS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cooks (
    cook_id INT AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(12),
    y_of_birth INT NOT NULL,
    age INT GENERATED ALWAYS AS (2024 - y_of_birth) STORED,-- YPOLOGIZETAI DYNAMIKA APO Y.O.BIRTH
    ys_of_exp INT,
    level VARCHAR(255),
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),
 
    PRIMARY KEY (cook_id),

    CHECK (ys_of_exp < age ),
    CHECK (level IN 
    ('αρχιμάγειρας (σεφ)', 'A΄ μάγειρας', 'Β΄ μάγειρας', 'Γ΄ μάγειρας', 'βοηθός αρχιμάγειρα')));


-- -----------------------------------------------------
-- FOOD GROUPS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Food_Groups (
  group_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  link_to_image VARCHAR(255),
  image_description VARCHAR(255),

  PRIMARY KEY (group_id)
);
-- -----------------------------------------------------
-- NATIONAL CUISINES TABLE 
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS National_Cuisines (
  cuisine_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  link_to_image VARCHAR(255),
  image_description VARCHAR(255),

  PRIMARY KEY (cuisine_id)
);

-- -----------------------------------------------------
-- RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Recipes (
    recipe_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    saltysweet BOOLEAN,
    difficulty INT,
    prep_time INT DEFAULT 0,
    cook_time INT DEFAULT 0,
    total_time INT GENERATED ALWAYS AS (prep_time + cook_time) STORED, -- YPOLOGIZETAI DYNAMIKA APO PREP K COOK TIME
    tip_1 TEXT,
    tip_2 TEXT,
    tip_3 TEXT,
    servings INT,
    carbs_per_s INT,            -- PARADOXH OTI EINAI INT SE THERMIDES
    protein_per_s INT,    
    fat_per_s INT,
    -- cal_per_s INT, -- ME VIEW  YPOLOGIZETAI DYNAMIKA APO YLIKA KAI POSOTHES KAI CAL/GR/ML
    
    group_id INT NOT NULL,    -- -- PREPEI NA GINEI  NOT NULL K NA PAIRNEI TIMES
    cuisine_id INT NOT NULL,
    owner_id INT NOT NULL,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

    PRIMARY KEY (recipe_id),
    FOREIGN KEY (group_id) REFERENCES Food_Groups (group_id),
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisines (cuisine_id),
    FOREIGN KEY (owner_id) REFERENCES Cooks (cook_id),


    CHECK (difficulty > 0 AND difficulty <6),
    CHECK (servings > 0)

);

-- -----------------------------------------------------
-- EPISODES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Episodes (
    episode_id INT AUTO_INCREMENT,
    episode_year INT NOT NULL,
    episode_number INT NOT NULL,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

    PRIMARY KEY (episode_id),

    CHECK (episode_year > 0 ),
    CHECK (episode_number > 0 AND episode_number <11)
);

-- -----------------------------------------------------
-- THEMATIC UNITS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Thematic_Units (
  unit_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  link_to_image VARCHAR(255),
  image_description VARCHAR(255),
  
  PRIMARY KEY (unit_id)
);
-- -----------------------------------------------------
-- TAGS  TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Tags (
  tag_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  link_to_image VARCHAR(255),
  image_description VARCHAR(255),

  PRIMARY KEY (tag_id)
);
-- -----------------------------------------------------
-- EQUIPMENT TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Equipment (
    equipment_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    instructions TEXT,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

    PRIMARY KEY (equipment_id)
);
-- -----------------------------------------------------
-- MEAL TYPE TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Meal_Type (
  meal_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  link_to_image VARCHAR(255),
  image_description VARCHAR(255),
  
  PRIMARY KEY (meal_id)
);

-- -----------------------------------------------------
-- INGREDIENTS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ingredients (
    ingredient_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    calories_per_100 INT DEFAULT 0,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),
    
    group_id INT NOT NULL,
    
    PRIMARY KEY (ingredient_id),
    FOREIGN KEY (group_id) REFERENCES Food_Groups (group_id),

    CHECK (calories_per_100 >= 0)
);

-- -----------------------------------------------------
-- STEPS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS steps (
    step_id INT AUTO_INCREMENT,
    step_order INT DEFAULT 1,
    step_instr TEXT,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

    recipe_id INT NOT NULL,
    
    PRIMARY KEY (step_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id),
    
    CHECK (step_order > 0)
);

-- -----------------------------------------------------
-- ASSIGNMENTS TABLE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Assignments (
    assignment_id INT AUTO_INCREMENT,
    episode_id INT NOT NULL,
    cuisine_id INT NOT NULL,
    cook_id INT NOT NULL,
    recipe_id INT NULL,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

/*
    score1 INT DEFAULT 1,
    score2 INT DEFAULT 1,
    score3 INT DEFAULT 1,
    total_score INT GENERATED ALWAYS AS (score1 + score2 + score3) STORED,
        -- ypologizetai dynamika apo score 1, 2, 3
*/

    PRIMARY KEY (assignment_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes (episode_id),
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisines (cuisine_id),
    FOREIGN KEY (cook_id) REFERENCES Cooks (cook_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id)

/*
    CHECK (score1 > 0 AND score1 < 6),
    CHECK (score2 > 0 AND score2 < 6),
    CHECK (score3 > 0 AND score3 < 6)
*/

);

-- -----------------------------------------------------
-- JUDGE ASSIGNMENTS TABLE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Judge_Assignment (
    jj_assignment_id INT AUTO_INCREMENT,
    episode_id INT NOT NULL,
    judge_id INT NOT NULL,

    PRIMARY KEY (jj_assignment_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes (episode_id),
    FOREIGN KEY (judge_id) REFERENCES Cooks (cook_id)
);

-- -----------------------------------------------------
-- SCORE OF ASSIGNMENT BY JUDGE
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Score (
    score_id INT AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    judge_id INT NOT NULL,
    score INT NOT NULL,
    link_to_image VARCHAR(255),
    image_description VARCHAR(255),

    PRIMARY KEY (score_id),
    FOREIGN KEY (assignment_id) REFERENCES Assignments (assignment_id),
    FOREIGN KEY (judge_id) REFERENCES Cooks (cook_id),

    CHECK (score >= 1 AND score <= 5)
);



-- =============================================================
-- -------------------------------------------------------------
--   JUNCTION   TABLES   FOR   MANY-TO-MANY   RELATIONSHIPS   --
-- -------------------------------------------------------------
-- =============================================================

/*
-- -----------------------------------------------------
-- EPISODES <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Episodes_Recipes (
    episodes_recipes_id INT AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    episode_id INT NOT NULL,

    PRIMARY KEY (episodes_recipes_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes (episode_id)
);
*/

/*
-- -----------------------------------------------------
-- NATIONAL CUISINES <-> EPISODES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cuisines_Episodes (
    cuisines_episodes_id INT AUTO_INCREMENT,
    cuisine_id INT NOT NULL,
    episode_id INT NOT NULL,

    PRIMARY KEY (cuisines_episodes_id),
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisines (cuisine_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes (episode_id)
);
*/


-- -----------------------------------------------------
-- COOK SPECIALIZES IN NATION CUISINE TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cuisines_Cooks (
    cuisines_cooks_id INT AUTO_INCREMENT,
    cuisine_id INT NOT NULL,
    cook_id INT NOT NULL,

    PRIMARY KEY (cuisines_cooks_id),
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisines (cuisine_id),
    FOREIGN KEY (cook_id) REFERENCES Cooks (cook_id)
);



-- -----------------------------------------------------
-- COOK KNOWS RECIPE TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cooks_Recipes (
    cooks_recipes_id INT AUTO_INCREMENT,
    recipe_id INT NOT NULL,
    cook_id INT NOT NULL,

    PRIMARY KEY (cooks_recipes_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id),
    FOREIGN KEY (cook_id) REFERENCES Cooks (cook_id)
);


-- -----------------------------------------------------
-- THEMATIC UNITS <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Units_Recipes (
    units_recipes_id INT AUTO_INCREMENT,
    unit_id INT NOT NULL,
    recipe_id INT NOT NULL,

    PRIMARY KEY (units_recipes_id),
    FOREIGN KEY (unit_id) REFERENCES Thematic_Units (unit_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id)
);

-- -----------------------------------------------------
-- TAGS <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Tags_Recipes (
    tags_recipes_id INT AUTO_INCREMENT,
    tag_id INT NOT NULL,
    recipe_id INT NOT NULL,

    PRIMARY KEY (tags_recipes_id),
    FOREIGN KEY (tag_id) REFERENCES Tags (tag_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id)
);

-- -----------------------------------------------------
-- EQUIPMENT <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Equipment_Recipes (
    equipment_recipes_id INT AUTO_INCREMENT,
    equipment_id INT NOT NULL,
    recipe_id INT NOT NULL,

    PRIMARY KEY (equipment_recipes_id),
    FOREIGN KEY (equipment_id) REFERENCES Equipment (equipment_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id)
);

-- -----------------------------------------------------
-- MEAL TYPE <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Meal_Recipes (
    meal_recipes_id INT AUTO_INCREMENT,
    meal_id INT NOT NULL,
    recipe_id INT NOT NULL,

    PRIMARY KEY (meal_recipes_id),
    FOREIGN KEY (meal_id) REFERENCES Meal_Type (meal_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id)
);

-- -----------------------------------------------------
-- INGREDIENTS <-> RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ingredients_Recipes (
    ingredients_recipes_id INT AUTO_INCREMENT,
    ingredient_id INT NOT NULL,
    recipe_id INT NOT NULL,
    
    is_basic BOOLEAN,
    amount_int INT DEFAULT 0,
    amount_varchar VARCHAR(255),

    PRIMARY KEY (ingredients_recipes_id),
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients (ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id),

    CHECK (amount_int >= 0)
);


-- =============================================================
-- -------------------------------------------------------------
-- -- -- --  --  --  -- --   INDEXES   --  -- --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

--@block
-- Query 3.1 --
-- Index on cook_id
CREATE INDEX IF NOT EXISTS idx_cook_id ON Assignment(cook_id);

-- Index on cuisine_id
CREATE INDEX  IF NOT EXISTS idx_cuisine_id ON Assignment(cuisine_id);

-- Index on assignment_id in the score table
CREATE INDEX IF NOT EXISTS idx_assignment_id ON Score(assignment_id);

-- Query 3.2 --
-- Composite index on cuisine_id, cook_id and episode_id
CREATE INDEX IF NOT EXISTS idx_cuisine_cook_episode ON Assignment(cuisine_id,cook_id,episode_id);

-- Query 3.3 --
-- index on cooks' age 
CREATE INDEX IF NOT EXISTS idx_year ON Cooks(age);

-- Query 3.4 --
-- index on judge_id in judge assignments
CREATE INDEX IF NOT EXISTS idx_judge ON Judge_Assignment(judge_id);

-- Query 3.7 --
CREATE INDEX IF NOT EXISTS idx_episodes_year_number ON Episodes(episode_year, episode_number);

-- Query 3.9 --
CREATE INDEX IF NOT EXISTS idx_episodes_year ON Episodes(episode_year);
CREATE INDEX IF NOT EXISTS idx_carbs ON Recipes(carbs_per_s);

-- Query 3.12 --
CREATE INDEX IF NOT EXISTS idx_difficulty ON Recipes(difficulty);

-- Query 3.13--
CREATE INDEX IF NOT EXISTS idx_level ON Cooks(level);
-- Query 3.14
CREATE INDEX IF NOT EXISTS idx_units ON Units_Recipes(unit_id);
--Query 3.15
CREATE INDEX IF NOT EXISTS idx_food_groups ON Recipes(group_id);
--@BLOCK 
-- FOR FORCE INDEX IN QUERY 3.6 --
CREATE INDEX IF NOT EXISTS idx_tag ON Tags_Recipes(tag_id);
CREATE INDEX IF NOT EXISTS idx_recipe_id ON recipes(recipe_id);
CREATE INDEX IF NOT EXISTS idx_ass_recipe_id ON assignments(recipe_id);

-- FOR FORCE INDEX IN QUERY 3.8
CREATE INDEX IF NOT EXISTS idx_equipment ON equipment_recipes(recipe_id);
CREATE INDEX IF NOT EXISTS idx_ass_episode ON assignments(episode_id);

-- =============================================================
-- -------------------------------------------------------------
-- -- -- --  --  --  -- --    VIEWS    --  -- --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

DROP VIEW Calories IF EXISTS;
CREATE VIEW Calories AS
SELECT  r.recipe_id, r.name AS recipe, r.servings, 
        ROUND (SUM(ir.amount_int * i.calories_per_100 / 100) / r.servings , 0) AS cal_per_serving,
        COUNT (ir.ingredient_id) AS num_of_ingredients
FROM Recipes r
JOIN Ingredients_Recipes ir ON r.recipe_id = ir.recipe_id
JOIN Ingredients i ON i.ingredient_id = ir.ingredient_id
GROUP BY r.recipe_id;

-- Views for a user that is also a cook --
-- ---------------------------------------

DROP VIEW Cook_Recipes IF EXISTS;
CREATE VIEW Cook_Recipes AS
SELECT r.*
FROM Recipes r
JOIN Cooks c ON r.owner_id = c.cook_id
WHERE c.cook_id = 'example_user_cook_id';

DROP VIEW Cook_Personal_Info IF EXISTS;
CREATE VIEW Cook_Personal_Info AS
SELECT c.cook_id,c.full_name,c.phone_number,c.y_of_birth,c.age,c.ys_of_exp,c.level
FROM Cooks c
WHERE c.cook_id = 'example_user_cook_id';
