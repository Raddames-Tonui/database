-- Create database
-- CREATE DATABASE unindexed_exams;

-- SUBJECTS TABLE
CREATE TABLE subjects (
    subject_id     BIGSERIAL PRIMARY KEY,
    subject_code   VARCHAR(10)  NOT NULL,
    subject_name   VARCHAR(100) NOT NULL,
    date_created   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- CLASSES TABLE
CREATE TABLE classes (
    class_id       BIGSERIAL PRIMARY KEY,
    class_name     VARCHAR(50) NOT NULL,
    date_created   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- CLASS_SUBJECTS
CREATE TABLE class_subjects (
    class_subject_id BIGSERIAL PRIMARY KEY,
    class_id         BIGINT NOT NULL REFERENCES classes(class_id) ON DELETE CASCADE,
    subject_id       BIGINT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE
    -- Removed UNIQUE constraint
);

-- PUPILS TABLE
CREATE TABLE pupils (
    pupil_id        BIGSERIAL PRIMARY KEY,
    pupil_firstname VARCHAR(50)  NOT NULL,
    pupil_lastname  VARCHAR(50)  NOT NULL,
    pupil_email     VARCHAR(100) NOT NULL,
    gender          VARCHAR(10)  NOT NULL CHECK (gender IN ('Male', 'Female')),
    class_id        BIGINT       NOT NULL REFERENCES classes(class_id) ON DELETE RESTRICT,
    date_created    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified   TIMESTAMPTZ  NOT NULL DEFAULT NOW()
    -- Removed UNIQUE and FK constraint name
);

-- TEACHERS TABLE
CREATE TABLE teachers (
    teacher_id        BIGSERIAL PRIMARY KEY,
    teacher_firstname VARCHAR(50)  NOT NULL,
    teacher_lastname  VARCHAR(50)  NOT NULL,
    teacher_email     VARCHAR(100) NOT NULL,
    gender            VARCHAR(10)  NOT NULL CHECK (gender IN ('Male', 'Female')),
    date_created      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- EXAMS TABLE
CREATE TABLE exams (
    exam_id       BIGSERIAL PRIMARY KEY,
    exam_title    VARCHAR(100) NOT NULL,
    teacher_id    BIGINT REFERENCES teachers(teacher_id) ON DELETE SET NULL,
    subject_id    BIGINT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE,
    date_created  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- QUESTIONS TABLE
CREATE TABLE questions (
    question_id     BIGSERIAL PRIMARY KEY,
    question_text   TEXT NOT NULL,
    question_marks  INTEGER NOT NULL CHECK (question_marks >= 0),
    exam_id         BIGINT NOT NULL REFERENCES exams(exam_id) ON DELETE CASCADE,
    date_created    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- CHOICES TABLE
CREATE TABLE choices (
    choice_id         BIGSERIAL PRIMARY KEY,
    choice_label      VARCHAR(5)   NOT NULL,
    choice_value      TEXT         NOT NULL,
    choice_is_correct BOOLEAN      NOT NULL,
    question_id       BIGINT       NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    date_created      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- SUBMISSIONS TABLE
CREATE TABLE submissions (
    submission_id  BIGSERIAL PRIMARY KEY,
    exam_id        BIGINT NOT NULL REFERENCES exams(exam_id) ON DELETE CASCADE,
    pupil_id       BIGINT NOT NULL REFERENCES pupils(pupil_id) ON DELETE CASCADE,
    date_submitted TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ANSWERS TABLE
CREATE TABLE answers (
    answer_id     BIGSERIAL PRIMARY KEY,
    question_id   BIGINT NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    submission_id BIGINT NOT NULL REFERENCES submissions(submission_id) ON DELETE CASCADE,
    choice_id     BIGINT NOT NULL REFERENCES choices(choice_id) ON DELETE CASCADE,
    date_created  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- CLASS_TEACHER TABLE
CREATE TABLE class_teacher (
    class_teacher_id BIGSERIAL PRIMARY KEY,
    class_id         BIGINT NOT NULL REFERENCES classes(class_id) ON DELETE CASCADE,
    teacher_id       BIGINT NOT NULL REFERENCES teachers(teacher_id) ON DELETE CASCADE
);
