# Building ELT data pipelines with Airflow for Airbnb and Census 
 
## Introduction
This project aims to create and set up robust ELT (Extract, Load, Transform) data pipelines with Apache Airflow and dbt Cloud, focusing on processing and analysing Airbnb and Census data for Sydney. This project responds to the increasing demand for making informed decisions in the hospitality and urban planning fields, helping us better grasp the interplay between rental markets and demographic influences.
The project involved several key steps that will be discuused below. Some of them are data integration and ingestion, data transformation and warehousing, automation and orchestration, business analysis and insights.
## Data integration and ingestion
The integration and ingestion of data are essential parts of the project, creating the groundwork for the analyses and insights that follow. This process includes gathering information from different sources, making necessary adjustments, and storing it in a central data warehouse for deeper analysis. Here’s a comprehensive overview of how this process unfolds within the project:

## Data Sources
- The Airbnb dataset offers a comprehensive look at short-term rental listings in Sydney, which is crucial for grasping the details of the market dynamics. Important features consist of Listing ID, acting as a unique identifier; Listing Neighbourhood, showing the geographical area; Property Type, classifying the types of accommodations; Room Type, differentiating between entire homes, private rooms, and shared spaces; Accommodates, indicating how many guests can stay; and Price, representing the nightly cost. The dataset covers the time frame from May 2020 to April 2021, providing a detailed perspective on rental activity throughout those months.
- The Census data provides valuable demographic insights that are particularly relevant to the Greater Sydney area. Important aspects consist of the LGA (Local Government Area) Code, which serves as a distinct identifier for every LGA, along with demographic details like age distribution and household size. This information aids in understanding how rental performance connects with the demographics of the area. The Census data utilised comes from the 2016 Census, offering vital insights into the Airbnb market.
 
 
We brought the datasets together using LGA codes to allow for insightful analysis. This process included linking local government areas to suburbs, enabling a comprehensive analysis of the Airbnb data in conjunction with pertinent demographic information. In the data warehouse, we established SQL views to simplify access and querying. This setup empowers the project to tackle important business questions about demographic variations and rental performance, ultimately providing valuable insights for stakeholders in the Sydney rental market.
- <img width="370" alt="image" src="https://github.com/user-attachments/assets/a310c4a8-d063-45a9-8278-82d957f9d838" />

## Project Methodology and Implementation Steps
### Environment Setup
To kick off the project, we started by setting up an environment in Google Cloud Platform (GCP) that would enable us to run Apache Airflow for orchestration and PostgreSQL for data storage. Google Cloud Composer was chosen as the managed service for Airflow, offering a strong framework for scheduling and executing data workflows. A PostgreSQL instance was set up to function as the data warehouse, serving as a repository for both raw and transformed data. This setup made sure that we had all the right resources in place to handle the large datasets linked to the Airbnb and Census data for Sydney.
 - <img width="496" alt="image" src="https://github.com/user-attachments/assets/8c49c7fb-ed5c-4e2f-a75b-7589f3251a25" />

 
### Data Ingestion with Airflow
After setting up the environment, the next step was to create an Airflow Directed Acyclic Graph (DAG) to help bring raw data into the PostgreSQL database. The DAG was crafted without a fixed schedule interval (schedule_interval=None), enabling the manual execution of data ingestion tasks whenever needed. We used Python operators to access the raw data files stored in Google Cloud Storage (GCS) and seamlessly load them into the Bronze schema of our PostgreSQL database. A Python function made it easier to manage data transformation during the loading process, enabling the data to flow smoothly into the right tables. Every task in the DAG was carefully defined to guarantee that they execute in sequence, preserving the integrity and order of the data loading process.
 - <img width="456" alt="image" src="https://github.com/user-attachments/assets/67315faf-6031-4b45-b06c-609d5a5c597f" />

Initially, the data was loaded for 05_2020.csv and census and lga data only.
 - <img width="217" alt="image" src="https://github.com/user-attachments/assets/8ced7f98-b31c-4654-a156-40f6d2a213be" />

 
After dbt was setup, the entire data was loaded through dbt jobs and DAG.
 - <img width="290" alt="image" src="https://github.com/user-attachments/assets/6eeb7b83-e201-4f96-95ff-47ec15020f65" />


### Data Transformation with dbt
After successfully ingesting the raw data, the next step was to transform it into structured formats using dbt (data build tool). The transformation process utilised a Medallion architecture with three distinct layers: Bronze, Silver, and Gold. The Bronze layer held the original raw tables, whereas the Silver layer featured the cleaned and transformed versions of these tables, all organised with consistent naming conventions. Important changes involved setting up dimension tables for Airbnb listings and host details, along with snapshots to monitor historical data changes. The Gold layer set up a star schema with dimension and fact tables, making it easier to query and analyse data effectively. Every dbt model was carefully crafted to guarantee that the data aligned with the needs of the upcoming analysis tasks. Along with that, snapshots were created to capture changes based on timestamp strategy.
- <img width="327" alt="image" src="https://github.com/user-attachments/assets/22cf1c64-c407-4e50-b7ef-6142e37404b7" />
- <img width="80" alt="image" src="https://github.com/user-attachments/assets/a30ababe-2059-4f7a-85d6-392aaceb5933" />
- <img width="269" alt="image" src="https://github.com/user-attachments/assets/9ac6d6fc-55bc-4d9a-9a5f-b84f91630da1" />


 	 

### Data mart creation
The last part of the transformation was about building a data mart to help with analytical queries. This data mart was built from the Gold layer of the data warehouse, thoughtfully crafted to deliver insights that address the key business questions highlighted in the assignment. The data mart featured views that brought together information by showcasing neighbourhoods, property types, and host details, allowing for a thorough exploration of the Airbnb dataset. By arranging the data in a way that makes it easy to report and analyse, the data mart became an essential tool for addressing the business questions raised in the assignment.
 - <img width="204" alt="image" src="https://github.com/user-attachments/assets/743bd827-f2a4-46d2-84fa-77b6a84284dd" />

 
### Ad-hoc Analysis
The project wrapped up with some targeted analyses to tackle particular business questions. We developed SQL queries to uncover valuable insights from the data mart, paying special attention to the demographic variations across LGAs, the relationships between median age and revenue, and how different listing types performed. We ran each query on PostgreSQL and took the time to analyse the results, allowing us to uncover valuable insights that could drive our decisions. This analysis highlighted how well the data pipeline worked during the project and offered insightful recommendations for shaping business strategy and making informed decisions.

## Issues Faced and Solutions
While working on the project, there were a few problems that needed careful solutions:
- Technical issues
The integration between Apache Airflow and dbt Cloud was faced with a significant challenge. Initially, issues with task dependencies in the Airflow DAG were encountered, leading to failures in the execution of data loading tasks. To resolve this, careful attention was given to the task dependencies, ensuring that each step of the pipeline was correctly sequenced. The implementation of logging was beneficial in tracking the execution flow and identifying bottlenecks.
- Environment Setup and Budget Constraints:
The GCP environment was set up with some initial hurdles, particularly with the configuration of Cloud Composer for Airflow and the correct linking of the Postgres database. The setup issues were navigated with the help of detailed documentation provided by Google Cloud. Unfortunately, it was found that the free credit for GCP had ended during the project, which led to the necessity of a complete redo of the entire project. The environment was required to be re-established, and all data ingestion and transformation processes were re-run, which added considerable time to the overall project timeline.
- Data quality issues
During the processing of the datasets, discrepancies were identified in the Airbnb data, including missing values in important columns such as HOST_ID and PRICE. To address these issues, data cleaning procedures were implemented, which included the filling of missing values where feasible and the removal of rows with critical missing data to ensure the integrity of the analyses. These adjustments were facilitated by the use of SQL functions such as COALESCE and NULLIF.

## Business Questions
- “What are the demographic differences (e.g., age group distribution, household size) between the top 3 performing and lowest 3 performing LGAs based on estimated revenue per active listing over the last 12 months?”
 
The analysis revealed that the top performing LGAs include Randwick, Mosman, and Sydney, while the lowest performing LGAs are Burwood, Strathfield, and Hunters Hill. This information is crucial for understanding the demographic profiles of these regions.
<img width="468" alt="image" src="https://github.com/user-attachments/assets/c884e871-a80f-482f-8102-7ff2dc20d4aa" />


















- “What will be the best type of listing (property type, room type and accommodates for) for the top 5 “listing_neighbourhood” (in terms of estimated revenue per active listing) to have the highest number of stays?”

<img width="468" alt="image" src="https://github.com/user-attachments/assets/b947aa52-d513-4f6c-8785-e1c546cf148c" />




In the analysis of the best type of listing for maximizing stays in the top five neighborhoods ranked by estimated revenue per active listing, it was found that "Entire Apartment" listings consistently performed well. Notably, Waverley emerged as the top performer with 312,837 stays, followed by Mosman and Northern Beaches, indicating a strong preference for entire home accommodations among guests. This suggests that hosts in these neighborhoods should prioritize offering entire apartments, particularly those that accommodate more guests, to enhance occupancy rates and attract more bookings.
-	“For hosts with multiple listings, are their properties concentrated within the same LGA, or are they distributed across different LGAs?”
 
In the analysis of host distribution for those with multiple Airbnb listings, it was found that a significant majority of hosts have their properties concentrated within the same Local Government Area (LGA). Specifically, 29,329 hosts were identified as having multiple listings concentrated in the same LGA, which collectively accounted for a total of 371,664 listings. Conversely, a smaller group of 1,762 hosts had their properties distributed across different LGAs, with a total of 73,137 listings. This indicates that the majority of Airbnb hosts tend to focus their rental activities within specific regions, potentially maximizing their local market knowledge and operational efficiency.

<img width="468" alt="image" src="https://github.com/user-attachments/assets/f31cc6e7-4295-4e04-b6ce-e8694e254cbf" />


## Conclusion
The successful demonstration of this project showcases the creation of effective ELT data pipelines through the use of Apache Airflow and dbt Cloud, with a focus on Airbnb and Census data for Sydney. Valuable insights into rental trends and demographic influences were gained by transforming and processing these datasets into a well-structured data warehouse.
Key differences between the top-performing and lowest-performing Local Government Areas (LGAs) were revealed through the analysis, with important characteristics of successful property listings being highlighted. It was discovered that certain types of accommodations, such as entire apartments, are significantly more attractive to guests, offering actionable insights for hosts.
Throughout the project, challenges were faced, particularly with data quality and integration, highlighting the importance of thorough cleaning and validation. The future work will be guided by these lessons, and improvements in data management practices will be achieved.
Ultimately, it is shown how insights driven by data can enhance decision-making in the hospitality industry and urban planning. The findings are regarded as a strong foundation for continued analysis and strategic development in understanding Sydney's rental market.
