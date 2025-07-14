| Table            | Rows          | Notes                                                 |
| ---------------- | ------------- | ----------------------------------------------------- |
| `classes`        | 10            | Static, base for pupils/teachers                      |
| `subjects`       | 20            | Static, base for exams                                |
| `class_subjects` | 200           | 10 × 20 combinations                                  |
| `teachers`       | 2,000         | Assigned to classes & exams                           |
| `class_teacher`  | 2,000         | One class per teacher                                 |
| `pupils`         | **1,000,000** | Main performance test table                           |
| `exams`          | 25,000        | Randomly mapped to teachers & subjects                |
| `questions`      | 250,000       | 10 per exam                                           |
| `choices`        | 1,000,000     | 4 per question                                        |
| `submissions`    | 500,000       | Half of pupils take 1 exam                            |
| `answers`        | 1,000,000     | 2 answers per submission (e.g., 2 questions answered) |

🧮 Total: ~5M records