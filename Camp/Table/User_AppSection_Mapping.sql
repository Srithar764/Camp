CREATE TABLE [Camp].[User_AppSection_Mapping](
	[user_appsection_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [smallint] NULL,
	[section_app_id] [int] NULL,
	[is_active] [bit] NULL,
	[last_updated_date] [datetime] NULL,
 PRIMARY KEY CLUSTERED ([user_appsection_id] ASC),
 CONSTRAINT [FK__User_AppSection__section_app_id] FOREIGN KEY([section_app_id])REFERENCES [Camp].[App_Section_Mapping] ([section_app_id]),
 CONSTRAINT [FK__User_AppSection__user_id] FOREIGN KEY([user_id])REFERENCES [Camp].[User] ([user_id])
)