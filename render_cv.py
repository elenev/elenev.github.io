import os

# retrieve DROPBOX path environment variable
DROPBOX = os.environ.get('DROPBOXPATH')

# path to CV
CV_PATH = os.path.join(DROPBOX, 'CV', 'CV 2023-12.docx')

# Use pandoc shell command to convert
os.system(f'pandoc -s -o CV.html "{CV_PATH}"')