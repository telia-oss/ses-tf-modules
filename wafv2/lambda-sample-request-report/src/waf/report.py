from pprint import pprint


def apply_path_filter(samples, paths):
    if not paths:
        return samples

    def contains_path(_sample) -> bool:
        for path in paths:
            if path in _sample['Request']['URI']:
                return True
        return False

    return [sample for sample in samples if contains_path(sample)]


def create_report(type: str, samples):
    for sample in samples:
        cw_record = {
            'type': type,
            'record': sample
        }
        print(cw_record)

