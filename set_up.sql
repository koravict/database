
-- first create & connect database with vscode
-- with the help of my boi fireship
-- (https://youtu.be/Cz3WcZLRaWc?t=300)

-- then do the following:

-- ===============================================================
-- --  --  - SET-UP INSTRUCTIONS FOR DATABASE IN VS CODE -  --  --
-- ===============================================================

-- -----------------------------------
--@block
DROP DATABASE IF EXISTS masterchef;
CREATE DATABASE masterchef;

-- -----------------------------------

-- Then run in this order 

-- i)   create_tables.sql
-- ii)  create_users.sql
-- iii) insert_data.sql
-- iv)  junction_data.sql
-- v)   PROCEDURES-AUTO_ASSIGNMENT.sql

-- -----------------------------------

-- Now all the tables except 3 have data already
-- and we have the procedure to fill automatically the remaining
-- Assignments, Judge_Assignments and Score tables.
-- Every time we run Generate_Next_EP, one episode is generated.
-- In our db we have 60 episodes. to fill e.g. 50 of them with info:

--@block------------------------------

-- it calls Generate_Next_EP 50 times
CALL Generate_50_EP(@ep, @nc, @ck, @re, @jj);


-- -----------------------------------

-- db is set up and full of dummy data
-- now open PROJECT_QUERIES.sql
-- and run its part individually
-- enjoy :)
