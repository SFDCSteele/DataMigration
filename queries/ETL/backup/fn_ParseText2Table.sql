ALTER FUNCTION [fn_ParseText2Table]
 (
 @p_SourceText VARCHAR(MAX)
 , @p_Delimeter  VARCHAR(100) = ';' --default to colon delimited.
 )
RETURNS @retTable TABLE
      (
      [Position]   INT IDENTITY(1, 1)
       , [Txt_Value]  VARCHAR(MAX)
      )
AS

  BEGIN
   DECLARE @w_Continue      INT
      , @w_StartPos      INT
      , @w_Length        INT
      , @w_Delimeter_pos INT
      , @w_tmp_txt       VARCHAR(MAX)
      , @w_Delimeter_Len TINYINT;
   IF LEN(@p_SourceText) = 0
    BEGIN
     SET @w_Continue = 0; -- force early exit
    END;
   ELSE
    BEGIN
     -- parse the original @p_SourceText array into a temp table
     SET @w_Continue = 1;
     SET @w_StartPos = 1;
     SET @p_SourceText = RTRIM(LTRIM(@p_SourceText));
     SET @w_Length = DATALENGTH(RTRIM(LTRIM(@p_SourceText)));
     SET @w_Delimeter_Len = LEN(@p_Delimeter);
    END;
   WHILE @w_Continue = 1
    BEGIN
     SET @w_Delimeter_pos = CHARINDEX(@p_Delimeter, (SUBSTRING(@p_SourceText, @w_StartPos, ((@w_Length-@w_StartPos)+@w_Delimeter_Len))));
     IF @w_Delimeter_pos > 0  -- delimeter(s) found, get the value
      BEGIN
       SET @w_tmp_txt = LTRIM(RTRIM(SUBSTRING(@p_SourceText, @w_StartPos, (@w_Delimeter_pos-1))));
       SET @w_StartPos = @w_Delimeter_pos + @w_StartPos + (@w_Delimeter_Len - 1);
      END;
     ELSE -- No more delimeters, get last value
      BEGIN
       SET @w_tmp_txt = LTRIM(RTRIM(SUBSTRING(@p_SourceText, @w_StartPos, ((@w_Length-@w_StartPos)+@w_Delimeter_Len))));
       SELECT @w_Continue = 0;
      END;
     INSERT INTO @retTable
     VALUES
      (@w_tmp_txt);
    END;
   RETURN;
  END;
--GO

