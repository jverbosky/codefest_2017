select municipality_name 
from common
left join ind on common.id = ind.common_id
left join ind_pda on common.id = ind_pda.common_id