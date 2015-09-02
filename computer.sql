/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50622
Source Host           : localhost:3306
Source Database       : product

Target Server Type    : MYSQL
Target Server Version : 50622
File Encoding         : 65001

Date: 2015-09-01 08:30:45
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for computer
-- ----------------------------
DROP TABLE IF EXISTS `computer`;
CREATE TABLE `computer` (
  `id` int(10) NOT NULL AUTO_INCREMENT COMMENT '产品标记',
  `m_name` varchar(100) NOT NULL COMMENT '产品详细信息',
  `re_price` text NOT NULL COMMENT '产品参考价格',
  `m_score` float(2,1) NOT NULL COMMENT '综合评分',
  `m_battery` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '电池续航',
  `m_screen` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '屏幕效果',
  `m_design` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '外观设计',
  `m_fun` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '娱乐/散热',
  `m_run` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '运行速度',
  `m_cp` float(2,1) NOT NULL DEFAULT '5.0' COMMENT '性价比',
  `m_category` text NOT NULL COMMENT '产品分类',
  `m_image` varchar(500) NOT NULL COMMENT '产品图片',
  `m_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`m_name`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4808 DEFAULT CHARSET=utf8;
