drop table if exists blk_data
create table blk_data (
    AV_EAN bigint,            
    StoreNumberID int,              
    LocalReco decimal(10,2), 
    AppliedPrice decimal(10,2)
)


declare @file nvarchar(max) = 'DATA20241111'
declare @Date date = '2024-11-02';

declare @sql nvarchar(max) = '
bulk insert blk_data
from ''C:\Users\Axel\Downloads\Projet_SQL-main\' + @file + '.csv''
with (
    fieldterminator = '';'',
    rowterminator = ''\n'',
    firstrow = 2
)
'
exec(@sql)