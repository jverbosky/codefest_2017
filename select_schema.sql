select table_catalog, table_name, column_name, data_type
from information_schema.columns
where table_name = 'common'
or table_name = 'ind'
or table_name = 'ind_pda'