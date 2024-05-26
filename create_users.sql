
-- CREATE USERS AND GRANT ACCESS --
-- ---------------------------------

-- CREATE USERS --

-- SIMPLE COOK USER --
DROP USER 'cook_user'@'localhost';
flush privileges;
CREATE USER 'cook_user'@'localhost' IDENTIFIED BY 'cook_password';

-- Grant SELECT permissions on CookPersonalInfo view to the user
GRANT SELECT,UPDATE ON Cook_Personal_Info TO 'cook_user'@'localhost';
-- Grant SELECT permissions on CookRecipes view to the user
GRANT SELECT,UPDATE ON Cook_Recipes TO 'cook_user'@'localhost';


-- ADMIN USER --
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';

--GRANT ALL permissions on the database to the user
GRANT ALL PRIVILEGES ON masterchef.* TO 'admin_user'@'localhost';
