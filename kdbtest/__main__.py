"""Python's unittest main entry point, extended to include coverage"""
import os
import sys
import unittest

try:
    import coverage

    HAVE_COVERAGE = True
except ImportError:
    HAVE_COVERAGE = False

if sys.argv[0].endswith("__main__.py"):
    # We change sys.argv[0] to make help message more useful
    # use executable without path, unquoted
    # (it's just a hint anyway)
    # (if you have spaces in your executable you get what you deserve!)
    executable = os.path.basename(sys.executable)
    sys.argv[0] = executable + " -m unittest"

__unittest = True

html_dir = 'test_coverage'
cov = None
if HAVE_COVERAGE:
    cov = coverage.Coverage(branch=True)
    cov._warn_no_data = False
    cov.exclude(r'\@abc\.abstract', 'partial')
    cov.start()

try:
    loader = unittest.TestLoader()
    _current_dir = os.path.dirname(__file__)
    suite = loader.discover(_current_dir + '/../tests')
    runner = unittest.TextTestRunner()
    runner.run(suite)
finally:
    if cov is not None:
        cov.stop()
        cov.save()
        cov.html_report(directory=html_dir, title='DapGen test coverage')
