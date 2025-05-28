SELECT  p.pupil_firstname, p.pupil_lastname, c.class_name
FROM pupils p
INNER JOIN classes c ON p.class_id = c.class_id
ORDER BY pupil_firstname DESC;

SELECT e.exam_id, e.exam_title, t.teacher_firstname, t.teacher_lastname,s.subject_name
FROM teachers t
INNER JOIN exams e ON t.teacher_id = e.teacher_id
INNER JOIN subjects s ON e.subject_id = s.subject_id;

--------------------------------- Tasks------------------------------------------------------
-- 2. Display all the exams set by a teacher.
SELECT concat(t.teacher_firstname,' ', t.teacher_lastname), e.exam_id, e.exam_title,  s.subject_name, e.date_created
FROM exams e
INNER JOIN teachers t ON e.teacher_id = t.teacher_id
INNER JOIN  subjects s ON e.subject_id = s.subject_id
WHERE t.teacher_id = 2;


-- 3 Generate a report on the answers provided by a pupil for an exam and their percentage score in that exam.
SELECT
--     p.pupil_firstname || ' ' || p.pupil_lastname AS pupil_name,
    concat(p.pupil_firstname, ' ', p.pupil_lastname) AS pupil_name,
    e.exam_title,
    COUNT(a.answer_id) AS total_answers,
    SUM(CASE
            WHEN c.choice_is_correct THEN q.question_marks
            ELSE 0
        END) AS total_score,
    SUM(q.question_marks) AS total_possible,
    ROUND(
        (SUM(CASE
                WHEN c.choice_is_correct THEN q.question_marks
                ELSE 0
            END)::DECIMAL /
         SUM(q.question_marks)) * 100, 2
    ) AS percentage_score
FROM
    submissions s
INNER JOIN
    pupils p ON s.pupil_id = p.pupil_id
INNER JOIN
    exams e ON s.exam_id = e.exam_id
INNER JOIN
    answers a ON s.submission_id = a.submission_id
INNER JOIN
    choices c ON a.choice_id = c.choice_id
INNER JOIN
    questions q ON a.question_id = q.question_id
WHERE
    s.pupil_id = 9 AND s.exam_id = 1
GROUP BY
    p.pupil_firstname, p.pupil_lastname, e.exam_title;

-- 4. Generate a report on the top 5 pupils with the highest scores in a certain exam.

SELECT
    p.pupil_id,
    p.pupil_firstname || ' ' || p.pupil_lastname AS pupil_name,
    SUM(CASE
            WHEN c.choice_is_correct THEN q.question_marks
            ELSE 0
        END) AS score
FROM
    submissions s
INNER JOIN
    pupils p ON s.pupil_id = p.pupil_id
INNER JOIN
    answers a ON a.submission_id = s.submission_id
INNER JOIN
    choices c ON a.choice_id = c.choice_id
INNER JOIN
    questions q ON a.question_id = q.question_id
WHERE
    s.exam_id = 1
GROUP BY
    p.pupil_id, p.pupil_firstname, p.pupil_lastname
ORDER BY
    score DESC
LIMIT 5;

-- 5. Generate a report sheet of the scores for all pupils in each of the exams done and rank them from the highest average score to lowest.
-- pupil_scores: computes scores per pupil per exam.
WITH pupil_scores AS (
    SELECT
        p.pupil_id,
        p.pupil_firstname || ' ' || p.pupil_lastname AS pupil_name,
        s.exam_id,
        e.exam_title,
        SUM(CASE 
                WHEN c.choice_is_correct THEN q.question_marks 
                ELSE 0 
            END) AS score,
        SUM(q.question_marks) AS total_possible
    FROM
        submissions s
    INNER JOIN
        pupils p ON s.pupil_id = p.pupil_id
    INNER JOIN
        exams e ON s.exam_id = e.exam_id
    INNER JOIN
        answers a ON a.submission_id = s.submission_id
    INNER JOIN
        choices c ON a.choice_id = c.choice_id
    INNER JOIN
        questions q ON a.question_id = q.question_id
    GROUP BY
        p.pupil_id, p.pupil_firstname, p.pupil_lastname, s.exam_id, e.exam_title
),
-- average_scores: calculates average percentage across all exams per pupil.    
average_scores AS (
    SELECT
        pupil_id,
        pupil_name,
        ROUND(AVG((score::DECIMAL / total_possible) * 100), 2) AS average_percentage
    FROM
        pupil_scores
    GROUP BY
        pupil_id, pupil_name
)
SELECT
    *,
    RANK() OVER (ORDER BY average_percentage DESC) AS rank
FROM
    average_scores;

