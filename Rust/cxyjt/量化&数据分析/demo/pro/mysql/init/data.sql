/*
 Navicat Premium Data Transfer

 Source Server         : mysql57
 Source Server Type    : MySQL
 Source Server Version : 50739
 Source Host           : localhost:3307
 Source Schema         : rustdb

 Target Server Type    : MySQL
 Target Server Version : 50739
 File Encoding         : 65001

 Date: 25/11/2022 16:39:27
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE rustdb;

Use rustdb;

-- ----------------------------
-- Table structure for dayk
-- ----------------------------
DROP TABLE IF EXISTS `dayk`;
CREATE TABLE `dayk`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ts_code` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `trade_date` int(11) NULL DEFAULT NULL,
  `open` decimal(10, 2) NULL DEFAULT NULL,
  `high` decimal(10, 2) NULL DEFAULT NULL,
  `low` decimal(10, 2) NULL DEFAULT NULL,
  `close` decimal(10, 2) NULL DEFAULT NULL,
  `pre_close` decimal(10, 2) NULL DEFAULT NULL,
  `change` decimal(10, 2) NULL DEFAULT NULL,
  `pct_chg` decimal(10, 2) NULL DEFAULT NULL,
  `vol` decimal(10, 2) NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `ma5` decimal(10, 2) NULL DEFAULT NULL,
  `ma10` decimal(10, 2) NULL DEFAULT NULL,
  `ma20` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  `ma60` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
