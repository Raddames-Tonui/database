import argparse
import random
import time
from faker import Faker
from db_config import DBS
from utils import get_connection

fake = Faker()

def seed_classes_subjects(cur):
    for i in range(10):
        cur.execute("INSERT INTO classes (class_name) VALUES (%s)", (f"Class {i+1}",))
    for i in range(20):
        cur.execute("INSERT INTO subjects (subject_code, subject_name) VALUES (%s, %s)",
                    (f"S{i+1:03}", f"Subject {i+1}"))

def seed_teachers(cur):
    for _ in range(2000):
        cur.execute(
            "INSERT INTO teachers (teacher_firstname, teacher_lastname, teacher_email, gender) VALUES (%s, %s, %s, %s)",
            (fake.first_name(), fake.last_name(), fake.unique.email(), random.choice(['Male', 'Female']))
        )

def seed_class_teacher(cur):
    for i in range(1, 2001):
        cur.execute("INSERT INTO class_teacher (class_id, teacher_id) VALUES (%s, %s)", (random.randint(1, 10), i))

def seed_class_subjects(cur):
    for class_id in range(1, 11):
        for subject_id in range(1, 21):
            cur.execute("INSERT INTO class_subjects (class_id, subject_id) VALUES (%s, %s)", (class_id, subject_id))

def seed_pupils(cur):
    for _ in range(1000000):
        cur.execute(
            "INSERT INTO pupils (pupil_firstname, pupil_lastname, pupil_email, gender, class_id) VALUES (%s, %s, %s, %s, %s)",
            (fake.first_name(), fake.last_name(), fake.unique.email(), random.choice(['Male', 'Female']), random.randint(1, 10))
        )

def seed_exams_questions_choices(cur):
    exam_count = 25000
    qid = 1
    for exam_id in range(1, exam_count + 1):
        cur.execute(
            "INSERT INTO exams (exam_title, teacher_id, subject_id) VALUES (%s, %s, %s)",
            (f"{fake.word().title()} Exam", random.randint(1, 2000), random.randint(1, 20))
        )
        for _ in range(10):
            cur.execute(
                "INSERT INTO questions (question_text, question_marks, exam_id) VALUES (%s, %s, %s)",
                (fake.sentence(), random.randint(1, 10), exam_id)
            )
            for label in ['A', 'B', 'C', 'D']:
                cur.execute(
                    "INSERT INTO choices (choice_label, choice_value, choice_is_correct, question_id) VALUES (%s, %s, %s, %s)",
                    (label, fake.word(), label == 'A', qid)
                )
            qid += 1

def seed_submissions_answers(cur):
    for sid in range(1, 500001):
        pupil_id = random.randint(1, 1000000)
        exam_id = random.randint(1, 25000)
        cur.execute("INSERT INTO submissions (exam_id, pupil_id) VALUES (%s, %s)", (exam_id, pupil_id))
        for _ in range(2):
            question_id = random.randint(1, 250000)
            choice_id = random.randint(1, 1000000)
            cur.execute(
                "INSERT INTO answers (question_id, submission_id, choice_id) VALUES (%s, %s, %s)",
                (question_id, sid, choice_id)
            )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--db", required=True, help="Target DB: indexed or unindexed")
    args = parser.parse_args()

    db_key = args.db.lower()
    if db_key not in DBS:
        raise ValueError("DB must be 'indexed' or 'unindexed'")

    conn = get_connection(DBS[db_key])
    cur = conn.cursor()
    print(f"Seeding database: {db_key}")

    start = time.time()

    print("→ Seeding classes and subjects")
    seed_classes_subjects(cur)
    conn.commit()

    print("→ Seeding teachers")
    seed_teachers(cur)
    conn.commit()

    print("→ Seeding class_teacher and class_subjects")
    seed_class_teacher(cur)
    seed_class_subjects(cur)
    conn.commit()

    print("→ Seeding pupils")
    seed_pupils(cur)
    conn.commit()

    print("→ Seeding exams, questions, choices")
    seed_exams_questions_choices(cur)
    conn.commit()

    print("→ Seeding submissions and answers")
    seed_submissions_answers(cur)
    conn.commit()

    print(f"✅ Seeding for {db_key} complete in {round(time.time() - start, 2)} seconds")
    cur.close()
    conn.close()