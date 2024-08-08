CREATE PROCEDURE [Camp].[InsertUsersFromStaging]
AS
BEGIN
    SET NOCOUNT ON;

--Inserting Department

MERGE Camp.Department AS Target
USING dbo.Employee As Source
ON Target.name = Source.Department
WHEN NOT MATCHED THEN
 INSERT ([name]) Values (source.Department);

-- Inserting Designation
MERGE Camp.Designation AS Target
USING dbo.Employee As Source
ON Target.title = Source.Designation
WHEN NOT MATCHED THEN
 INSERT (title) Values (source.Designation);

-- CTE to prepare the staging data with department and designation information
    WITH StagingData AS (
        SELECT 
            se.Emp_id,
            se.[full_name],
            se.[Email] AS email,
            dp.department_id,
            ds.designation_id,
            us.user_id AS manager_id,
            [last_login_date],
			--CASE WHEN se.[full_name] = se.[Manager] THEN 0 ELSE 0 END AS is_self_manager,
			se.[last_updated_date]
        FROM
            dbo.employee se
        JOIN
            Camp.Department dp ON se.[Department] = dp.name 
        JOIN
            Camp.Designation ds ON se.Designation = ds.title
        LEFT JOIN
            Camp.[User] us ON se.Manager = us.full_name
    )

    -- Merge data from StagingData into User table
    MERGE Camp.[User] AS target
    USING StagingData AS source
    ON target.emp_id = source.emp_id
    WHEN NOT MATCHED THEN
        INSERT 
		(
		[emp_id],
		[full_name], 
		[email], 
		[department_id],
		[designation_id],
		[manager_id],
		[last_login_date],
		[last_updated_date]
		)
        VALUES (
		source.emp_id, 
		source.full_name,
		source.email,
		source.department_id,
		source.designation_id, 
		source.Manager_id,
        --CASE WHEN source.is_self_manager = 1 THEN NULL ELSE source.manager_id END,
		source.[last_login_date],
		GETDATE()
		)
    WHEN MATCHED THEN
        UPDATE SET
            target.full_name = source.full_name,
            target.email = source.email,
            target.department_id = source.department_id,
            target.designation_id = source.designation_id,
			target.manager_id = source.manager_id,
           -- target.manager_id = CASE WHEN source.is_self_manager = 1 THEN NULL ELSE source.manager_id END,
            target.last_login_date = source.[last_login_date],
            target.last_updated_date = GETDATE()
   WHEN  NOT MATCHED BY SOURCE
		THEN DELETE ;

END
