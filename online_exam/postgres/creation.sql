-- SUBJECTS TABLE
CREATE TABLE subjects (
    subject_id     BIGSERIAL PRIMARY KEY,
    subject_code   VARCHAR(255) NOT NULL,
    subject_name   VARCHAR(255) NOT NULL,
    date_created   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- CLASSES TABLE
CREATE TABLE classes (
    class_id       BIGSERIAL PRIMARY KEY,
    class_name     VARCHAR(255) NOT NULL,
    date_created   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- CLASS_SUBJECTS (MANY-TO-MANY RELATIONSHIP)
CREATE TABLE class_subjects (
    class_subject_id BIGSERIAL PRIMARY KEY,
    class_id         BIGINT NOT NULL REFERENCES classes(class_id) ON DELETE CASCADE,
    subject_id       BIGINT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE
);

-- PUPILS TABLE
CREATE TABLE pupils (
    pupil_id        BIGSERIAL PRIMARY KEY,
    pupil_firstname VARCHAR(255) NOT NULL,
    pupil_lastname  VARCHAR(255) NOT NULL,
    pupil_email     VARCHAR(255) NOT NULL UNIQUE,
    gender          VARCHAR(50)  NOT NULL,
    class_id        BIGINT       NOT NULL REFERENCES classes(class_id) ON DELETE RESTRICT,
    date_created    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified   TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_pupil_class FOREIGN KEY (class_id) REFERENCES classes(class_id)
);

COMMENT ON COLUMN pupils.class_id IS 'Foreign Key';

CREATE INDEX idx_pupils_email_class ON pupils (pupil_email, class_id);

-- TEACHERS TABLE
CREATE TABLE teachers (
    teacher_id        BIGSERIAL PRIMARY KEY,
    teacher_firstname VARCHAR(255) NOT NULL,
    teacher_lastname  VARCHAR(255) NOT NULL,
    teacher_email     VARCHAR(255) NOT NULL UNIQUE,
    gender            VARCHAR(50)  NOT NULL,
    date_created      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    date_modified     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- EXAMS TABLE
CREATE TABLE exams (
    exam_id       BIGSERIAL PRIMARY KEY,
    exam_title    VARCHAR(255) NOT NULL,
    teacher_id    BIGINT REFERENCES teachers(teacher_id) ON DELETE SET NULL,
    subject_id    BIGINT NOT NULL REFERENCES subjects(subject_id) ON DELETE CASCADE,
    date_created  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exams_teacher_subject ON exams (teacher_id, subject_id);

-- QUESTIONS TABLE
CREATE TABLE questions (
    question_id     BIGSERIAL PRIMARY KEY,
    question_text   TEXT NOT NULL,
    question_marks  INTEGER NOT NULL,
    exam_id         BIGINT NOT NULL REFERENCES exams(exam_id) ON DELETE CASCADE,
    date_created    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    date_modified   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_questions_exam_id ON questions (exam_id);

-- CHOICES TABLE
CREATE TABLE choices (
    choice_id         BIGSERIAL PRIMARY KEY,
    choice_label      VARCHAR(255) NOT NULL,
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

CREATE INDEX idx_answers_question_id ON answers (question_id);

-- CLASS_TEACHER (MANY-TO-MANY RELATIONSHIP)
CREATE TABLE class_teacher (
    class_teacher_id BIGSERIAL PRIMARY KEY,
    class_id         BIGINT NOT NULL REFERENCES classes(class_id) ON DELETE CASCADE,
    teacher_id       BIGINT NOT NULL REFERENCES teachers(teacher_id) ON DELETE CASCADE
);

