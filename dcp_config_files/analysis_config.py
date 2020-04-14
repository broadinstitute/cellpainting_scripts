# Constants (User configurable)
# See https://github.com/CellProfiler/Distributed-CellProfiler/wiki/Step-1%3A--Configuration

APP_NAME = 'VAR_APP_NAME_Analysis'              # Used to generate derivative names unique to the application.

# DOCKER REGISTRY INFORMATION:
DOCKERHUB_TAG = 'cellprofiler/distributed-cellprofiler:VAR_DCP_VERSION'

# AWS GENERAL SETTINGS:
AWS_REGION = 'us-east-1'
AWS_PROFILE = 'default'                 # The same profile used by your AWS CLI installation
SSH_KEY_NAME = 'ipdev.pem'              # Expected to be in ~/.ssh
AWS_BUCKET = 'VAR_AWS_BUCKET'

# EC2 AND ECS INFORMATION:
ECS_CLUSTER = 'default'
CLUSTER_MACHINES = 25
TASKS_PER_MACHINE = 4
EBS_VOL_SIZE = 61                       # In GB.  Minimum allowed is 22.

# DOCKER INSTANCE RUNNING ENVIRONMENT:
DOCKER_CORES = 4                        # Number of CellProfiler processes to run inside a docker container
CPU_SHARES = DOCKER_CORES * 1024        # ECS computing units assigned to each docker container (1024 units = 1 core)
MEMORY = 15000                          # Memory assigned to the docker container in MB
SECONDS_TO_START = 3*60                 # Wait before the next CP process is initiated to avoid memory collisions
DOCKER_BASE_SIZE = 15                   # In GB; default is 10.  The amount of hard disk space each docker container uses.
                                        # EBS_VOL_SIZE should be >= DOCKER_BASE_SIZE * TASKS_PER_MACHINE

# SQS QUEUE INFORMATION:
SQS_QUEUE_NAME = APP_NAME + 'Queue'
SQS_MESSAGE_VISIBILITY = 120*60         # Timeout (secs) for messages in flight (average time to be processed)
SQS_DEAD_LETTER_QUEUE = 'arn:aws:sqs:us-east-1:VAR_AWS_ACCOUNT_NUMBER:DeadLetter' 

# LOG GROUP INFORMATION:
LOG_GROUP_NAME = APP_NAME 

# REDUNDANCY CHECKS
CHECK_IF_DONE_BOOL = 'False'            # True or False- should it check if there are a certain number of non-empty files and delete the job if yes?
EXPECTED_NUMBER_FILES = 7               # What is the number of files that trigger skipping a job?
