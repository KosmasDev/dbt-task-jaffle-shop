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

> [!NOTE]
> In the context of this project, the main focus will be on the processes of the    (The raw datasets used in the context of this project are included in the folder [seeds/jaffle-data](https://github.com/KosmasDev/dbt-task-jaffle-shop/tree/main/seeds/jaffle-data).)

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Initializing Your Repository - Create & Fork](#initializing-your-repository---create-&-Fork)
    1. [Step 1: Create a New Repository](#step-1:-create-a-new-repository)
    2. [Step 2: Fork the Jaffle Shop Project](#step-2:-fork-the-jaffle-shop-project)
3. [Clean up the repository](#clean-up-the-repository)

## Prerequisites
- A dbt Cloud account (a 14-day free trial is available)
- Access to a data warehouse with the necessary permissions to:
    - Create a new database for this project
    - Execute SQL queries and run dbt models
> [!NOTE]
> In this project, Snowflake is used as the data warehouse, but you can adapt it to other supported platforms if needed.

## Initializing Your Repository - Create & Fork

### Step 1: Create a New Repository
1. Go to your GitHub account.
2. In the top-right corner, click "Create new..." and select "New repository".
3. Name your repository dbt-task-jaffle-shop (or another name of your choice).
   In this guide, we'll use dbt-task-jaffle-shop as the example repository name.
   
### Step 2: Fork the Jaffle Shop Project
1. Visit the official [dbt-labs/jaffle-shop ](https://github.com/dbt-labs/jaffle-shop) GitHub repository.
2. Make sure you're on the main branch.
3. Click the "Fork" button (top-right corner of the page).
4. Select your newly created repo (dbt-task-jaffle-shop) as the destination.

## Clean up the repository
Only the following items from this repository are required:
- The files located in the seeds/jaffle-data folder
- The dbt_project.yml file

Please feel free to delete the remaining files, as they are not needed for this project.

> [!IMPORTANT]
> Before removing any files, ensure that each existing folder contains a placeholder file named .gitkeep. This will allow you to clean up unnecessary files while still preserving the folder structure in version control.



