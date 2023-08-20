# Advanced-Data-Management---D191
Final project for WGU's D191 class.

## INTRODUCTION
Data analysts frequently transform data within a database so that it can be used for analysis and so that the data will be easier for nontechnical users to use and understand. You will emulate such a process in this task by choosing your own business question to analyze, creating tables and queries to use as a business report, and streamlining your analysis by writing your own SQL functions, triggers, and stored procedures.

This task defines a report as a collection of data that answers a real-world business question. Your report will have two distinct sections (SQL tables that you will create) that differ in the granularity of the data they present and how directly they support the answering of the business question you choose. The detailed table should contain all data that informs the answer to the question at a very granular level, and the summary table should contain aggregated data that provide a direct answer to the business question.

## REQUIREMENTS
Your submission must be your original work. No more than a combined total of 30% of the submission and no more than a 10% match to any one individual source can be directly quoted or closely paraphrased from sources, even if cited correctly. The similarity report that is provided when you submit your task can be used as a guide.

You must use the rubric to direct the creation of your submission because it provides detailed criteria that will be used to evaluate your work. Each requirement below may be evaluated by more than one rubric aspect. The rubric aspect titles may contain hyperlinks to relevant portions of the course.

Tasks may not be submitted as cloud links, such as links to Google Docs, Google Slides, OneDrive, etc., unless specified in the task requirements. All other submissions must be file types that are uploaded and submitted as attachments (e.g., .docx, .pdf, .ppt).

To work on this task, use the “Labs on Demand Assessment Environment and DVD Database” found in the Web Links section. In this environment, you will be able to write and test your PostgreSQL code and access the database to complete this task.

Plan for and compose the sections of a real-world business report that can be created from the "Labs on Demand Assessment Environment and DVD Database" web link, and demonstrate the functionality of the supporting SQL code by doing the following:

### A.
Summarize one real-world written business report that can be created from the DVD Dataset from the “Labs on Demand Assessment Environment and DVD Database” attachment.

1.  Identify the specific fields that will be included in the detailed table and the summary table of the report.

2.  Describe the types of data fields used for the report.

3.  Identify at least two specific tables from the given dataset that will provide the data necessary for the detailed table section and the summary table section of the report.

4.  Identify at least one field in the detailed table section that will require a custom transformation with a user-defined function and explain why it should be transformed (e.g., you might translate a field with a value of N to No and Y to Yes).

5.  Explain the different business uses of the detailed table section and the summary table section of the report.

6.  Explain how frequently your report should be refreshed to remain relevant to stakeholders.


### B.
Provide original code for function(s) in text format that perform the transformation(s) you identified in part A4.


### C.
Provide original SQL code in a text format that creates the detailed and summary tables to hold your report table sections.


### D.
Provide an original SQL query in a text format that will extract the raw data needed for the detailed section of your report from the source database.


### E.
Provide original SQL code in a text format that creates a trigger on the detailed table of the report that will continually update the summary table as data is added to the detailed table.


### F.
Provide an original stored procedure in a text format that can be used to refresh the data in both the detailed table and summary table. The procedure should clear the contents of the detailed table and summary table and perform the raw data extraction from part D.

1.  Identify a relevant job scheduling tool that can be used to automate the stored procedure.


### G.
Provide a Panopto video recording that includes the presenter and a vocalized demonstration of the functionality of the code used for the analysis.

Note: For instructions on how to access and use Panopto, use the "Panopto How-To Videos" web link provided below. To access Panopto's website, navigate to the web link titled "Panopto Access," and then choose to log in using the “WGU” option. If prompted, log in using your WGU student portal credentials, and then it will forward you to Panopto’s website.

To submit your recording, upload it to the Panopto drop box titled “Advanced Data Management D191 | D326 (Student Creators) [assignments].” Once the recording has been uploaded and processed in Panopto's system, retrieve the URL of the recording from Panopto and copy and paste it into the Links option. Upload the remaining task requirements using the Attachments option.


### H.
Acknowledge all utilized sources, including any sources of third-party code, using in-text citations and references. If no sources are used, clearly declare that no sources were used to support your submission.


### I.
Demonstrate professional communication in the content and presentation of your submission.