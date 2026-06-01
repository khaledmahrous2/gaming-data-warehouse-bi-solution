
CREATE PROCEDURE [dbo].[RELOAD_TROPHY_TYPES]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        INSERT INTO [STG].[dbo].[TROPHY_TYPES] (
            TROPHY_NAME,
            TROPHY_TYPE
        )
        SELECT DISTINCT
            ISNULL(
                NULLIF(
                    CASE 
                        WHEN RIGHT(TRIM(TROPHY_NAME), 1) = '.' 
                        THEN LEFT(TRIM(TROPHY_NAME), LEN(TRIM(TROPHY_NAME)) - 1)
                        ELSE TRIM(TROPHY_NAME)
                    END
                , ''), 'N.A'
            ) AS TROPHY_NAME,

            ISNULL(
                NULLIF(
                    CASE 
                        WHEN RIGHT(TRIM(TROPHY_TYPE), 1) = '.' 
                        THEN LEFT(TRIM(TROPHY_TYPE), LEN(TRIM(TROPHY_TYPE)) - 1)
                        ELSE TRIM(TROPHY_TYPE)
                    END
                , ''), 'N.A'
            ) AS TROPHY_TYPE

        FROM [ODS].[dbo].[-----];

    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
    END CATCH
END;

GO


CREATE PROCEDURE [dbo].[LOAD_DIM_PAYMENT]
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        INSERT INTO  PAYMENT_METHOD (payment_method)
        SELECT DISTINCT
            ISNULL(NULLIF(TRIM(payment_method), ''), 'N.A')
        FROM [ODS].[dbo].[orders];

    END TRY
    BEGIN CATCH
        PRINT 'Error occurred while loading DIM_PAYMENT';
        PRINT ERROR_MESSAGE();
    END CATCH

END;

GO
CREATE PROCEDURE [dbo].[RELOAD_GAME_GENRE]
AS 
	BEGIN 

    SET NOCOUNT ON;

    BEGIN TRY
INSERT INTO GAME_GENRE(
            GAME_ID ,
	        GENRE 
        )
        SELECT DISTINCT 
    ISNULL(NULLIF(GAME_ID, ''), 999999) AS GAME_ID,
    ISNULL(
        NULLIF(
            CASE 
                WHEN RIGHT(TRIM(GENRE), 1) = '.' 
                    THEN LEFT(TRIM(GENRE), LEN(TRIM(GENRE)) - 1)
                ELSE TRIM(GENRE)
            END
        , ''), 
    'N.A') AS game_name
    
FROM [ODS].[dbo].[GAME_GENRES]
END TRY

    BEGIN CATCH
        PRINT 'Error occurred in RELOAD_GAME_GENRE';
        PRINT ERROR_MESSAGE();
    END CATCH

END;
GO

CREATE PROCEDURE [dbo].[RELOAD_GAME_DETAILS]
AS
BEGIN
    SET NOCOUNT ON;
     BEGIN TRY

        IF NOT EXISTS (
            SELECT 1 
            FROM [STG].[dbo].[GAME_DETAILS] 
            WHERE game_id = -1
        )
        BEGIN
            INSERT INTO GAME_DETAILS(
            [game_id]  ,
            [game_name]  ,
            GENRE,
            [price]  ,
            [discount_percentage] ,
            [tax_percentage] ,
            [release_date] ,
            [platform] ,
            [rating] 
        )
            
            VALUES (
                -1,
                'UNKNOWN',
                'UNKNOWN',
                  -9.99,
                  -9.99,
                   -9.99,
                  '1900-01-01',
                  'UNKNOWN',
                 -9.99
               
               
            );
        END

   
INSERT INTO GAME_DETAILS(
            [game_id]  ,
            [game_name]  ,
            GENRE,
            [price]  ,
            [discount_percentage] ,
            [tax_percentage] ,
            [release_date] ,
            [platform] ,
            [rating] 
        )
        SELECT DISTINCT
            GT.game_id,
            ISNULL(NULLIF(TRIM(GT.[game_name]), ''), 'N.A') AS game_name,
            ISNULL(
        NULLIF(
            CASE 
                WHEN RIGHT(TRIM(GENRE), 1) = '.' 
                    THEN LEFT(TRIM(GENRE), LEN(TRIM(GENRE)) - 1)
                ELSE TRIM(GENRE)
            END
        , ''), 
    'N.A') AS GENRE,
            ISNULL(NULLIF(GP.[price], ''), 999.999) AS price,
            ISNULL(NULLIF(GP.[discount_percentage], ''), 999.999) AS discount_percentage,
            ISNULL(NULLIF(GP.[tax_percentage], ''), 999.999) AS tax_percentage,
            ISNULL(NULLIF(GM.[release_date] , ''), '1900-01-01')AS release_date,
            ISNULL(NULLIF(TRIM(GM.[platform]), ''), 'N.A') AS platform,
            ISNULL(NULLIF(GM.[rating], ''), 999.999) AS RATING
           

        FROM [ODS].[dbo].[GAME_TITLES] GT
        FULL OUTER JOIN  [ODS].[dbo].[GAME_PRICES] GP
            ON GT.game_id = GP.game_id
        FULL OUTER JOIN [ODS].[dbo].[GAME_METADATE] GM
            ON GT.game_id= GM.game_id
        FULL OUTER JOIN [ODS].[dbo].[GAME_GENRES] W
            ON  GT.game_id = W.game_id


             END TRY

    BEGIN CATCH
        
        PRINT ERROR_MESSAGE();
    END CATCH
END
GO


CREATE PROCEDURE [dbo].[sp_Load_Dates]
AS 
BEGIN 
    

    BEGIN TRY

        INSERT INTO DATE (DATE)
        SELECT DISTINCT 
         ISNULL(NULLIF(d, ''), '1900-01-01') AS d
        FROM (
            SELECT session_date AS d FROM [ODS].[dbo].[game_sessions]
            UNION
            SELECT order_date FROM [ODS].[dbo].[orders]
            UNION
            SELECT earned_date FROM [ODS].[dbo].[-----] 
        ) AS all_dates;

    END TRY

    BEGIN CATCH
        PRINT 'Error occurred in sp_Load_Dates';
        PRINT ERROR_MESSAGE();
    END CATCH

END;
GO

