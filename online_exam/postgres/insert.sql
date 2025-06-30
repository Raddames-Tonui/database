
INSERT INTO classes (class_id, class_name, date_created, date_modified) VALUES
(1, 'Grade 6', NOW(), NOW()),
(2, 'Grade 7', NOW(), NOW()),
(3, 'Grade 8', NOW(), NOW());



INSERT INTO subjects (subject_id, subject_code, subject_name, date_created, date_modified) VALUES
(1, 'MATH101', 'Mathematics', NOW(), NOW()),
(2, 'ENG102', 'English', NOW(), NOW()),
(3, 'SCI103', 'Science', NOW(), NOW());


INSERT INTO class_subjects (class_subject_id, class_id, subject_id) VALUES
(1, 1, 1), -- Grade 6 - Math
(2, 1, 2), -- Grade 6 - English
(3, 2, 1), -- Grade 7 - Math
(4, 2, 3), -- Grade 7 - Science
(5, 3, 1), -- Grade 8 - Math
(6, 3, 2), -- Grade 8 - English
(7, 3, 3); -- Grade 8 - Science

INSERT INTO pupils (pupil_id, pupil_firstname, pupil_lastname, pupil_email, gender, class_id, date_created, date_modified) VALUES
(1, 'Alice', 'Njoki', 'alice.njoki@example.com', 'Female', 1, NOW(), NOW()),
(2, 'Brian', 'Otieno', 'brian.otieno@example.com', 'Male', 1, NOW(), NOW()),
(3, 'Clara', 'Wambui', 'clara.wambui@example.com', 'Female', 2, NOW(), NOW()),
(4, 'David', 'Kariuki', 'david.kariuki@example.com', 'Male', 2, NOW(), NOW()),
(5, 'Esther', 'Njeri', 'esther.njeri@example.com', 'Female', 3, NOW(), NOW()),
(6, 'Felix', 'Mwangi', 'felix.mwangi@example.com', 'Male', 3, NOW(), NOW()),
(7, 'Grace', 'Mutua', 'grace.mutua@example.com', 'Female', 2, NOW(), NOW()),
(8, 'Hassan', 'Mohammed', 'hassan.mohammed@example.com', 'Male', 1, NOW(), NOW()),
(9, 'Irene', 'Koech', 'irene.koech@example.com', 'Female', 3, NOW(), NOW()),
(10, 'James', 'Kimani', 'james.kimani@example.com', 'Male', 2, NOW(), NOW());


INSERT INTO teachers (teacher_id, teacher_firstname, teacher_lastname, teacher_email, gender, date_created, date_modified) VALUES
(1, 'Moses', 'Kiptoo', 'moses.kiptoo@school.edu', 'Male', NOW(), NOW()),
(2, 'Angela', 'Mwende', 'angela.mwende@school.edu', 'Female', NOW(), NOW()),
(3, 'John', 'Ouma', 'john.ouma@school.edu', 'Male', NOW(), NOW());


INSERT INTO class_teacher (class_teacher_id, class_id, teacher_id) VALUES
(1, 1, 2), -- Grade 6 - Angela
(2, 2, 1), -- Grade 7 - Moses
(3, 3, 3); -- Grade 8 - John


INSERT INTO exams (exam_id, exam_title, teacher_id, subject_id, date_created, date_modified) VALUES
(1, 'Midterm Math Exam', 2, 1, NOW(), NOW()),
(2, 'Endterm English Test', 1, 2, NOW(), NOW()),
(3, 'Science Quiz', 3, 3, NOW(), NOW());


INSERT INTO questions (question_id, question_text, question_marks, exam_id, date_created, date_modified) VALUES
(1, 'What is 7 x 8?', 5, 1, NOW(), NOW()),
(2, 'Simplify: 4 + (6 x 2)', 5, 1, NOW(), NOW()),
(3, 'Solve for x: 2x = 10', 5, 1, NOW(), NOW());


INSERT INTO choices (choice_id, choice_label, choice_value, choice_is_correct, question_id, date_created, date_modified) VALUES
-- Q1
(1, 'A', '56', TRUE, 1, NOW(), NOW()),
(2, 'B', '48', FALSE, 1, NOW(), NOW()),
(3, 'C', '42', FALSE, 1, NOW(), NOW()),
(4, 'D', '64', FALSE, 1, NOW(), NOW()),
-- Q2
(5, 'A', '16', TRUE, 2, NOW(), NOW()),
(6, 'B', '20', FALSE, 2, NOW(), NOW()),
(7, 'C', '10', FALSE, 2, NOW(), NOW()),
(8, 'D', '12', FALSE, 2, NOW(), NOW()),
-- Q3
(9, 'A', '5', TRUE, 3, NOW(), NOW()),
(10, 'B', '10', FALSE, 3, NOW(), NOW()),
(11, 'C', '2', FALSE, 3, NOW(), NOW()),
(12, 'D', '8', FALSE, 3, NOW(), NOW());


INSERT INTO submissions (submission_id, exam_id, pupil_id, date_submitted) VALUES
(1, 1, 1, NOW()), -- Alice
(2, 1, 2, NOW()), -- Brian
(3, 1, 9, NOW()), -- Irene
(4, 1, 4, NOW()), -- David
(5, 1, 5, NOW()); -- Esther



-- Alice (2 correct, 1 wrong)
INSERT INTO answers (answer_id, question_id, submission_id, choice_id, date_created, date_modified) VALUES
(1, 1, 1, 1, NOW(), NOW()),
(2, 2, 1, 5, NOW(), NOW()),
(3, 3, 1, 10, NOW(), NOW());

-- Brian (all correct)
INSERT INTO answers (answer_id, question_id, submission_id, choice_id, date_created, date_modified) VALUES
(4, 1, 2, 1, NOW(), NOW()),
(5, 2, 2, 5, NOW(), NOW()),
(6, 3, 2, 9, NOW(), NOW());

-- Irene (all correct)
INSERT INTO answers (answer_id, question_id, submission_id, choice_id, date_created, date_modified) VALUES
(7, 1, 3, 1, NOW(), NOW()),
(8, 2, 3, 5, NOW(), NOW()),
(9, 3, 3, 9, NOW(), NOW());

-- David (1 correct)
INSERT INTO answers (answer_id, question_id, submission_id, choice_id, date_created, date_modified) VALUES
(10, 1, 4, 2, NOW(), NOW()),
(11, 2, 4, 6, NOW(), NOW()),
(12, 3, 4, 9, NOW(), NOW());

-- Esther (2 correct)
INSERT INTO answers (answer_id, question_id, submission_id, choice_id, date_created, date_modified) VALUES
(13, 1, 5, 1, NOW(), NOW()),
(14, 2, 5, 7, NOW(), NOW()),
(15, 3, 5, 9, NOW(), NOW());
