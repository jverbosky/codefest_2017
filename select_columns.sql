select column_name
from information_schema.columns
where table_name = 'common'
or table_name = 'ind'