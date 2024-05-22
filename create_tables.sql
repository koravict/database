
USE masterchef;

-- =============================================================
-- -------------------------------------------------------------
-- --  --  --  BASIC TABLES   OF   DATABASE   --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================



-- -----------------------------------------------------
-- FOOD GROUPS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Food_Groups (
  group_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,

  PRIMARY KEY (group_id)
);
-- -----------------------------------------------------
-- NATIONAL CUISINES TABLE 
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS National_Cuisines (
  cuisine_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,

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
    
    group_id INT NOT NULL,
    cuisine_id INT NOT NULL,

    PRIMARY KEY (recipe_id),
    FOREIGN KEY (group_id) REFERENCES Food_Groups (group_id),
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisines (cuisine_id),

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

    PRIMARY KEY (episode_id),

    CHECK (episode_year > 0 ),
    CHECK (episode_number > 0 AND episode_number <11)
);

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
 
    PRIMARY KEY (cook_id),

    CHECK (ys_of_exp < age ),
    CHECK (level IN ('αρχιμάγειρας (σεφ)', 'A΄ μάγειρας', 'Β΄ μάγειρας', 'Γ΄ μάγειρας', 'βοηθός αρχιμάγειρα')));


-- -----------------------------------------------------
-- THEMATIC UNITS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Thematic_Units (
  unit_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  
  PRIMARY KEY (unit_id)
);
-- -----------------------------------------------------
-- TAGS  TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Tags (
  tag_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,

  PRIMARY KEY (tag_id)
);
-- -----------------------------------------------------
-- EQUIPMENT TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Equipment (
    equipment_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    instructions TEXT,

    PRIMARY KEY (equipment_id)
);
-- -----------------------------------------------------
-- MEAL TYPE TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Meal_Type (
  meal_id INT AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  
  PRIMARY KEY (meal_id)
);

-- -----------------------------------------------------
-- INGREDIENTS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ingredients (
    ingredient_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    calories_per_100 INT DEFAULT 0,
    
    group_id INT NOT NULL,
    
    PRIMARY KEY (ingredient_id),
    FOREIGN KEY (group_id) REFERENCES Food_Groups (group_id),

    CHECK (calories_per_100 > 0)
);

-- -----------------------------------------------------
-- STEPS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS steps (
    step_id INT AUTO_INCREMENT,
    step_order INT DEFAULT 1,
    step_instr TEXT,

    recipe_id INT NOT NULL,
    
    PRIMARY KEY (step_id),
    FOREIGN KEY (recipe_id) REFERENCES Recipes (recipe_id),
    
    CHECK (step_order > 0)
);


-- =============================================================
-- -------------------------------------------------------------
--   JUNCTION   TABLES   FOR   MANY-TO-MANY   RELATIONSHIPS   --
-- -------------------------------------------------------------
-- =============================================================


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

-- -----------------------------------------------------
-- COOKS <-> EPISODES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cooks_Episodes (
    cooks_episodes_id INT AUTO_INCREMENT,
    cook_id INT NOT NULL,
    episode_id INT NOT NULL,

    is_judge BOOLEAN,
    score1 INT DEFAULT 1,
    score2 INT DEFAULT 1,
    score3 INT DEFAULT 1,
    total_score INT,            -- ypologizetai dynamika apo score 1, 2, 3

    PRIMARY KEY (cooks_episodes_id),
    FOREIGN KEY (cook_id) REFERENCES Cooks (cook_id),
    FOREIGN KEY (episode_id) REFERENCES Episodes (episode_id),

    CHECK (score1 > 0 AND score1 < 6),
    CHECK (score2 > 0 AND score2 < 6),
    CHECK (score3 > 0 AND score3 < 6)
);

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

-- -----------------------------------------------------
-- NATIONAL CUISINES <-> COOKS TABLE 
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
-- COOKS <-> RECIPES TABLE 
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

/*
CREATE UNIQUE INDEX idx_phone_numbers ON phone_number (organization_id, p_number);

CREATE UNIQUE INDEX idx_researcher_name ON researcher (first_name, last_name);

CREATE UNIQUE INDEX idx_organization_name ON org (organization_name);

CREATE UNIQUE INDEX idx_project_title ON project (title);

CREATE UNIQUE INDEX idx_scientific_field_name ON scientific_field (scientific_field_name);
*/

-- =============================================================
-- -------------------------------------------------------------
-- -- -- --  --  --  -- --    VIEWS    --  -- --  --  --  --  --
-- -------------------------------------------------------------
-- =============================================================

--@block
CREATE VIEW Calories_per_Serving AS
SELECT  r.recipe_id, r.name AS 'recipe', r.servings,
        i.ingredient_id, i.name AS 'ingredient', i.calories_per_100,
        ir.amount_int,
        SUM(ir.amount_int * i.calories_per_100 / 100) / r.servings AS cal_per_serving
FROM Recipes r
INNER JOIN Ingredients_Recipes ir ON r.recipe_id = ir.recipe_id
INNER JOIN Ingredients i ON i.ingredient_id = ir.ingredient_id
GROUP BY r.recipe_id;
