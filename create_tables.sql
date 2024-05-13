
-- -----------------------------------------------------
-- RECIPES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Recipes (
    recipe_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    saltysweet BOOLEAN,
    diffiiculty INT, -- 1 EWS 5
    prep_time INT, -- PARADOXH OTI EINAI INT SE LEPTA, 
    cook_time INT,
    total_time INT, -- YPOLOGIZETAI DYNAMIKA APO PREP K COOK TIME
    tip_1 TEXT,
    tip_2 TEXT,
    tip_3 TEXT,
    carbs_per_m INT, -- PARADOXH OTI EINAI INT SE THERMIDES
    protein_per_m INT,
    fat_per_m INT,
    calories_per_m INT, -- YPOLOGIZETAI DYNAMIKA APO YLIKA KAI POSOTHES KAI CAL/GR/ML
    
    group_id INT NOT NULL,
    cuisine_id INT NOT NULL,

    PRIMARY KEY (recipe_id),
    FOREIGN KEY (group_id) REFERENCES Food_Groups (group_id)
    FOREIGN KEY (cuisine_id) REFERENCES National_Cuisine (cuisine_id)
);

-- -----------------------------------------------------
-- EPISODES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Episodes (
  episode_id INT AUTO_INCREMENT,
  episode_year INT,
  episode_number INT,

  PRIMARY KEY (episode_id)
);

-- -----------------------------------------------------
-- COOKS TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Cooks (
  cook_id INT AUTO_INCREMENT,
  name VARCHAR(255),
  surname VARCHAR(255),
  phone_number INT,
  y_of_birth INT,
  age() INT, -- YPOLOGIZETAI DYNAMIKA APO Y.O.BIRTH
  ys_of_exp INT,
  level VARCHAR(),
 
 PRIMARY KEY (cook_id)
);

-- -----------------------------------------------------
-- NATIONAL CUISINES TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS National_Cuisines (
  cuisine_id INT AUTO_INCREMENT,
  name VARCHAR(255),

  PRIMARY KEY (cuisine_id)
);

-- -----------------------------------------------------
-- THEMATIC UNITS TABLE 
-- -----------------------------------------------------
CREATE TABLE Thematic_Units (
  unit_id INT AUTO_INCREMENT,
  name VARCHAR(255),
  description TEXT,
  
  PRIMARY KEY (unit_id)
);
-- -----------------------------------------------------
-- TAGS  TABLE 
-- -----------------------------------------------------

-- -----------------------------------------------------
-- EQUIPMENT TABLE 
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS equipment (
    id INT AUTO_INCREMENT,
    name VARCHAR(255),
    instructions TEXT
);
-- -----------------------------------------------------
-- MEAL TYPE TABLE 
-- -----------------------------------------------------








CREATE TABLE ingredients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name varchar(255),
    calories INT
);

CREATE TABLE recipe_ingredient (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT FOREIGN KEY,
    ingredient_id_id INT FOREIGN KEY,
    amount FLOAT
);





CREATE TABLE steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id
    equipment_id
);


CREATE TABLE steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipe_id INT FOREIGN KEY,
    order INT,
    step TEXT,
);

-- remote commit test --
