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
1. [Prerequisites](#-prerequisites)
2. [Initializing your repository – Create and Fork](#-initializing-your-repository--create-and-fork)
    1. [Step 1: Create a new repository](#step-1-create-a-new-repository)
    2. [Step 2: Fork the jaffle shop project](#step-2-fork-the-jaffle-shop-project)
3. [Clean up the repository](#--clean-up-the-repository)
4. [Setup and Configuration](#-setup-and-configuration)
    1. [Configure Snowflake for dbt Cloud](#--configure-snowflake-for-dbt-cloud)
    2. [Set up a dbt Cloud Account](#--set-up-a-dbt-cloud-account)
    3. [Create a New dbt Project](#-create-a-new-dbt-project)

**---------- PROJECT EXECUTION STEPS ----------**

5. [Load the Data](#-load-the-data)
    1. [Approach 1 - Utilize the sample data in the repo](#-approach-1---utilize-the-sample-data-in-the-repo)
    2. [Approach 2 - Load the data from S3](#-approach-2---load-the-data-from-s3)
6. [Configure the dbt project yaml file](#-configure-the-dbt-project-yaml-file)
7. [Develop Models](#-develop-models)
    1. [Create Staging Layer Models](#-create-staging-layer-models)
        1. [Configure the dbt project yaml file for Staging](#-configure-the-dbt-project-yaml-file-for-staging)
        2. [Create the sources yaml file](#-create-the-sources-yaml-file)
        3. [Create staging SQL files](#-create-staging-sql-files)
        4. [Create staging YAML files](#-create-staging-yaml-files)
        5. [Test and Materialize the Staging Models](#-test-and-materialize-the-staging-models)
    2. [Create Marts Layer Models](#-create-marts-layer-models)
        1. [Configure the dbt project yaml file for Marts](#-configure-the-dbt-project-yaml-file-for-marts)
        2. [Create Marts SQL files](#-create-marts-sql-files)
        3. [Create Marts YAML files](#-create-marts-yaml-files)
        4. [Test and Materialize the Marts Models](#test-and-materialize-the-marts-models)
        5. [Insights](#-insights)
8. [Analyses](#-analyses)
    9. [Create SQL file in the Analyses folder](#-create-sql-file-in-the-analyses-folder)
    10. [Compile the Analyses SQL file](#-compile-the-analyses-sql-file)
    11. [Business Insights](#-business-insights)
9. [Create Custom Test](#-create-custom-test)
   


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

# 🚀 Project Execution Guide
This section provides a step-by-step guide to loading the datasets, transforming the raw data, and building models to extract meaningful insights.

## 📥 Load the Data
There are multiple ways to load the data for this project. Below, you’ll find the approach used in this setup, along with an alternative method you can consider.

> [!IMPORTANT]
> Seeds in dbt are static CSV files typically used to upload small reference datasets that support modeling workflows. In this project, seeds are leveraged as a convenient way to ingest sample data quickly. While this is not the primary purpose of seeds - ***since dbt is not designed as a data ingestion or loading tool*** - using seeds in this way allows us to focus on building and testing models without needing to set up a full external data pipeline. In the context of this project, we followed Approach 1.

### 🗂️ Approach 1 - Utilize the sample data in the repo
- To populate the source files located in `seeds/jaffle-data` as tables in Snowflake, we first need to configure the `dbt_project.yml` file, as shown in the screenshot below. In this file, we define the project name (`dbt_task_analytics`) and specify the target schema where the seed tables will be created — in this case, `raw`. Note that the database does not need to be defined in this file, as it is configured separately within the dbt Cloud connection settings. Please find the `dbt_project.yml` file [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/blob/dev/dbt_project.yml).

```yml
seeds:
  dbt_task_analytics:   # specify the project name
    +schema: raw        # Target schema
    jaffle-data:        # refers to the 'jaffle-data' folder
      +enabled: "{{ var('load_source_data', false) }}"  # Conditionally enables the seed based on the 'load_source_data' variable
                                                        # If 'load_source_data' is set to true, this seed will be loaded
```
      
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

### 💾 Approach 2 - Load the data from S3
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

✅ With the setup complete, you are ready to proceed to the development of the models.

## ⚙️ Configure the dbt project yaml file
The `dbt_project.yml` file is the central configuration file in the dbt project. It works as a "control panel" for how the dbt project behaves. 
It tells dbt:
- Where to find the models
- How to build them (as tables, views, etc.)
- What naming and folder conventions to follow
- Where to store the resulting tables in the data warehouse
- Which version of dbt will be used

It is important to configure it before starting the actual work because it ensures that we are not building your models in the wrong place, we apply consistent conventions across the project, and other team members understand the structure immediately. It is like setting up your project rules before you start writing the SQL.

The following is the `dbt_project.yml` file used in this project, along with simple comments to make the configuration easier to follow.

```yml
config-version: 2 # Specifies the version of the dbt config format.

name: dbt_task_analytics # The name of your dbt project.

version: "1.0.0" # Our versioning for the project (useful for tracking project evolution).

require-dbt-version: ">=1.5.0" # Ensures the project only runs with dbt version 1.5.0 or later to avoid compatibility issues.

dbt-cloud:
  project-id: 70471823480395 # The ID of your dbt Cloud project.

profile: default             # The name of the dbt profile that tells dbt how to connect to your data warehouse.

model-paths: ["models"] # Path to your model `.sql` files.
analysis-paths: ["analyses"] # Path for `.sql` files that are meant for analysis purposes.
test-paths: ["tests"] # Where dbt will look for custom data tests (in addition to standard schema.yml tests).
seed-paths: ["seeds"] # Folder containing the seed CSV files.
macro-paths: ["macros"] # Folder where the Jinja macros live.
snapshot-paths: ["snapshots"] # Folder where snapshot `.sql` files are stored (used for slowly changing dimension tracking).

target-path: "target" # Directory where dbt writes compiled SQL.

clean-targets: 
  - "target"  # These folder will be deleted when we run `dbt clean`. It removes compiled models to start fresh.

seeds:
  dbt_task_analytics:
    +schema: raw
    jaffle-data:
      +enabled: "{{ var('load_source_data', false) }}"

models:
  dbt_task_analytics:
    staging:
      +schema: dev
      +materialized: view
    marts:
      +schema: dev
      +materialized: table
```

## 🛠️ Develop Models
The `models` folder of the repo, holds all the SQL models we build, which define transformations and shape data in our warehouse. Usually, these models are split into different layers or folders to enforce modularity, clarity, and maintainability. In the screenshot below, you can see the data flow that visualises the connections of the models that will be created. 

![Screenshot 2025-06-23 221912](https://github.com/user-attachments/assets/e093b1e5-d1ef-4202-b353-1338f4ace26b)

### 🏗️ Create Staging Layer Models

Staging models sit right on top of the raw data *(including source tables)*. They perform basic cleaning and normalization of source data. Raw source data is usually inconsistent or has unclear naming conventions. Staging creates a clean and reliable layer that downstream models can depend on without having to handle source inconsistencies each time.

> [!NOTE]
> In well-structured dbt projects, the `models/` folder is organized into logical layers that reflect the stages of data transformation. This typically includes folders like `staging/`, where raw source data is cleaned and standardized; `intermediate/`, where more complex joins or business logic are applied; and `marts/`, which contains the final, business-ready models such as fact and dimension tables. Structuring models this way promotes clarity, reusability, and makes it easier for analysts/developers to debug issues and maintain a reliable analytics workflow over time.
>
> In the context of this project, only 2 layers have been created for simplicity (i.e. `staging` and `marts`).

#### 🧰 Configure the dbt project yaml file for Staging

We need to apply folder-level configuration for everything under `models/staging`. In this context, we need to define the target schema of the staging tables and the materialization type.

- **Target Schema**: For the `models`, we use a different schema from the one used for the raw tables. We use the `dev` schema.
- **Materialization** is how dbt physically creates your models in the data warehouse. In staging, we mainly clean up column names, cast data types, and create some times reusable logic. Hence, it's best practice to use the view materialization for these models, because they're simple, we want them to reflect the latest source data, and we don't need to store them as physical tables. The following code snippet is related only to the staging configurations. Please find the complete `dbt_project.yml` [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/blob/dev/dbt_project.yml).

```yml
models:
  dbt_task_analytics:           # This is the dbt "project" name
    staging:                    # This refers to the `models/staging` folder
      +schema: dev              # These models will be built in the "dev" schema
      +materialized: view       # These models will be materialized as views
```

#### 🧭 Create the sources yaml file

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


#### 📝 Create staging SQL files

In this project, our primary focus for the `staging` models is to standardize and clarify column names (*especially when original names lack clear context or meaning*). Below is an example (`stg_orders.sql`) located in the `models/staging` folder, where we apply these naming improvements as part of the staging process. All the staging models pull data from the source tables saved in the `raw` schema. You can find all the staging .sql files [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/tree/dev/models/staging).

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

#### 📄 Create staging YAML files

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

#### 🛢️ Test and Materialize the Staging Models

- First, you will need to run all the tests that have been defined in the `.yml` files. Please run the below command:

```CLI
dbt test
```

- If all the tests ran successfully, then you will need to materialize the Staging models. Please run the below command:

```CLI
dbt run
```

- Open the Snowflake UI *(or the UI of the warehouse that you are using)* and make sure that the Views have been created under the `dev` schema.

![image](https://github.com/user-attachments/assets/216bd257-212b-4d58-9ef5-0e403d94875c)

✅ With the staging views created in Snowflake, you’re now ready to proceed to the `marts` layer models.

### 📊 Create Marts Layer Models
In dbt projects, the `marts` folder contains the analytics-ready data models. These are the final tables that are used for business reporting (dashboards in BI tools), ad hoc analysis, and data products consumed by stakeholders. 


In well-structured dbt projects, the `models` folder should be divided into logical layers. In the context of this project, only 2 layers have been created for simplicity (i.e. `staging` and `marts`). Hence, the purpose of the `marts` layer is to translate raw and semi-processed data into a format that is easy to consume and aligned with business logic.

In this project, the `marts` folder contains the models (`.sql` and `.yml` files) that can be utilized by the business end-users to answer the following **business questions**:
- Which customer has visited more locations?
- Who is the most loyal customer per location?

> [!NOTE]
> Based on the way the third business question was phrased — ***"Has anyone ordered everything?"*** — it appears to be an **ad-hoc request**, requiring a **one-off analysis** rather than an ongoing or regularly refreshed report. Given this assumption, there is no need to create a reusable model under the `models/marts` directory. Instead, a standalone SQL file was added to the `analyses` folder to answer this specific question. More details about this file can be found in a later section.

### 🧰 Configure the dbt project yaml file for Marts

We need to apply folder-level configuration for everything under `models/marts`. In this context, we need to define the target schema of the staging tables and the materialization type.
- **Target Schema**: For the `models`, we use a different schema from the one used for the raw tables. We use the `dev` schema.
- **Materialization**: As mentioned in the previous section, `marts` host the final models that are used for business reporting (dashboards in BI tools), business analysis, and data products consumed by stakeholders. In this context, the `table` materialization is the most commonly used approach for these models because:
    - These models are queried frequently by BI tools or analysts, and materializing them as tables means that the data is precomputed and stored, leading to faster query response times.
    - Since they don’t change until the next `dbt run`, table models provide a stable dataset, which is important for consistency to avoid the risk of live changes mid-analysis *(which can happen with views)*.

Below, you can find the part of `dbt_project.yml` defining the target schema and the materialization. Please find the complete `dbt_project.yml` [here ](https://github.com/KosmasDev/dbt-task-jaffle-shop/blob/dev/dbt_project.yml).

```yml
models:
  dbt_task_analytics:            # This is the name of your dbt project or package
    marts:                       # Folder inside models/ (i.e., models/marts)
      +schema: dev               # Overrides default schema
      +materialized: table       # Sets materialization to 'table' for all models under marts/
```

### 📝 Create Marts SQL files

The models stored under the `models/marts` directory represent the final, curated datasets that are consumed by analysts and BI tools. These models are the core output of the dbt transformation process, as they apply business logic, metrics, and aggregations to generate meaningful insights. Designed to be clean and business-friendly to allow stakeholders to make informed decisions based on analytics-ready data.

In this project, 2 models have been created to answer the 2 business questions included in the [Create Marts Layer Models](#-create-marts-layer-models) section.

1. **Model 1** - Which customer has visited more locations?

*file name*: `customer_visited_most_locations.sql`
```sql
-- Step 1: Join three staging tables to enrich order data with customer and location details
WITH 
joined_tables AS (
    SELECT 
        ord.order_id,
        ord.order_date,
        ord.customer_id,
        cust.customer_name,
        ord.location_id,
        loc.location_name,
        loc.opening_date
    FROM {{ ref('stg_orders') }} AS ord  -- Reference to the staging orders model
    LEFT JOIN {{ ref('stg_customers') }} AS cust ON ord.customer_id = cust.customer_id  -- Enrich orders with customer info
    LEFT JOIN {{ ref('stg_locations') }} AS loc ON ord.location_id = loc.location_id    -- Enrich orders with location info
),

-- Step 2: Count how many *distinct* locations each customer has visited
customer_different_locations AS (
    SELECT 
        customer_id,
        customer_name, 
        COUNT(DISTINCT(location_id)) AS count_of_locations_visited 
    FROM joined_tables
    GROUP BY customer_id, customer_name
),

-- Step 3: Rank customers by the number of locations visited (descending order)
customers_ranked AS (
    SELECT 
        *, 
        RANK() OVER (ORDER BY count_of_locations_visited DESC) AS ranking
    FROM customer_different_locations
)

-- Step 4: Return the top-ranked customer(s) who have visited the most locations
SELECT 
    customer_id, 
    customer_name, 
    count_of_locations_visited
FROM customers_ranked
WHERE ranking = 1  -- Filters only the customer(s) with the highest number of locations visited
```


2. **Model 2** - Who is the most loyal customer per location?

*file name*: `most_loyal_customer_per_location.sql`
```sql
-- Step 1: Join orders, customers, and locations into a single enriched dataset
WITH 
joined_tables AS (
    SELECT 
        ord.order_id,
        ord.order_date,
        ord.customer_id,
        cust.customer_name,
        ord.location_id,
        loc.location_name,
        loc.opening_date
    FROM {{ ref('stg_orders') }} AS ord  -- Pull in orders data from staging
    LEFT JOIN {{ ref('stg_customers') }} AS cust ON ord.customer_id = cust.customer_id  -- Add customer details
    LEFT JOIN {{ ref('stg_locations') }} AS loc ON ord.location_id = loc.location_id    -- Add location details
),

-- Step 2: Count how many times each customer visited each location
loyal_customers AS (
    SELECT
        customer_id,  
        customer_name, 
        location_id, 
        location_name,
        COUNT(*) AS store_visits  -- Number of visits to the same store by the same customer
    FROM
        joined_tables
    GROUP BY customer_id, customer_name, location_id, location_name
    ORDER BY COUNT(*) DESC  -- (Optional) Just to preview the highest counts first
),

-- Step 3: Rank customers per location based on visit count
loyal_customers_ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY location_id 
            ORDER BY store_visits DESC
        ) AS ranking  -- Ranking within each location (1 = most visits)
    FROM loyal_customers
)

-- Step 4: Return only the most loyal customer (rank 1) per location
SELECT 
    customer_id, 
    customer_name,
    location_name,
    store_visits 
FROM loyal_customers_ranked
WHERE ranking = 1  -- Keep only top customers per location
```


### 📄 Create Marts YAML files

As described in a [previous](#-create-staging-yaml-files) section, the YAML files, under the `models` folder, are model metadata files. They are used in dbt to document the models and columns by providing a human-readable description, define data quality tests, and keep documentation and logic tightly organized under the same directory.

Below you can find the 2 `.yml` files created for the 2 above [models](#-create-marts-sql-files) stored in the `models/marts` folder. Please, use them as a guide and adjust them to your models.

1. **Model 1** - Which customer has visited more locations?

*file name*: `customer_visited_most_locations.yml`
```yml
models:
  - name: customer_visited_most_locations
    description: List of customers that have visited the most locations.
    columns:
      - name: customer_id
        description: The unique key for each customer.
        tests:
          - not_null
          - unique
      - name: customer_name
        description: The full name of each customer.
        tests:
          - not_null
      - name: count_of_locations_visited
        description: The number of distinct locations that the customer has visited.
        tests:
          - not_null
```

2. **Model 2** - Who is the most loyal customer per location?

*file name*: `ost_loyal_customer_per_location.yml`
```yml
models:
  - name: most_loyal_customer_per_location
    description: List of top customers per store location based on the number of visits..
    columns:
      - name: customer_id
        description: The unique key for each customer.
        tests:
          - not_null
          - unique
      - name: customer_name
        description: The full name of each customer.
        tests:
          - not_null
      - name: location_name
        description: The name of the store location.
        tests:
          - not_null
      - name: store_visits
        description: The number of times that the customer has visited the store.
        tests:
          - not_null
```

### 🛢️ Test and Materialize the Marts Models

- First, you will need to run all the tests that have been defined in the `.yml` files. Please run the following command:

```CLI
dbt test
```

- If all the tests ran successfully, then you will need to materialize the Staging models. Please run the below command:

```CLI
dbt run
```

- Open the Snowflake UI *(or the UI of the warehouse that you are using)* and make sure that the Tables have been created under the `dev` schema.

![image](https://github.com/user-attachments/assets/998363cd-719c-40f8-81f0-e8cbcbb09060)

✅ With the `marts` tables created in Snowflake, you’re now ready to analyse the outcomes of the models and get business insights.

### 🔍 Business Insights

Since one of the main goals of this project is to gain some meaningful insights from the available data and answer [specific business questions](#-create-marts-layer-models), as the next step, we need to use the 2 tables created in the `dev` schema in Snowflake and just run s `SELECT *` command.

- Which customer has visited more locations?
```sql
SELECT * FROM DBT_ANALYTICS.DBT_KSTRAKOSIA_DEV.CUSTOMER_VISITED_MOST_LOCATIONS;
```
The above table contains a list of the customers ranked by count of unique locations that they have visited. In this case, no customer has visited more than 1 store, and subsequently we have a tie between multiple customers. Please find the results below. 

![image](https://github.com/user-attachments/assets/c810abe6-5b97-4f24-8830-9730782fe3d5)

- Who is the most loyal customer per location?
```sql
SELECT * FROM DBT_ANALYTICS.DBT_KSTRAKOSIA_DEV.MOST_LOYAL_CUSTOMER_PER_LOCATION;
```
The above table contains the list of the customers who have visited a specific location the most times *(***i.e.*** loyal customers)*. In this case, there is no tie between the customers. Please find the results below. 

![image](https://github.com/user-attachments/assets/6f8dace6-63b6-43e1-a5e3-74ee31de0a5b)

## 📊 Analyses

As mentioned in a previous section's [Notes](#-create-marts-layer-models), the `analyses/` directory is where we store ad-hoc SQL analyses that are not part of your dbt model pipeline, but still benefit from being version-controlled, documented, and re-usable within the project context. Hence, the purpose of the `analyses/` directory is to store exploratory SQL queries using {{ ref() }} and {{ source() }} safely, and keep analytical SQL logic organized and reusable, without the need to dig through multiple SQL files.

## 📈 Create SQL file in the Analyses folder

In the context of this project, an SQL file was created under the `analyses/` folder to help business users determine whether any customer has ever ordered all the unique products available in the store. The query below directly answers the business question: "**Has anyone ordered everything?**" by returning a simple '**YES**' or '**NO**'. If more detailed insights are needed (*such as a list of customers who meet this criterion or the exact number of such customers*) the query can be easily adjusted to return those results as well.

*file name*: `customer_ordered_everything.sql`
```sql
-- Step 1: Get the total number of unique products in the dataset
WITH 
total_distinct_products AS (
  SELECT
    COUNT(DISTINCT(product_id))  -- Count of all distinct products ever ordered
  FROM
    {{ ref('stg_order_items') }}  -- Refers to the staging table of order items
),

-- Step 2: Count how many unique products each customer has ordered
customer_orders AS (
  SELECT
    ord.customer_id,
    COUNT(DISTINCT oi.product_id) AS count_product_id  -- Count of unique products per customer
  FROM
    {{ ref('stg_order_items') }} AS oi 
    JOIN {{ ref('stg_orders') }} AS ord ON ord.order_id = oi.order_id
    JOIN {{ ref('stg_customers') }} AS cust ON ord.customer_id = cust.customer_id
  GROUP BY
    ord.customer_id  -- Grouping by customer to calculate per-customer product count
),

-- Step 3: Filter only those customers who ordered ALL available products
customers_order_everything AS (
  SELECT
    cust.customer_id,
    cust.customer_name,
    co.count_product_id
  FROM
    customer_orders AS co
    JOIN {{ ref('stg_customers') }} AS cust ON co.customer_id = cust.customer_id
  WHERE 
    co.count_product_id = (SELECT * FROM total_distinct_products)  
    -- Keeps only customers whose product count matches the total available products
)

-- Step 4: Final output: Has at least one customer ordered all products?
SELECT 
  CASE 
    WHEN COUNT(*) > 0 THEN 'YES' 
    ELSE 'NO' 
  END AS HAS_ANYONE_ORDER_EVERYTHING  -- Outputs a single row: YES or NO
FROM
  customers_order_everything  -- If this table has rows, someone ordered everything
```

### 🛢️ Compile the Analyses SQL file

In contrast to the sql files stored under the `models/` directory (*which get materialized when running the `dbt run` command*), the files stored in the `analyses/` folder do not get materialized in the warehouse, but they just get compiled and stored under the `target/compiled/<your_dbtcloud_project_name>/analyses` directory. Hence, after generating the sql file in the `analyses/` folder, we need to run the following command to compile it and be able to use it in the Snowflake UI. 

```CLI
dbt compile
```

The above command compiles all the files. If you want to specify the file to be compiled, then you can run the following command.

```CLI
dbt compile --select path:analyses/customer_ordered_everything.sql
```

Now the files should be compiled and stored here:

![image](https://github.com/user-attachments/assets/74278b63-5ffa-41d8-b930-41f254221d3a)

✅ With the SQL file created under the `analyses/` folder and the compiled files stored in the `target/compiled/<your_dbtcloud_project_name>/analyses` directory, you’re now ready to get the required business insights.

### 🔍 Business Insights

In order to get the expected business insight, we need to `copy` the compiled SQL file from the `target/compiled/<your_dbtcloud_project_name>/analyses` directory and run it in the Snowflake UI. Below you can find the result of the SQL query. If more detailed insights are needed (*such as a list of customers who meet this criterion or the exact number of such customers*) the query can be easily adjusted to return those results as well.

![image](https://github.com/user-attachments/assets/3ac6d0ff-3e35-40d1-9f80-2d34ea786497)

## 🧪 Create Custom Test

In the context of a debt workflow, tests are a way to validate the data. They ensure our assumptions hold true - like checking that a primary key is unique or that a foreign key relationship is respected. There are 2 categories of Tests:
- **Generic (built-in)** tests like `unique`, `not_null`, `accepted_values`
- **Custom (user-defined)** tests, which are SQL queries that we write, typically stored under the tests/ directory

The Tests are stored 


- Lineage of the final model (the 3rd model is not included here as I have included it under the Analyses folder) 
![image](https://github.com/user-attachments/assets/d3def913-842b-4a80-97c8-17877bc59aa9)


