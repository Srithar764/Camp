CREATE PROCEDURE [Camp].[usp_MoveToSection]
    @sectionname VARCHAR(50),
    @appname VARCHAR(50)
AS
BEGIN
    DECLARE @newsectionid INT;
    DECLARE @appid INT;
    DECLARE @currentsectionid INT;
    DECLARE @section_app_id INT;
    DECLARE @new_section_app_id INT;

    -- Get the section_id of the new section
    SELECT @newsectionid = section_id
    FROM [Camp].[Section]
    WHERE section_name = @sectionname;

    -- Retrieve app_id if app exists
    IF EXISTS (SELECT 1 FROM [Camp].[App_Catalog] WHERE [app_name] = @appname)
    BEGIN
        SELECT @appid = [app_id]
        FROM [Camp].[App_Catalog]
        WHERE [app_name] = @appname;
    END

    -- Get the current section_id for the given app
    SELECT @currentsectionid = section_id
    FROM [Camp].[App_Section_Mapping]
    WHERE app_id = @appid AND is_active = 1;

    -- Deactivate the current mapping if it exists
    IF @currentsectionid IS NOT NULL
    BEGIN
        UPDATE [Camp].[App_Section_Mapping]
        SET is_active = 0
        WHERE section_id = @currentsectionid AND app_id = @appid;
    END

    -- Check if the new section_id and app_id combination exists in App_Section_Mapping
    SELECT @section_app_id = section_app_id
    FROM [Camp].[App_Section_Mapping]
    WHERE section_id = @newsectionid AND app_id = @appid;

    -- If the combination does not exist, create a new mapping
    IF @section_app_id IS NULL
    BEGIN
        INSERT INTO [Camp].[App_Section_Mapping] (section_id, app_id, last_updated_date, is_active)
        VALUES (@newsectionid, @appid, GETDATE(), 1); -- Assuming 1 means active

        -- Retrieve the newly created section_app_id
        SELECT @new_section_app_id = section_app_id
        FROM [Camp].[App_Section_Mapping]
        WHERE section_id = @newsectionid AND app_id = @appid AND is_active = 1;
    END
    ELSE
    BEGIN
        -- Update the existing mapping to active
        UPDATE [Camp].[App_Section_Mapping]
        SET is_active = 1, last_updated_date = GETDATE()
        WHERE section_app_id = @section_app_id;

        -- Set @new_section_app_id to the existing section_app_id
        SET @new_section_app_id = @section_app_id;
    END

    -- If the new section is inactive, make it active
    IF EXISTS (SELECT 1 FROM [Camp].[Section] WHERE section_id = @newsectionid AND is_active = 0)
    BEGIN
        UPDATE [Camp].[Section]
        SET is_active = 1
        WHERE section_id = @newsectionid;
    END

    -- Update User_AppSection_Mapping to reflect the new section_app_id
    UPDATE [Camp].[User_AppSection_Mapping]
    SET section_app_id = @new_section_app_id, last_updated_date = GETDATE()
    WHERE section_app_id IN (
        SELECT section_app_id
        FROM [Camp].[App_Section_Mapping]
        WHERE app_id = @appid AND section_id = @currentsectionid
    );

    -- If the current section becomes inactive due to no active app, make it inactive
    IF NOT EXISTS (
        SELECT 1
        FROM [Camp].[App_Section_Mapping]
        WHERE section_id = @currentsectionid AND is_active = 1
    )
    BEGIN
        UPDATE [Camp].[Section]
        SET is_active = 0
        WHERE section_id = @currentsectionid;
    END
END;
