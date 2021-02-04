/* 1) Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, 
	название таблицы, идентификатор первичного ключа и содержимое поля name.
*/
USE `shop`;

DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
	`created_at` DATETIME NOT NULL,
	`table_title` VARCHAR(32) NOT NULL,
	`pkey_num` BIGINT(20) NOT NULL,
	`name` VARCHAR(45) NOT NULL
) ENGINE = ARCHIVE;

-- для таблицы users
DROP TRIGGER IF EXISTS `tg_log_user`;
delimiter //
CREATE TRIGGER `tg_log_user` AFTER INSERT ON `users`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`created_at`, table_title, pkey_num, name)
	VALUES (NOW(), 'users', NEW.id, NEW.lastname);
END //
delimiter ;

-- для таблицы category
DROP TRIGGER IF EXISTS `tg_log_category`;
delimiter //
CREATE TRIGGER `tg_log_category` AFTER INSERT ON `category`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`created_at`, table_title, pkey_num, name)
	VALUES (NOW(), 'category', NEW.id, NEW.name);
END //
delimiter ;

-- для таблицы subcategory
DROP TRIGGER IF EXISTS `tg_log_subcategory`;
delimiter //
CREATE TRIGGER `tg_log_subcategory` AFTER INSERT ON `subcategory`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`created_at`, table_title, pkey_num, name)
	VALUES (NOW(), 'subcategory', NEW.id, NEW.name);
END //
delimiter ;

-- для таблицы products
DROP TRIGGER IF EXISTS `tg_log_products`;
delimiter //
CREATE TRIGGER `tg_log_products` AFTER INSERT ON `products`
FOR EACH ROW
BEGIN
	INSERT INTO `logs` (`created_at`, table_title, pkey_num, name)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;

-- проверка до
SELECT * FROM logs;

INSERT INTO `users` VALUES 
	(76,'Lucas','Keyn','luk.12@example.net','300da972ae2776913070ce8b77ff2f28d642ddcb',502237,'\0',1,'1972-01-30 04:18:28','2008-01-20 07:17:00');

INSERT INTO `category` VALUES (9,'qsaa','2011-05-16 08:40:51','1999-06-08 21:58:32');

INSERT INTO `subcategory` VALUES (32,'ffgttte',9,'1976-06-29 14:21:26','2005-09-03 01:21:09');

-- проверка после
SELECT * FROM logs;

/* 
 * 2) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/

-- Не смог решить задачу. Решение из интернета, но очень долго выполняется. Уверен есть более быстрый вариант. Даже не рискнул 1 млн. ставить, 1000 для теста сделал. )))

DROP TABLE IF EXISTS test_users; 
CREATE TABLE test_users (
	`id` SERIAL PRIMARY KEY,
	`name` VARCHAR(255)
);


DROP PROCEDURE IF EXISTS pr_insert_1000000;
delimiter //
CREATE PROCEDURE pr_insert_1000000 ()
BEGIN
	DECLARE i INT DEFAULT 1000;
	WHILE i > 0 DO
		INSERT INTO test_users(name) VALUES (CONCAT('user_', i));
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

-- test
SELECT (name) FROM test_users;

CALL pr_insert_1000000();

SELECT * FROM test_users LIMIT 3;











