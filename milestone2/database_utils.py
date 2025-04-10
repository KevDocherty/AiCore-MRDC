class DatabaseConnector():

    def read_db_creds():
        '''
        reads the credentials yaml file and returns a dictionary of the credentials
        '''
        with open('db_creds.yaml', 'r') as f:
            credentials = yaml.safe_load(f)
        return credentials

    def init_db_engine(credentials):
        '''
        read the credentials from read_db_creds and initialise and return an sqlalchemy database engine
        '''
        DATABASE_TYPE = credentials["RDS_DATABASE"]
        #DBAPI = 'psycopg2'
        HOST = credentials["RDS_HOST"]
        USER = credentials["RDS_USER"]
        PASSWORD = credentials["RDS_PASSWORD"]
        DATABASE = credentials["RDS_DATABASE"]
        PORT = credentials["RDS_PORT"]

        DATABASE_URL = f"postgresql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}"
        engine = create_engine(DATABASE_URL)

        return engine
