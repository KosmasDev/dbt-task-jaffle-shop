# 📊 Customer Analytics with dbt Cloud 
### ***by Kosmas Strakosia***

This project is designed to help you explore the core functionality and key features of the dbt Cloud platform. It uses a fictional restaurant - the Jaffle Shop - as the basis for working with realistic, relatable data.

The purpose of this README is to guide you through:
- Setting up the project in dbt Cloud
- Loading the example datasets
- Performing data transformations
- Building models that can help uncover valuable insights into customer behavior and business performance

By the end of this project, you'll have hands-on experience with building a modern analytics workflow using dbt Cloud.

## ❓ Purpose & Insights

The main purpose of this project is to explore the dbt Cloud features and utilize its functionalities to load, transform, and analyse the required data to answer the following questions.
- Which customer has visited more locations?
- List the most loyal customer per location.
- Has anyone ordered everything?

> [!NOTE]
> This document primarily focuses on the process of loading data and building models that can be used to generate valuable customer insights. It is **not intended as a detailed guide** for configuring the dbt-Snowflake connection or setting up a full dbt environment. Instead, it provides high-level setup instructions, along with links to official documentation for detailed guidance.

## 📘 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Initializing your repository – create and fork](#initializing-your-repository--create-and-fork)
    1. [Step 1: Create a new repository](#step-1-create-a-new-repository)
    2. [Step 2: Fork the jaffle shop project](#step-2-fork-the-jaffle-shop-project)
3. [Clean up the repository](#clean-up-the-repository)
4. [Setup and Configuration](#setup-and-configuration)
    1. [Configure Snowflake for dbt Cloud](#configure-snowflake-for-dbt-cloud)
    2. [Set up a dbt Cloud Account](#set-up-a-dbt-cloud-account)
    3. [Create a New dbt Project](#create-a-new-dbt-project)


## 📌 Prerequisites
- A dbt Cloud account (a 14-day free trial is available)
- Access to a data warehouse with the necessary permissions to:
    - Create a new database for this project
    - Execute SQL queries and run dbt models
> [!NOTE]
> In this project, Snowflake is used as the data warehouse, but you can adapt it to other supported platforms if needed.

## 🆕 Initializing your repository – Create and fork

### Step 1: Create a new repository
1. Go to your GitHub account.
2. In the top-right corner, click "Create new..." and select "New repository".
3. Name your repository dbt-task-jaffle-shop (or another name of your choice).
   In this guide, we'll use dbt-task-jaffle-shop as the example repository name.
   
### Step 2: Fork the Jaffle Shop project
1. Visit the official [dbt-labs/jaffle-shop ](https://github.com/dbt-labs/jaffle-shop) GitHub repository.
2. Make sure you're on the main branch.
3. Click the "Fork" button (top-right corner of the page).
4. Select your newly created repo (dbt-task-jaffle-shop) as the destination.

## 🗑️ Clean up the repository
Only the following items from this repository are required:
- The files located in the seeds/jaffle-data folder
- The dbt_project.yml file

Please feel free to delete the remaining files, as they are not needed for this project.

> [!IMPORTANT]
> Before removing any files, ensure that each existing folder contains a placeholder file named .gitkeep. This will allow you to clean up unnecessary files while still preserving the folder structure in version control.

## 🚧 Setup and Configuration
In this section, you’ll set up all the foundational components required to run the project in dbt Cloud - including configuring Snowflake, creating a dbt Cloud account, and initializing a new dbt project.

### ❄️ Configure Snowflake for dbt Cloud
1. Connect to your Snowflake Account.
2. Ensure you have selected the `ACCOUNTADMIN` role to be able to create new roles and grant privileges.
3. Create a logical database in your data warehouse for this project. The database name used in this project is `dbt_analytics`. In this project, both the source tables and the model-generated tables/views are stored in the same database: dbt_analytics.  
```sql
CREATE DATABASE dbt_analytics;
```
3. Create a dedicated warehouse used for the transformation processes called `transforming`
```sql
CREATE WAREHOUSE analysing with WAREHOUSE_SIZE = 'SMALL';
```
4. Set up a role for you (as a developer) to access the warehouse and the database that you have created
```sql
CREATE ROLE analyser;
```
5. Grant the below privileges to the `analyser` role
```sql
GRANT usage ON DATABASE dbt_analytics TO ROLE analyser;
GRANT reference_usage ON DATABASE dbt_analytics TO ROLE analyser;
GRANT modify ON DATABASE dbt_analytics TO ROLE analyser;
GRANT monitor ON DATABASE dbt_analytics TO ROLE analyser;
GRANT create schema ON DATABASE dbt_analytics TO ROLE analyser;
```

> [!TIP]
> If the source tables were located in a different database, additional privileges would need to be granted to the `analyser` role to ensure it has access to that database. For example, if the source tables were saved under a database `source_db` schema `raw`, we should run the following commands.
> ```sql
> GRANT import privileges ON DATABASE source_db TO ROLE analyser;
> GRANT usage ON SCHEMA source_db.raw TO ROLE analyser;
> GRANT SELECT ON all tables IN SCHEMA source_db.raw TO ROLE analyser;
> ```

### ⚙️ Set up a dbt Cloud Account
Set up a dbt Cloud account if you don't have one already (if you do, just create a new project) and follow Step 4 in the [dbt-snowflake connection guide ](https://docs.getdbt.com/guides/snowflake/), to connect Snowflake to dbt Cloud. Make sure the user you configure for your connections has [adequate database permissions ](https://docs.getdbt.com/reference/database-permissions/about-database-permissions) to run dbt in the `dbt_analytics` database.

### 🔶 Create a New dbt Project
1. Name your project — Choose a meaningful name to identify your dbt project.
2. Configure your data warehouse — Select Snowflake as the warehouse and provide the required connection details:
   - Account
   - Database
   - Warehouse
   - Role
3. Connect your GitHub repository — Select the repository you created earlier to serve as the codebase for this dbt project.
4. Click on the 'Studio' button on the left bar. This will bring you into the dbt Cloud IDE, which is the browser-based editor that will enable you work on dbt models, seeds, macros, and other files. 
![image](https://github.com/user-attachments/assets/e4d3918e-edb4-4a78-9910-0803f41ee0dd)

✅ Now you should be ready to start the real work!

## 🚀 Project Execution Guide
This section provides a step-by-step guide to loading the datasets, transforming the raw data, and building models to extract meaningful insights.

### 📥 Load the Data








