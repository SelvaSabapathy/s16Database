-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema social
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema social
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `social` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `social` ;

-- -----------------------------------------------------
-- Table `social`.`location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`location` (
  `id` INT(32) GENERATED ALWAYS AS ()  COMMENT 'Surrogate Key',
  `door_number_street` VARCHAR(45) NOT NULL COMMENT 'Door Number and Street Name',
  `city` VARCHAR(45) NOT NULL COMMENT 'City Name',
  `state_code` VARCHAR(2) NOT NULL COMMENT 'State Code (USA) - 2 character such as AL, CA, GA, NY, …',
  `zipcode` VARCHAR(5) NOT NULL COMMENT '5 digit ZIP code (USA)',
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `social`.`profile`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`profile` (
  `id` INT(32) UNSIGNED NOT NULL AUTO_INCREMENT,
  `display_name` VARCHAR(45) NOT NULL,
  `display_picture` BLOB NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  UNIQUE INDEX `display_name_UNIQUE` (`display_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`user` (
  `id` INT(32) NOT NULL AUTO_INCREMENT COMMENT 'Surrogate Key',
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `location_id` INT(32) UNSIGNED NOT NULL,
  `profile_id` INT(32) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  INDEX `fk_user_location_idx` (`location_id` ASC) VISIBLE,
  INDEX `fk_user_profile1_idx` (`profile_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_location`
    FOREIGN KEY (`location_id`)
    REFERENCES `social`.`location` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_user_profile1`
    FOREIGN KEY (`profile_id`)
    REFERENCES `social`.`profile` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`suspend`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`suspend` (
  `id` INT(32) NOT NULL AUTO_INCREMENT,
  `active` BINARY(1) NOT NULL,
  `from` DATETIME NOT NULL,
  `to` DATETIME NOT NULL,
  `user_id` INT(32) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_suspend_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_suspend_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`social_accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`social_accounts` (
  `id` INT(32) GENERATED ALWAYS AS ()  COMMENT 'Surrogate Key',
  `details` VARCHAR(45) NOT NULL COMMENT 'Connection and other details to social media account',
  `user_id` INT(32) NOT NULL COMMENT 'User ID of the social account owner',
  PRIMARY KEY (`id`),
  INDEX `fk_social_accounts_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_social_accounts_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`social_media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`social_media` (
  `id` INT(32) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Surrogate Key',
  `media` VARCHAR(45) NOT NULL COMMENT 'Facebook, Twitter, etc.',
  `social_accounts_id` INT(32) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_social_media_social_accounts1_idx` (`social_accounts_id` ASC) VISIBLE,
  CONSTRAINT `fk_social_media_social_accounts1`
    FOREIGN KEY (`social_accounts_id`)
    REFERENCES `social`.`social_accounts` (`id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`post`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`post` (
  `id` INT(32) GENERATED ALWAYS AS ()  COMMENT 'Surrogate Key',
  `details` VARCHAR(45) NOT NULL COMMENT 'Post details',
  `user_id` INT(32) NOT NULL COMMENT 'User creating the post',
  PRIMARY KEY (`id`),
  INDEX `fk_post_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_post_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`tag` (
  `id` INT(32) GENERATED ALWAYS AS () STORED COMMENT 'Surrogate Key',
  `name` VARCHAR(45) NOT NULL COMMENT 'Tag name',
  `post_id` INT(32) UNSIGNED NOT NULL COMMENT 'Post ID',
  PRIMARY KEY (`id`),
  INDEX `fk_tag_post1_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `fk_tag_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `social`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`category` (
  `id` INT(32) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `post_id` INT(32) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_category_post1_idx` (`post_id` ASC) VISIBLE,
  CONSTRAINT `fk_category_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `social`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`comment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`comment` (
  `id` INT(32) GENERATED ALWAYS AS () STORED COMMENT 'Surrogate Key',
  `text` VARCHAR(45) NOT NULL COMMENT 'Comment text',
  `post_id` INT(32) UNSIGNED NOT NULL COMMENT 'Post ID for the comment',
  `user_id` INT(32) NOT NULL COMMENT 'User ID of the comment creator',
  PRIMARY KEY (`id`),
  INDEX `fk_comment_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_comment_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_comment_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `social`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_comment_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`follower`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`follower` (
  `user_id` INT(32) NOT NULL COMMENT 'Following user',
  `user_id1` INT(32) NOT NULL COMMENT 'Followed user id',
  `notification` BINARY(1) NOT NULL COMMENT 'Follow notification Y/N',
  `comment` BINARY(1) NOT NULL COMMENT 'Follow comment Y/N',
  PRIMARY KEY (`user_id`, `user_id1`),
  INDEX `fk_user_has_user_user2_idx` (`user_id1` ASC) VISIBLE,
  INDEX `fk_user_has_user_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_has_user_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_user_user2`
    FOREIGN KEY (`user_id1`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `social`.`favorite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `social`.`favorite` (
  `id` INT(32) NOT NULL COMMENT 'Surrogate Key',
  `post_id` INT(32) UNSIGNED NOT NULL COMMENT 'Favorite Post ID',
  `user_id` INT(32) NOT NULL COMMENT 'Favoriting User ID',
  PRIMARY KEY (`id`),
  INDEX `fk_favorite_post1_idx` (`post_id` ASC) VISIBLE,
  INDEX `fk_favorite_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_favorite_post1`
    FOREIGN KEY (`post_id`)
    REFERENCES `social`.`post` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_favorite_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `social`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
