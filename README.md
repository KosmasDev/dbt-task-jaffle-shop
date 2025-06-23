# Customer Analytics with dbt Cloud - ***by Kosmas Strakosia***

## 📝 Introduction

This project is designed to help you explore the core functionality and key features of the dbt Cloud platform. It uses a fictional restaurant - the Jaffle Shop - as the basis for working with realistic, relatable data.

The purpose of this README is to guide you through:
- Setting up the project in dbt Cloud
- Loading the example datasets
- Performing data transformations
- Building models that can help uncover valuable insights into customer behavior and business performance

By the end of this project, you'll have hands-on experience with building a modern analytics workflow using dbt Cloud.

## 🔍 Customer Behavior Analysis

The objective of this project is to leverage dbt Cloud's capabilities to ingest, transform, and analyze customer and order data to answer key business questions related to customer engagement and loyalty. Specifically, the analysis focuses on the following insights:
- Which customer has visited more locations?
- List the most loyal customer per location.
- Has anyone ordered everything?

> [!NOTE]
> This document primarily focuses on the process of loading data and building models that can be used to generate valuable customer insights. It is **not intended as a detailed guide** for configuring the dbt-Snowflake connection or setting up a full dbt environment. Instead, it provides high-level setup instructions, along with links to official documentation for detailed guidance.

## 📘 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Initializing your repository – Create and Fork](#initializing-your-repository--create-and-fork)
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

## 🆕 Initializing your repository – Create and Fork

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
There are multiple ways to load the data for this project. Below, you’ll find the approach used in this setup, along with an alternative method you can consider.

> [!IMPORTANT]
> Seeds in dbt are static CSV files typically used to upload small reference datasets that support modeling workflows. In this project, seeds are leveraged as a convenient way to ingest sample data quickly. While this is not the primary purpose of seeds - ***since dbt is not designed as a data ingestion or loading tool*** - using seeds in this way allows us to focus on building and testing models without needing to set up a full external data pipeline. In the context of this project, we followed Approach 1.

#### 🗂️ Approach 1: Utilize the sample data in the repo
- To populate the source files located in `seeds/jaffle-data` as tables in Snowflake, we first need to configure the `dbt_project.yml` file, as shown in the screenshot below. In this file, we define the project name (`dbt_task_analytics`) and specify the target schema where the seed tables will be created — in this case, `raw`. Note that the database does not need to be defined in this file, as it is configured separately within the dbt Cloud connection settings. Please find the `dbt_project.yml` file [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/blob/dev/dbt_project.yml).
    
![image](https://github.com/user-attachments/assets/450aff5f-d014-4aab-b8f5-543534ff5cb8)
      
- Next, we need to run the following dbt command to generate the seed tables. Once executed successfully, the resulting tables will appear in Snowflake as shown in the screenshot below. 
```sql
dbt seed --full-refresh --vars '{"load_source_data": true}'
```

![image](https://github.com/user-attachments/assets/33c0e6fc-6cb7-49c0-8231-8c13ff601bfa)

You can notice that the schema name is not `raw` as defined in the `dbt_project.yml` file, but `dbt_kstrakosia_raw`. This happens because dbt cloud, unless configured otherwise, prefixes the schema with `dbt_<your-username>_ + <your-custom-schema>`. 

Before proceeding to the next step, ensure that the Snowflake tables have been successfully created and populated as expected.
```sql
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_customers;
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_items;
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_orders;
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_products;
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_stores;
SELECT * FROM dbt_analytics.dbt_kstrakosia_raw.raw_supplies;
```

#### 💾 Approach 2: Load the data from S3
- Set Up the Target Schema *(Define the schema that will house the source tables)*
```sql
CREATE SCHEMA dbt_analytics.dbt_kstrakosia_raw;
```

- Create Source Table Structures *(Initialize empty tables to receive the source data)*
Example for the `raw_orders` table.
```sql
CREATE OR REPLACE TABLE dbt_analytics.dbt_kstrakosia_raw.raw_orders
( id varchar(100),
  customer varchar(100),
  ordered_at TIMESTAMP_NTZ,
  store_id varchar(100),
  subtotal NUMERIC(10,2),
  tax_paid NUMERIC(10,2),
  order_total NUMERIC(10,2)
);
```

- Load Source Data from Amazon S3
Example for the `raw_orders` table.
```sql
COPY INTO dbt_raw.jaffle_shop.orders (
    id,
    customer_id,
    ordered_at,
    store_id,
    subtotal,
    tax_paid,
    order_total
    )
from 's3://dbt-tutorial-public/long_term_dataset/raw_orders.csv'
file_format = (
    type = 'CSV'
    field_delimiter = ','
    skip_header = 1
    );
```

The same process must be applied to all six tables involved in this project. Below are the URIs for each table that you will need to load into your raw schema.

| table name        | S3 URI                                                           | Direct Download Link                                                                                     | Schema                                                                                                    |
|-------------------|------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `raw_customers` | `s3://dbt-tutorial-public/long_term_dataset/raw_customers.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_customers.csv) | `(id text, name text)` |
| `raw_orders` | `s3://dbt-tutorial-public/long_term_dataset/raw_orders.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_orders.csv) | `(id text, customer text, ordered_at datetime, store_id text, subtotal int, tax_paid int, order_total int)` |
| `raw_order_items` | `s3://dbt-tutorial-public/long_term_dataset/raw_order_items.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_order_items.csv) | `(id text, order_id text, sku text)` |
| `raw_products` | `s3://dbt-tutorial-public/long_term_dataset/raw_products.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_products.csv) | `(sku text, name text, type text, price int, description text)` |
| `raw_supplies` | `s3://dbt-tutorial-public/long_term_dataset/raw_supplies.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_supplies.csv) | `(id text, name text, cost int, perishable boolean, sku text)` |
| `raw_stores` | `s3://dbt-tutorial-public/long_term_dataset/raw_stores.csv` | [Download](https://dbt-tutorial-public.s3.us-west-2.amazonaws.com/long_term_dataset/raw_stores.csv) | `(id text, name text, opened_at datetime, tax_rate float)` |

✅ With the setup complete, we’re ready to proceed to the next step.

### 🛠️ Develop Models
The `models` folder of the repo, holds all the SQL models we build, which define transformations and shape data in our warehouse. Usually, these models are split into different layers or folders to enforce modularity, clarity, and maintainability. In the screenshot below, you can see the data flow that visualises the connections of the models that will be created. 

![Screenshot 2025-06-23 221912](https://github.com/user-attachments/assets/e093b1e5-d1ef-4202-b353-1338f4ace26b)

#### 🏗️ Create Staging Layer Models
Staging models sit right on top of the raw data *(including source tables)*. They perform basic cleaning and normalization of source data. Raw source data is usually inconsistent or has unclear naming conventions. Staging creates a clean and reliable layer that downstream models can depend on without having to handle source inconsistencies each time.

- 🧰 Configure the dbt_project.yml file for Staging

sdf


- 🧭 Create the __sources.yml file

The `__sources.yml` file in the `models/staging` folder plays a very important role in how dbt connects to and tracks the raw data in the warehouse. It is a source declaration file that is used to "show" to dbt that the data already exist in the warehouse, in order for it to refer to this data as a trusted input in the models. 

This file allows dbt to:
1. Reference existing raw tables with the source() function
2. Track lineage from raw → staging → marts
3. Add documentation to raw tables
4. Enable testing and freshness checks

Below you can see the content of the file

```yml
version: 2

sources:
  - name: ecom
    schema: dbt_kstrakosia_raw
    description: E-commerce data for the Jaffle Shop
    tables:
      - name: raw_customers
        description: One record per person who has purchased one or more items
      - name: raw_orders
        description: One record per order (consisting of one or more order items)
        loaded_at_field: ordered_at
      - name: raw_items
        description: Items included in an order
      - name: raw_stores
        loaded_at_field: opened_at
      - name: raw_products
        description: One record per SKU for items sold in stores
      - name: raw_supplies
        description: One record per supply per SKU of items sold in stores
```


- 📝 Create staging SQL files

In this project, our primary focus within the staging models is to standardize and clarify column names—especially when original names lack clear context or meaning. Below is an example (`stg_orders.sql`) located in the `models/staging` folder, where we apply these naming improvements as part of the staging process. All the staging models pull data from the source tables saved in the `raw` schema. You can find all the staging .sql files [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/tree/dev/models/staging).

```sql
WITH 
source AS ( 
    SELECT * FROM {{ source('ecom', 'raw_orders') }}
),
renamed AS (
    SELECT 
        ID AS ORDER_ID,
        CUSTOMER AS CUSTOMER_ID,
        ORDERED_AT AS ORDER_DATE,
        STORE_ID AS LOCATION_ID,
        SUBTOTAL AS PRETAX_PRICE,
        TAX_PAID AS TAX,
        ORDER_TOTAL AS TOTAL_PRICE
    FROM
        source
)
SELECT * FROM renamed
```

- 📄 Create staging YAML files

The YAML files are model metadata files in the `models/staging` folder, and they are used in dbt to:
1. Document the models and columns by providing a human-readable description of what the model `stg_orders` represents and what each column means. Based on this YAML file the we can generate auto-docs in dbt Cloud using this metadata.
2. Define data quality tests.
3. Keep documentation and tests close to the logic. By putting stg_orders.yml next to stg_orders.sql, we keep everything related to that model tightly organized.
    - The SQL contains the logic
    - The YAML contains the metadata and validations

Below you can find the content of the `stg_orders.yml`. The quality tests are one of the most important parts of the file as we have defined that:
1. `order_id` must be not null and unique
2. `customer_id`, `location_id`, and `order_date` must all be not null
3. The following row-level expression must hold TRUE: `total_price - tax = pretax_price`
    
You can find all the staging .yml files [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/tree/dev/models/staging).

```yml
models:
  - name: stg_orders
    description: Order data with basic cleaning and transformation applied, one row per order.
    data_tests:
      - dbt_utils.expression_is_true:
          expression: "total_price - tax = pretax_price"
    columns:
      - name: order_id
        description: The unique key of the table (i.e. unique identifier for each order).
        data_tests:
          - not_null
          - unique
      - name: customer_id
        description: The unique identifier for each customer.
        data_tests:
          - not_null
      - name: location_id
        description: The unique identifier for each store location.
        data_tests:
          - not_null
      - name: order_date
        description: The date that each order was placed.
        data_tests:
          - not_null
```


- Lineage of the final model (the 3rd model is not included here as I have included it under the Analyses folder) 
![image](https://github.com/user-attachments/assets/d3def913-842b-4a80-97c8-17877bc59aa9)


