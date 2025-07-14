import psycopg2  
# PostgreSQL database adapter for Python
# Create a PostgreSQL connection using a dictionary of config values
def get_connection(config):
    return psycopg2.connect(**config)

# Perform a batch insert of multiple rows into a table
def batch_insert(conn, query, data):
    with conn.cursor() as cur:
        # Prepare each row using mogrify (handles SQL escaping),
        # then join them into a single VALUES string
        args_str = b",".join(
            cur.mogrify("(%s, %s, %s, %s, %s)", row) for row in data
        ).decode("utf-8")

        # Execute the final formatted query with all values
        cur.execute(query.format(args_str))

    conn.commit()
