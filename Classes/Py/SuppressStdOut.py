import os
import sys
import gc

# SR: ChatGPT from set task
# Define a context manager to suppress stdout
class SuppressStdout:
    def __enter__(self):
        self.original_stdout = sys.stdout
        sys.stdout = open(os.devnull, 'w')

    def __exit__(self, exc_type, exc_val, exc_tb):
        sys.stdout.close()
        sys.stdout = self.original_stdout
