CREATE PROCEDURE [Camp].[usp_UpdateNotificationsToUnread]
    @UserID INT
AS
BEGIN
    -- Update all notifications to unread (0) for the specified user
    UPDATE Notifications
    SET is_read = 0
    WHERE user_id = @UserID;
END;