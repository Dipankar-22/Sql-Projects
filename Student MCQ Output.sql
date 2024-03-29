/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [roll_number]
      ,[student_name]
      ,[class]
      ,[section]
      ,[school_name]
  FROM [MCQ Project].[dbo].[student_list]



  --QUESTION 1  SCORE AND PERCENTAGE OF ALL STUDENTS

--SOLUTION-:

  WITH STUDENT AS
  (
  SELECT SL.ROLL_NUMBER,SL.STUDENT_NAME,SL.CLASS,SL.SECTION,
         SL.SCHOOL_NAME,SUBJECT,CA.QUESTION_NUMBER,CA.CORRECT_OPTION,SR.OPTION_MARKED,
  CASE WHEN SR.OPTION_MARKED=CA.CORRECT_OPTION AND SUBJECT='SCIENCE' THEN 
  COUNT(OPTION_MARKED) END AS SCIENCE_CORRECT,
  CASE WHEN SR.OPTION_MARKED=CA.CORRECT_OPTION AND SUBJECT='MATH' THEN 
  COUNT(OPTION_MARKED) END AS MATH_CORRECT,
  CASE WHEN SR.OPTION_MARKED=CA.CORRECT_OPTION AND SUBJECT='SCIENCE' THEN 
  COUNT(OPTION_MARKED) END AS SCIENCE_SCORE,
  CASE WHEN SR.OPTION_MARKED=CA.CORRECT_OPTION AND SUBJECT='MATH' THEN 
  COUNT(OPTION_MARKED) END AS MATH_SCORE,
  CASE WHEN SR.OPTION_MARKED<>CA.CORRECT_OPTION AND SUBJECT='SCIENCE' THEN 
  COUNT(OPTION_MARKED) END AS SCIENCE_WRONG,
  CASE WHEN SR.OPTION_MARKED<>CA.CORRECT_OPTION AND SUBJECT='MATH' THEN 
  COUNT(OPTION_MARKED) END AS MATH_WRONG,
  CASE WHEN OPTION_MARKED='E' AND SUBJECT='MATH'
  THEN COUNT(OPTION_MARKED) END AS MATH_YET_TO_LEARN,
  CASE WHEN OPTION_MARKED='E' AND SUBJECT='SCIENCE'
  THEN COUNT(OPTION_MARKED) END AS SCIENCE_YET_TO_LEARN
  FROM [MCQ PROJECT].[DBO].[STUDENT_LIST] SL
  FULL JOIN [MCQ PROJECT].[DBO].[STUDENT_RESPONSE] SR ON SL.ROLL_NUMBER=SR.ROLL_NUMBER
  FULL JOIN [MCQ PROJECT].[DBO].[CORRECT_ANSWER] CA
       ON CA.QUESTION_PAPER_CODE=SR.QUESTION_PAPER_CODE AND SR.QUESTION_NUMBER=CA.QUESTION_NUMBER
  FULL JOIN [MCQ PROJECT].[DBO].[QUESTION_PAPER_CODE] QPC ON QPC.PAPER_CODE=CA.QUESTION_PAPER_CODE
  GROUP BY SL.ROLL_NUMBER,SL.STUDENT_NAME,SL.CLASS,SL.SECTION,
         SL.SCHOOL_NAME,SUBJECT,CA.QUESTION_NUMBER,CA.CORRECT_OPTION,SR.OPTION_MARKED
  )
  SELECT ROLL_NUMBER,STUDENT_NAME,CLASS,SECTION,SCHOOL_NAME,
         SUM(MATH_CORRECT) AS MATH_CORRECT,SUM(MATH_WRONG)- SUM(MATH_YET_TO_LEARN)AS MATH_WRONG,
		 SUM(MATH_YET_TO_LEARN) AS MATH_YET_TO_LEARN,
		 SUM(MATH_SCORE) AS MATH_SCORE,
		 CAST(CAST(SUM(MATH_CORRECT)AS DECIMAL(5,2))*100/CAST((SUM(MATH_CORRECT)+SUM(MATH_WRONG))AS DECIMAL(5,2))AS DECIMAL (5,2)) AS MATH_PERCENTAGE,
		 SUM(SCIENCE_CORRECT) AS SCIENCE_CORRECT,
		 SUM(SCIENCE_WRONG)-SUM(SCIENCE_YET_TO_LEARN) AS SCIENCE_WRONG,
		 SUM(SCIENCE_YET_TO_LEARN) AS SCIENCE_YET_TO_LEARN,
		 SUM(SCIENCE_SCORE) AS SCIENCE_SCORE,
		 CAST(CAST(SUM(SCIENCE_CORRECT)AS DECIMAL (5,2))*100 /CAST((SUM(SCIENCE_CORRECT)+SUM(SCIENCE_WRONG))AS DECIMAL (5,2))AS DECIMAL (5,2)) AS SCIENCE_PERCENTAGE
  FROM STUDENT
  GROUP BY ROLL_NUMBER,STUDENT_NAME,CLASS,SECTION,SCHOOL_NAME




 
		 
		 
		 
  