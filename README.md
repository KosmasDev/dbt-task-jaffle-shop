# Customer Analytics with dbt Cloud – by Kosmas Strakosia

This project is designed to help you explore the core functionality and key features of the dbt Cloud platform. It uses a fictional restaurant — the Jaffle Shop — as the basis for working with realistic, relatable data.

The purpose of this README is to guide you through:
- Setting up the project in dbt Cloud
- Loading the example datasets
- Performing data transformations
- Building models that can help uncover valuable insights into customer behavior and business performance

By the end of this project, you'll have hands-on experience with building a modern analytics workflow using dbt Cloud.

## Purpose & Insights

The main purpose of this project is to explore the dbt Cloud features and utilize its functionalities to load, transform, and analyse the required data to answer the following questions.
- Which customer has visited more locations?
- List the most loyal customer per location.
- Has anyone ordered everything?

> [!NOTE1]
> In the context of this project, the main focus will be on the processes of the    (The raw datasets used in the context of this project are included in the folder [seeds/jaffle-data](https://github.com/KosmasDev/dbt-task-jaffle-shop/tree/main/seeds/jaffle-data).)

## Table of Contents
1. [Prerequisites](#prerequisites)
    1. [Section 1.1](#section-11)
    2. [Section 1.2](#section-12)
2. [Section 3](#section-2)

## Prerequisites
Before getting started, make sure you have the following:
- A dbt Cloud account (a 14-day free trial is available)
- Access to a data warehouse with the necessary permissions to:
    - Create a new database for this project
    - Execute SQL queries and run dbt models
> [!NOTE]
> In this project, Snowflake is used as the data warehouse, but you can adapt it to other supported platforms if needed.




