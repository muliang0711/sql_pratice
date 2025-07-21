-- RESET ENVIRONMENT
DROP DATABASE IF EXISTS testdb;
CREATE DATABASE testdb;
USE testdb;

-- CREATE MAIN TABLE
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50),
  created_at DATETIME
);

-- CREATE LOG TABLE (used by the trigger)
CREATE TABLE user_log (
  user_id INT,
  action VARCHAR(50),
  log_time DATETIME
);

-- CREATE TRIGGER: AFTER INSERT log to user_log
DELIMITER //

CREATE TRIGGER trg_after_insert_user
AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO user_log (user_id, action, log_time)
  VALUES (NEW.id, 'INSERT', NOW());
END;
//

DELIMITER ;

-- CREATE PROCEDURE: insert a new user with a name
DELIMITER //

CREATE PROCEDURE add_user(IN uname VARCHAR(50))
BEGIN
  INSERT INTO users (name, created_at)
  VALUES (uname, NOW());
END;
//

DELIMITER ;

-- CALL PROCEDURE to trigger logic
CALL add_user('HY');
CALL add_user('Alice');
CALL add_user('Bob');

-- CHECK RESULTS
SELECT * FROM users;
SELECT * FROM user_log;
