class DotDict(dict):
    """Class as container for table filters. Filters are lazily evaluated."""
    __getattr__ = dict.get
    __setattr__ = dict.__setitem__
    __delattr__ = dict.__delitem__

