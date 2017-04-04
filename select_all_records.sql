select *
from common
join ind on common.id = ind.common_id
join ind_pda on common.id = ind_pda.common_id