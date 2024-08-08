CREATE TABLE [Camp].[User](
	[user_id] [smallint] IDENTITY(1,1) NOT NULL,
	[emp_id] [nvarchar](50) NOT NULL,
	[full_name] [nvarchar](50) NOT NULL,
	[email] [nvarchar](100) NOT NULL,
	[profile_url] [nvarchar](max) NULL,
	[designation_id] [tinyint] NOT NULL,
	[department_id] [tinyint] NOT NULL,
	[manager_id] [smallint] NULL,
	[last_login_date] [datetime] NULL,
	[last_updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_ACA.User_user_id] PRIMARY KEY CLUSTERED ([user_id] ASC),
 CONSTRAINT [FK_ACA.User_department_id] FOREIGN KEY([department_id]) REFERENCES [Camp].[Department] ([department_id]),
 CONSTRAINT [FK_ACA.User_designation_id] FOREIGN KEY([designation_id]) REFERENCES [Camp].[Designation] ([designation_id]),
 CONSTRAINT [FK_ACA.User_manager_id_FK] FOREIGN KEY([manager_id]) REFERENCES [Camp].[User] ([user_id])
);
GO

