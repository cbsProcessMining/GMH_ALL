/*
Please execute either the delta load extraction or the full load extraction data job together with the transformations data job. In the 'Scheduling' tab,
a schedule with multiple data jobs can be set up. The data jobs will be executed after each other and the next one will only start in case of successful
execution of the previous data job.

Differences between delta load extraction and full load extraction data jobs:
- In case a table (1) is joined to another table (2) during extraction, a filter on the last load date should be included to the joined table (2). 
  Otherwise a lot of chunks of the joined table (2) will not relate to any data of the extracted table (1) in the delta load, as the complete 
  table (2) gets joined on the filtered table (1), which leads to a decreased performance. Specifically the filter CHANGENR > '<%=cdposLastChangenr%>'
  is included in the delta load extraction, but not in the full load extraction (would lead to missing entries in the CDPOS for all full loads 
  after the initial full load).
- Delta load filter statements are only included in the delta load extraction data job (mentioned for the sake of completeness; 
  Filters on the 'Delta Filter Statement' section are only executed, when choosing 'Delta Load' for an execution of an extraction)
*/




