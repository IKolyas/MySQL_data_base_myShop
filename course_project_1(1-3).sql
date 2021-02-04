-- �������� ������ �� ����� "������ ����������� ��� ������. MySQL" (����� 1, ������ 1-3)
/* 
 *  1. ��������� ����� ��������� �������� �� � �������� �� �����;
 *  2. ����������� ���������� ������ - 10;
	3. ������� �������� ��������� �� (� ���������� �������, ���������, �������� �������);

	����: "���� ������ ��������-�������� ������"
	������: ������� ���� ������ �������� ��������, ������� ������� (�� ����� 10). ������� ������ ��������� ���������� � ������ (������������, ��������, ���� � �.�.),
	��������� ������� (������������ ���� ��� ����������), ����������� ��� �������, ���������� ������ �� ������, ������������ ������ (��� ��������). ��� �� ����������� ������� 
	������� ������� �������������, ������� �������������, � ������� ������������.
 * */

DROP DATABASE IF EXISTS `shop`;
CREATE DATABASE `shop`;

USE `shop`;

DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`(
	`id` SERIAL PRIMARY KEY,
	`name` varchar(32) NOT NULL COMMENT '���������',
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS `subcategory`;
CREATE TABLE `subcategory`(
	`id` SERIAL PRIMARY KEY,
	`name` varchar(32) NOT NULL COMMENT '������������',
	`category_id` bigint UNSIGNED NOT NULL,
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_subcategory_category_id
	FOREIGN KEY (`category_id`) REFERENCES category(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
	`id` SERIAL PRIMARY KEY,
	`name` varchar(64) NOT NULL COMMENT '������������ ������',
	`category_id` bigint UNSIGNED NOT NULL,
	`subcategory_id` bigint UNSIGNED NOT NULL,
	`brief_description` TINYTEXT COMMENT '������� �������� ������',
	`description` text COMMENT '������ �������� ������',
	`price` int UNSIGNED NOT NULL,
	`size` varchar(8),
	`color` varchar(16),
	`views` bigint UNSIGNED DEFAULT 0,
	`quantity_stock` int UNSIGNED,
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	INDEX products_name_idx(`name`),
	CONSTRAINT fk_product_category_id
	FOREIGN KEY (`category_id`) REFERENCES category(id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_product_subcategory_id
	FOREIGN KEY (`subcategory_id`) REFERENCES subcategory(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
	`id` SERIAL PRIMARY KEY,
	`product_id` bigint UNSIGNED NOT NULL,
	`image_path` blob NOT NULL COMMENT '������ �� ��������',
	`image_type` varchar(8) NOT NULL,
	`image_size` bigint NOT NULL,
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_image_product_id
	FOREIGN KEY (`product_id`) REFERENCES products(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `user_statuses`;
CREATE TABLE `user_statuses` (
	`id` SERIAL PRIMARY KEY,
	`name` varchar(16) NOT NULL
);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`id` SERIAL PRIMARY KEY,
	`name` varchar(32),
	`firstname` varchar(100),
    `lastname` varchar(100),
    `email` varchar(100) UNIQUE,
    `password_hash` varchar(100),
    `phone` bigint UNIQUE NOT NULL,
    `is_deleted` bit DEFAULT 0,
    `status` bigint UNSIGNED NOT NULL,
    `create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
    INDEX users_firstname_lastname_idx(`firstname`, `lastname`),
    CONSTRAINT fk_user_status_id
	FOREIGN KEY (`status`) REFERENCES user_statuses(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	`id` SERIAL PRIMARY KEY,
	`user_id` bigint UNSIGNED NOT NULL,
    `gender` CHAR(1),
    `birthday` DATE,
    `hometown` VARCHAR(100),
    `create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	INDEX profiles_birthday_idx(`birthday`),
	CONSTRAINT fk_profile_user_id
	FOREIGN KEY (`user_id`) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews` (
	`id` SERIAL PRIMARY KEY,
	`from_user_id` bigint UNSIGNED NOT NULL COMMENT '�� ������������',
	`for_product_id` bigint UNSIGNED NOT NULL COMMENT '� ������',
	`if_like` bool NOT NULL DEFAULT 1 COMMENT 'Like/Dislike',
	`review_text` text COMMENT '�����',
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_review_user_id
	FOREIGN KEY (`from_user_id`) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_review_product_id
	FOREIGN KEY (`for_product_id`) REFERENCES products(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS `basket`;
CREATE TABLE `basket` (
	`id` SERIAL PRIMARY KEY,
	`user_id` bigint UNSIGNED NOT NULL,
	`product_id` bigint UNSIGNED NOT NULL,
	`quantity` int UNSIGNED NOT NULL,
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_basket_user_id
	FOREIGN KEY (`user_id`) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_basket_product_id
	FOREIGN KEY (`product_id`) REFERENCES products(id) ON UPDATE CASCADE ON DELETE RESTRICT
);


DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
	`id` SERIAL PRIMARY KEY,
	`user_id` bigint UNSIGNED NOT NULL,
	`quantity` int UNSIGNED NOT NULL COMMENT '����� ���������� ������ � ������',
	`sum` float(5,2) UNSIGNED NOT NULL COMMENT '����� ����� ������',
	`order_status` set('pending payment', 'paid', 'delivered', 'issued') NOT NULL DEFAULT 'pending payment',
	`create_at` DATETIME DEFAULT NOW(),
	`update_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	
	CONSTRAINT fk_order_user_id
	FOREIGN KEY (`user_id`) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT
);

