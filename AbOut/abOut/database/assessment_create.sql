-- MySQL Script generated by MySQL Workbench
-- Mon Feb  3 12:24:24 2020
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema assessment
-- -----------------------------------------------------
-- Draft database to support a version of an AbOut-like webserivce for multiple departments. 

-- -----------------------------------------------------
-- Schema assessment
--
-- Draft database to support a version of an AbOut-like webserivce for multiple departments. 
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `assessment` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `assessment` ;

-- -----------------------------------------------------
-- Table `assessment`.`semesters`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`semesters` ;

CREATE TABLE IF NOT EXISTS `assessment`.`semesters` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` CHAR(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `semesterID_UNIQUE` (`id` ASC) ,
  UNIQUE INDEX `semesterName_UNIQUE` (`name` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`intervals`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`intervals` ;

CREATE TABLE IF NOT EXISTS `assessment`.`intervals` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `begin` INT NOT NULL,
  `end` INT NULL COMMENT 'Readly I want too allow nulls.',
  PRIMARY KEY (`id`),
  INDEX `begin_idx` (`begin` ASC) ,
  INDEX `end_idx` (`end` ASC) ,
  CONSTRAINT `begin`
    FOREIGN KEY (`begin`)
    REFERENCES `assessment`.`semesters` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `end`
    FOREIGN KEY (`end`)
    REFERENCES `assessment`.`semesters` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`programs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`programs` ;

CREATE TABLE IF NOT EXISTS `assessment`.`programs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `abbrev` CHAR(5) NOT NULL,
  `name` VARCHAR(45) NOT NULL UNIQUE,
  `current_semester_id` INT NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `current_semester_id_idx` (`current_semester_id` ASC) ,
  INDEX `interval_id_idx` (`interval_id` ASC) ,
  CONSTRAINT `current_semester_id`
    FOREIGN KEY (`current_semester_id`)
    REFERENCES `assessment`.`semesters` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`users` ;

CREATE TABLE IF NOT EXISTS `assessment`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cas` CHAR(25) NOT NULL,
  `first` CHAR(25) NOT NULL,
  `last` CHAR(25) NOT NULL,
  `superuser` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `userID_UNIQUE` (`id` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`subjects`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`subjects` ;

CREATE TABLE IF NOT EXISTS `assessment`.`subjects` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` CHAR(5) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`courses` ;

CREATE TABLE IF NOT EXISTS `assessment`.`courses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `subject_id` INT NOT NULL,
  `number` CHAR(5) NOT NULL,
  `name` VARCHAR(70) NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `courses_interval_id_idx` (`interval_id` ASC) ,
  INDEX `subject_id_idx` (`subject_id` ASC) ,
  CONSTRAINT `courses_interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `subject_id`
    FOREIGN KEY (`subject_id`)
    REFERENCES `assessment`.`subjects` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`program_courses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`program_courses` ;

CREATE TABLE IF NOT EXISTS `assessment`.`program_courses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `program_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `program_id_idx` (`program_id` ASC) ,
  INDEX `course_id_idx` (`course_id` ASC) ,
  INDEX `program_courses_interval_id_idx` (`interval_id` ASC) ,
  CONSTRAINT `program_courses_program_id`
    FOREIGN KEY (`program_id`)
    REFERENCES `assessment`.`programs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `course_id`
    FOREIGN KEY (`course_id`)
    REFERENCES `assessment`.`courses` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `program_courses_interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`prefixes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`prefixes` ;

CREATE TABLE IF NOT EXISTS `assessment`.`prefixes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` CHAR(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `outcomePrefix_UNIQUE` (`text` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`outcomes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`outcomes` ;

CREATE TABLE IF NOT EXISTS `assessment`.`outcomes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `prefix_id` INT NOT NULL,
  `identifier` CHAR(5) NOT NULL,
  `text` VARCHAR(300) NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `outcomeID_UNIQUE` (`id` ASC) ,
  INDEX `interval_id_idx` (`interval_id` ASC) ,
  CONSTRAINT `prefix_id`
    FOREIGN KEY (`prefix_id`)
    REFERENCES `assessment`.`prefixes` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `outcomes_interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`program_outcomes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`program_outcomes` ;

CREATE TABLE IF NOT EXISTS `assessment`.`program_outcomes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `program_id` INT NOT NULL,
  `outcome_id` INT NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `programOutcomeID_UNIQUE` (`id` ASC) ,
  INDEX `program_id_idx` (`program_id` ASC) ,
  INDEX `outcome_id_idx` (`outcome_id` ASC) ,
  INDEX `interval_id_idx` (`interval_id` ASC) ,
  CONSTRAINT `program_outcomes_program_id`
    FOREIGN KEY (`program_id`)
    REFERENCES `assessment`.`programs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `outcome_id`
    FOREIGN KEY (`outcome_id`)
    REFERENCES `assessment`.`outcomes` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `program_outcomes_interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`measures`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`measures` ;

CREATE TABLE IF NOT EXISTS `assessment`.`measures` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `program_outcomes_id` INT NOT NULL,
  `program_courses_id` INT NOT NULL,
  `interval_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `program_outcomes_id_idx` (`program_outcomes_id` ASC) ,
  INDEX `program_courses_id_idx` (`program_courses_id` ASC) ,
  INDEX `interval_id_idx` (`interval_id` ASC) ,
  CONSTRAINT `program_outcomes_id`
    FOREIGN KEY (`program_outcomes_id`)
    REFERENCES `assessment`.`program_outcomes` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `program_courses_id`
    FOREIGN KEY (`program_courses_id`)
    REFERENCES `assessment`.`program_courses` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `measures_interval_id`
    FOREIGN KEY (`interval_id`)
    REFERENCES `assessment`.`intervals` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `assessment`.`permissions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `assessment`.`permissions` ;

CREATE TABLE IF NOT EXISTS `assessment`.`permissions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `program_id` INT NOT NULL,
  `is_manager` TINYINT NOT NULL DEFAULT 0,
  `is_observer` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  INDEX `permissions_user_id_idx` (`user_id` ASC),
  INDEX `permissions_program_id_idx` (`program_id` ASC),
  CONSTRAINT `permissions_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `assessment`.`users` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `permissions_program_id`
    FOREIGN KEY (`program_id`)
    REFERENCES `assessment`.`programs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
