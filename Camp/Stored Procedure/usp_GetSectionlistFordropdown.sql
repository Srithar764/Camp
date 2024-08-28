CREATE PROCEDURE [Camp].[usp_GetSectionlistFordropdown]
   
AS
BEGIN
    SET NOCOUNT ON;

	SELECT [section_id]
				,[section_name]
			FROM [Camp].[Section]
			where is_active =1
END;