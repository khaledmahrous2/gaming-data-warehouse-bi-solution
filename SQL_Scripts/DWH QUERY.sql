USE [DWH]
GO

/****** Object:  StoredProcedure [dbo].[user_info]    Script Date: 6/1/2026 3:46:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[user_info]
AS
BEGIN


INSERT INTO [DWH].[dbo].[DIM_USER_info]([user_id]
      ,[USER_NAME]
      ,[STATUS]
      ,[EMAIL]
      ,[PHONE]
      ,[CREATED_AT]
      ,[city_name]
      ,[state_name]
      ,[country_name]
      ,[region])

    SELECT [user_id]
      ,[USER_NAME]
      ,[STATUS]
      ,[EMAIL]
      ,[PHONE]
      ,[CREATED_AT]
      ,[city_name]
      ,[state_name]
      ,[country_name]
      ,[region]
      FROM [STG].[dbo].[USER_info]

      END;
GO


CREATE PROCEDURE [dbo].[PAYMENT_METHOD]
AS
BEGIN


INSERT INTO [DWH].[dbo].[DIM_PAYMENT_METHOD] ([payment_method])
SELECT [payment_method] 
FROM [STG].[dbo].[PAYMENT_METHOD]

END;

GO


CREATE PROCEDURE [dbo].[GAME_DETAILS]
AS
BEGIN


INSERT INTO [DWH].[dbo].[DIM_GAME_DETAILS] ([game_id]
      ,[game_name]
      ,[price]
      ,[discount_percentage]
      ,[tax_percentage]
      ,[release_date]
      ,[platform]
      ,[rating]
      ,[GENRE])
SELECT [game_id]
      ,[game_name]
      ,[price]
      ,[discount_percentage]
      ,[tax_percentage]
      ,[release_date]
      ,[platform]
      ,[rating]
      ,[GENRE]
FROM [STG].[dbo].[GAME_DETAILS]
END;
GO
CREATE PROCEDURE [dbo].[fact_trophies_1]
AS
BEGIN
    

    DECLARE @LastDate DATE;

    SELECT @LastDate = ISNULL(MAX(d.DATE), '1900-01-01')
    FROM [DWH].[dbo].[TROPHYES] f
    JOIN [DWH].[dbo].[DIM_DATE] d
        ON f.[DATA_SK] = d.DATA_SK;

    
     INSERT INTO [DWH].[dbo].[TROPHYES]([GAME_SK],
     [user_SK],
      [DATA_SK],
     [trophy_TYPES_SK])
    SELECT 
        g.game_sk,
        u.user_sk,
        dt.DATA_SK,
        T.TROPHY_SK
    FROM [STG].[dbo].[TROPHIES] s
    JOIN [STG].[dbo].[GAME_DETAILS] g 
        ON s.game_id = g.game_id
    JOIN [STG].[dbo].[USER_info] u 
        ON s.user_id = u.user_id
    JOIN [STG].[dbo].[DATE] dt 
        ON s.[earned_date] = dt.DATE
    JOIN [STG].[dbo].[TROPHY_TYPES] T
        ON S.trophy_name =T.TROPHY_NAME
        AND S.trophy_type = T.TROPHY_TYPE
    WHERE dt.DATE >= @LastDate
    AND NOT EXISTS (
        SELECT 1
        FROM [DWH].[dbo].[TROPHYES] f
        WHERE f.DATA_SK = dt.DATA_SK
          AND f.user_SK = u.user_sk
          AND f.GAME_SK = g.game_sk
          AND f.trophy_TYPES_SK = T.TROPHY_SK
        
    );

END;

GO
CREATE PROCEDURE [dbo].[DWH_fact_orders]
AS
BEGIN

    DECLARE @LastDate DATE;

    SELECT @LastDate = ISNULL(MAX(d.DATE), '1900-01-01')
    FROM [DWH].[dbo].[FACT_ORDERS] f
    JOIN [DWH].[dbo].[DIM_DATE] d
        ON f.DATE_SK = d.[DATA_SK];

    INSERT INTO [DWH].[dbo].[FACT_ORDERS] (
        order_ID,
        user_SK,
        game_SK,
        DATE_SK,
        quantity,
        discount_amount,
        tax_amount,
        total_amount,
        is_refunded,
        refund_date,
        payment_method_SK
    )
    SELECT 
        s.order_ID,
        u.user_sk,
        g.game_sk,
        dt.[DATA_SK],
        s.quantity,
        s.discount_amount,
        s.tax_amount,
        s.total_amount,
        s.is_refunded,
        s.refund_date,
        p.[payment_SK]
    FROM [STG].[dbo].[ORDERS] s
    JOIN [STG].[dbo].[USER_info] u 
        ON s.user_id = u.user_id
    JOIN [STG].[dbo].[GAME_DETAILS] g 
        ON s.game_id = g.game_id
    JOIN [STG].[dbo].[DATE] dt 
        ON s.order_date = dt.DATE
    JOIN [STG].[dbo].[PAYMENT_METHOD] p
        ON s.payment_method = p.payment_method
    WHERE dt.DATE >= @LastDate   -- 🔥 أهم تعديل
    AND NOT EXISTS (
        SELECT 1
        FROM [DWH].[dbo].[FACT_ORDERS] f
        WHERE f.order_ID = s.order_ID
    );

END;
GO
CREATE PROCEDURE [dbo].[DWH_fact_gameplay]
AS
BEGIN
    

    DECLARE @LastDate DATE;

   
    SELECT @LastDate = ISNULL(MAX(d.DATE), '1900-01-01')
    FROM [DWH].[dbo].[FACT_GAMEPLAY] f
    JOIN [DWH].[dbo].[DIM_DATE] d
        ON f.DATA_SK = d.DATA_SK;

   
    INSERT INTO [DWH].[dbo].[FACT_GAMEPLAY] (
        [DEVICE_KEY],
        [user_SK],
        [DATA_SK],
        [GAME_SK],
        [TOTAL_HOURS_PLAYED],
        [TROPHIES_COUNT]
    )
    SELECT 
        d.device_key,
        u.user_sk,
        dt.[DATA_SK],
        g.game_sk,
        s.TOTAL_HOURS_PLAYED,
        s.TROPHIES_COUNT
    FROM [STG].[dbo].[GAME_PLAY] s
    JOIN [STG].[dbo].[DEVICE] d ON s.[DEVICE] = d.[DEVICE_TYPE]
    JOIN [STG].[dbo].[USER_info] u ON s.user_id = u.user_id
    JOIN [STG].[dbo].[GAME_DETAILS] g ON s.game_id = g.game_id
    JOIN [STG].[dbo].[DATE] dt ON s.DATE = dt.DATE
    WHERE dt.DATE >= @LastDate
    AND NOT EXISTS (
        SELECT 1
        FROM [DWH].[dbo].[FACT_GAMEPLAY] f
        WHERE f.DATA_SK = dt.DATA_SK
          AND f.user_SK = u.user_sk
          AND f.game_SK = g.game_sk
          AND f.device_key = d.device_key
          and f.TOTAL_HOURS_PLAYED =s.TOTAL_HOURS_PLAYED
          and f.TROPHIES_COUNT =s.TROPHIES_COUNT
    );

END;
GO

create PROCEDURE [dbo].[DimDevice]
AS
BEGIN

    INSERT INTO [DWH].[dbo].[DIM_DEVICE]
    (
        
        [DEVICE_TYPE]
    )
    SELECT 
      
        [DEVICE_TYPE]
    FROM [STG].[dbo].[DEVICE];

END;
GO


CREATE PROCEDURE [dbo].[DimDate]
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO [DWH].[dbo].[DIM_DATE] ([DATE])
    SELECT [DATE]
    FROM [STG].[dbo].[DATE];
END;
GO


