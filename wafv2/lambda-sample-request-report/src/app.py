import os

from waf.get_samples import get_sampled_request
from waf.report import apply_path_filter, create_report

PATH_PATTERNS = os.getenv("PATH_PATTERNS", default=None)
START_TIME = os.getenv("START_TIME", default=None)
END_TIME = os.getenv("END_TIME", default=None)


def lambda_handler(event=None, context=None):
    response = get_sampled_request(START_TIME, END_TIME)
    unsorted = response['SampledRequests']

    def get_weight(requestObj):
        return requestObj['Weight']


    sorted_by_weight = [item for item in sorted(unsorted, key=get_weight, reverse=True)]


    PATHS = [] if not PATH_PATTERNS else PATH_PATTERNS.split(",")
    create_report("PATHS" + str(PATHS), apply_path_filter(sorted_by_weight, PATHS))


